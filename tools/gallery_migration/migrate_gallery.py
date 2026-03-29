#!/usr/bin/env python3
"""
ASL legacy gallery migration tool.

Pipeline:
1) Crawl list pages (boardIndex=2, sub=1) including pagination.
2) Collect detail-page URLs and parse post metadata + image URLs.
3) Normalize and persist into:
   - JSON artifacts
   - SQLite DB
4) Optionally download images and compute file integrity hashes.
5) Emit integrity report (JSON + Markdown).
"""

from __future__ import annotations

import argparse
import base64
import datetime as dt
import hashlib
import json
import re
import sqlite3
import sys
import time
from dataclasses import asdict, dataclass
from pathlib import Path
from typing import Any, Dict, Iterable, List, Optional, Set, Tuple
from urllib.parse import parse_qs, urlencode, urljoin, urlparse

import requests
from bs4 import BeautifulSoup

BASE_LIST_URL = "http://asl.hanyang.ac.kr/05.php?sub=1"
DEFAULT_TIMEOUT = 20
USER_AGENT = (
    "Mozilla/5.0 (Windows NT 10.0; Win64; x64) "
    "AppleWebKit/537.36 (KHTML, like Gecko) "
    "Chrome/122.0.0.0 Safari/537.36 ASL-Gallery-Migrator/1.0"
)


@dataclass
class PostRecord:
    post_id: str
    source_url: str
    title: str
    author: str
    date_text: str
    list_page_url: str
    list_page_num: Optional[int]
    thumb_url: str
    source_data_param: str
    source_idx: str
    source_letter_no: str
    source_present_num: str


@dataclass
class ImageRecord:
    post_id: str
    image_url: str
    sort_order: int
    is_cover: int
    local_path: str
    sha256: str
    bytes_size: int
    status: str
    error: str


def ensure_dir(path: Path) -> None:
    path.mkdir(parents=True, exist_ok=True)


def decode_legacy_data(data_value: str) -> Dict[str, str]:
    raw = data_value.replace("||", "")
    pad = "=" * ((4 - len(raw) % 4) % 4)
    try:
        decoded = base64.b64decode(raw + pad).decode("utf-8", errors="replace")
        qs = parse_qs(decoded)
        return {
            "idx": (qs.get("idx") or [""])[0],
            "letter_no": (qs.get("letter_no") or [""])[0],
            "present_num": (qs.get("present_num") or [""])[0],
            "offset": (qs.get("offset") or [""])[0],
            "pagecnt": (qs.get("pagecnt") or [""])[0],
        }
    except Exception:
        return {"idx": "", "letter_no": "", "present_num": "", "offset": "", "pagecnt": ""}


def extract_page_number(url: str) -> Optional[int]:
    parsed = urlparse(url)
    qs = parse_qs(parsed.query)
    data_v = (qs.get("data") or [""])[0]
    meta = decode_legacy_data(data_v)
    offset = meta.get("offset", "")
    if offset.isdigit():
        return int(offset) // 12 + 1
    return None


def fetch_html(
    session: requests.Session,
    url: str,
    timeout: int,
    referer: str = "",
    retries: int = 3,
) -> str:
    last_exc: Optional[Exception] = None
    for attempt in range(retries):
        try:
            headers = {"Referer": referer} if referer else {}
            resp = session.get(url, timeout=timeout, headers=headers)
            resp.raise_for_status()
            if not resp.encoding or resp.encoding.lower() in {"iso-8859-1", "ascii"}:
                resp.encoding = "euc-kr"
            return resp.text
        except Exception as exc:
            last_exc = exc
            time.sleep(min(1.2, 0.25 * (attempt + 1)))
    raise RuntimeError(f"fetch failed after retries: {url} | {last_exc}")


def parse_onclick_location(onclick: str) -> str:
    m = re.search(r"location\.href\s*=\s*'([^']+)'", onclick or "")
    return m.group(1) if m else ""


def normalize_url(base_url: str, href: str) -> str:
    return urljoin(base_url, href)


def parse_list_page(
    html: str, page_url: str
) -> Tuple[List[Tuple[str, str]], Set[str]]:
    soup = BeautifulSoup(html, "html.parser")
    detail_items: List[Tuple[str, str]] = []
    next_pages: Set[str] = set()

    for a in soup.find_all("a"):
        onclick = a.get("onclick", "")
        href_from_click = parse_onclick_location(onclick)
        href_attr = a.get("href", "")
        candidate = href_from_click or href_attr
        if not candidate:
            continue
        full = normalize_url(page_url, candidate)
        if "boardIndex=2" in full and "sub=1" in full:
            if "type=view" in full:
                img = a.find("img")
                thumb = normalize_url(page_url, img.get("src", "").strip()) if img and img.get("src") else ""
                detail_items.append((full, thumb))
            elif "type=view" not in full and "javascript:" not in candidate.lower():
                next_pages.add(full)

    # explicit pagination hrefs
    for a in soup.find_all("a", href=True):
        href = a["href"]
        full = normalize_url(page_url, href)
        if "boardIndex=2" in full and "sub=1" in full and "type=view" not in full:
            next_pages.add(full)

    # dedupe preserving order for details
    seen: Set[str] = set()
    deduped: List[Tuple[str, str]] = []
    for u, t in detail_items:
        if u in seen:
            continue
        seen.add(u)
        deduped.append((u, t))

    return deduped, next_pages


def parse_detail_page(
    html: str, detail_url: str, list_page_url: str, list_page_num: Optional[int], thumb_url: str
) -> Tuple[PostRecord, List[str]]:
    soup = BeautifulSoup(html, "html.parser")
    text = soup.get_text("\n", strip=True)

    parsed = urlparse(detail_url)
    q = parse_qs(parsed.query)
    data_v = (q.get("data") or [""])[0]
    meta = decode_legacy_data(data_v)
    idx = meta.get("idx", "") or ""
    letter_no = meta.get("letter_no", "") or ""
    present_num = meta.get("present_num", "") or ""
    post_id = idx or present_num or letter_no or hashlib.sha1(detail_url.encode("utf-8")).hexdigest()[:12]

    # title: strongest signals first
    title = ""
    b = soup.find("b")
    if b and b.get_text(strip=True):
        title = b.get_text(" ", strip=True)
    if not title:
        m = re.search(r"<B>\s*(.*?)\s*</B>", html, flags=re.IGNORECASE | re.DOTALL)
        if m:
            title = BeautifulSoup(m.group(1), "html.parser").get_text(" ", strip=True)

    # author/date line extraction from raw HTML around "이름/등록일" area (legacy Korean EUC-KR)
    author = ""
    date_text = ""
    line_match = re.search(r":[^<]{0,120}(&nbsp;){2,}[^<]{0,120}", html)
    if line_match:
        line = BeautifulSoup(line_match.group(0).replace("&nbsp;", " "), "html.parser").get_text(" ", strip=True)
        # try date (MM-DD or YYYY-MM-DD)
        dm = re.search(r"(\d{4}-\d{2}-\d{2}|\d{2}-\d{2})", line)
        if dm:
            date_text = dm.group(1)
        # author as the token nearest first colon and before date
        pieces = [p.strip() for p in re.split(r"\s{2,}", line) if p.strip()]
        if pieces:
            author = pieces[0].split(":")[-1].strip()

    if not title:
        # fallback: first "long-ish" content line from text
        for ln in text.splitlines():
            ln = ln.strip()
            if len(ln) >= 4 and len(ln) <= 160 and "Gallery" not in ln:
                title = ln
                break

    image_urls: List[str] = []
    for img in soup.find_all("img"):
        src = (img.get("src") or "").strip()
        if not src:
            continue
        full = normalize_url(detail_url, src)
        if "/upload/bbs/" in full:
            image_urls.append(full)

    # keep order and remove duplicates
    uniq: List[str] = []
    seen: Set[str] = set()
    for u in image_urls:
        if u in seen:
            continue
        seen.add(u)
        uniq.append(u)

    post = PostRecord(
        post_id=str(post_id),
        source_url=detail_url,
        title=title.strip(),
        author=author.strip(),
        date_text=date_text.strip(),
        list_page_url=list_page_url,
        list_page_num=list_page_num,
        thumb_url=thumb_url,
        source_data_param=data_v,
        source_idx=idx,
        source_letter_no=letter_no,
        source_present_num=present_num,
    )
    return post, uniq


def looks_like_blocked_or_placeholder(post: PostRecord, image_urls: List[str]) -> bool:
    title_norm = (post.title or "").strip().lower()
    if title_norm in {"컨텐츠 바로가기", "content"}:
        return True
    if not image_urls and (not post.title or len(post.title) < 2):
        return True
    return False


def safe_file_name(name: str) -> str:
    return re.sub(r"[^A-Za-z0-9._-]+", "_", name).strip("_") or "file"


def download_image(
    session: requests.Session,
    image_url: str,
    dest_path: Path,
    timeout: int,
) -> Tuple[str, int, str, str]:
    try:
        resp = session.get(image_url, timeout=timeout)
        resp.raise_for_status()
        data = resp.content
        ensure_dir(dest_path.parent)
        dest_path.write_bytes(data)
        sha = hashlib.sha256(data).hexdigest()
        return "ok", len(data), sha, ""
    except Exception as exc:
        return "error", 0, "", str(exc)


def init_db(db_path: Path) -> sqlite3.Connection:
    ensure_dir(db_path.parent)
    conn = sqlite3.connect(db_path)
    cur = conn.cursor()
    cur.execute(
        """
        CREATE TABLE IF NOT EXISTS gallery_posts (
          post_id TEXT PRIMARY KEY,
          source_url TEXT NOT NULL,
          title TEXT,
          author TEXT,
          date_text TEXT,
          list_page_url TEXT,
          list_page_num INTEGER,
          thumb_url TEXT,
          source_data_param TEXT,
          source_idx TEXT,
          source_letter_no TEXT,
          source_present_num TEXT,
          expected_image_count INTEGER NOT NULL,
          migrated_at TEXT NOT NULL
        )
        """
    )
    cur.execute(
        """
        CREATE TABLE IF NOT EXISTS gallery_images (
          post_id TEXT NOT NULL,
          image_url TEXT NOT NULL,
          sort_order INTEGER NOT NULL,
          is_cover INTEGER NOT NULL,
          local_path TEXT,
          sha256 TEXT,
          bytes_size INTEGER,
          status TEXT NOT NULL,
          error TEXT,
          migrated_at TEXT NOT NULL,
          PRIMARY KEY (post_id, image_url),
          FOREIGN KEY(post_id) REFERENCES gallery_posts(post_id)
        )
        """
    )
    cur.execute(
        """
        CREATE TABLE IF NOT EXISTS migration_runs (
          run_id TEXT PRIMARY KEY,
          started_at TEXT NOT NULL,
          finished_at TEXT NOT NULL,
          list_pages_discovered INTEGER NOT NULL,
          posts_discovered INTEGER NOT NULL,
          posts_fetched INTEGER NOT NULL,
          posts_failed INTEGER NOT NULL,
          images_expected INTEGER NOT NULL,
          images_ok INTEGER NOT NULL,
          images_failed INTEGER NOT NULL
        )
        """
    )
    conn.commit()
    return conn


def write_json(path: Path, payload: Any) -> None:
    ensure_dir(path.parent)
    path.write_text(json.dumps(payload, ensure_ascii=False, indent=2), encoding="utf-8")


def write_markdown_report(path: Path, report: Dict[str, Any]) -> None:
    lines = [
        "# Gallery Migration Integrity Report",
        "",
        f"- Run ID: `{report['run_id']}`",
        f"- Started: `{report['started_at']}`",
        f"- Finished: `{report['finished_at']}`",
        "",
        "## Summary",
        f"- List pages discovered: **{report['list_pages_discovered']}**",
        f"- Unique list page numbers: **{report.get('list_pages_unique_number_count', 0)}** "
        f"({report.get('list_pages_unique_numbers', [])})",
        f"- Posts discovered: **{report['posts_discovered']}**",
        f"- Posts fetched: **{report['posts_fetched']}**",
        f"- Posts failed: **{report['posts_failed']}**",
        f"- Images expected: **{report['images_expected']}**",
        f"- Images downloaded OK: **{report['images_ok']}**",
        f"- Images failed: **{report['images_failed']}**",
        "",
        "## Checks",
        f"- Missing post details: **{len(report.get('failed_posts', []))}**",
        f"- Posts with zero images: **{len(report.get('posts_with_zero_images', []))}**",
        f"- Duplicate image hashes: **{len(report.get('duplicate_hash_groups', []))} groups**",
        "",
    ]

    if report.get("failed_posts"):
        lines.append("## Failed Posts")
        for p in report["failed_posts"]:
            lines.append(f"- {p}")
        lines.append("")

    if report.get("posts_with_zero_images"):
        lines.append("## Posts With Zero Images")
        for p in report["posts_with_zero_images"]:
            lines.append(f"- {p}")
        lines.append("")

    if report.get("image_failures"):
        lines.append("## Image Failures")
        for item in report["image_failures"][:200]:
            lines.append(f"- {item['post_id']} | {item['image_url']} | {item['error']}")
        lines.append("")

    ensure_dir(path.parent)
    path.write_text("\n".join(lines), encoding="utf-8")


def crawl(args: argparse.Namespace) -> int:
    started = dt.datetime.now(dt.timezone.utc)
    run_id = started.strftime("%Y%m%dT%H%M%SZ")

    output_dir = Path(args.output_dir)
    asset_dir = Path(args.asset_dir)
    ensure_dir(output_dir)
    ensure_dir(asset_dir)

    session = requests.Session()
    session.headers.update({"User-Agent": USER_AGENT})

    list_queue: List[str] = [args.start_url]
    list_seen: Set[str] = set()
    detail_seen: Set[str] = set()
    detail_tasks: List[Tuple[str, str, str, Optional[int]]] = []
    list_page_map: Dict[str, Dict[str, Any]] = {}

    # Phase 1: list crawl
    while list_queue:
        url = list_queue.pop(0)
        if url in list_seen:
            continue
        list_seen.add(url)
        if args.max_pages and len(list_seen) > args.max_pages:
            break
        try:
            html = fetch_html(session, url, args.timeout)
        except Exception as exc:
            list_page_map[url] = {"error": str(exc), "items": []}
            continue

        items, next_pages = parse_list_page(html, url)
        page_num = extract_page_number(url)
        list_page_map[url] = {
            "page_num": page_num,
            "item_count": len(items),
            "next_page_count": len(next_pages),
            "items": [{"detail_url": i[0], "thumb_url": i[1]} for i in items],
        }
        for detail_url, thumb_url in items:
            if detail_url in detail_seen:
                continue
            detail_seen.add(detail_url)
            detail_tasks.append((detail_url, thumb_url, url, page_num))
        for nxt in sorted(next_pages):
            if nxt not in list_seen and nxt not in list_queue:
                list_queue.append(nxt)

    # Phase 2: detail parse + optional image download
    posts: List[PostRecord] = []
    images: List[ImageRecord] = []
    failed_posts: List[str] = []

    for detail_url, thumb_url, src_list_url, page_num in detail_tasks:
        try:
            detail_html = fetch_html(
                session, detail_url, args.timeout, referer=src_list_url, retries=4
            )
            post, image_urls = parse_detail_page(detail_html, detail_url, src_list_url, page_num, thumb_url)
            if looks_like_blocked_or_placeholder(post, image_urls):
                # retry once with stronger pacing in case of intermittent legacy-server response
                time.sleep(0.45)
                detail_html_retry = fetch_html(
                    session, detail_url, args.timeout, referer=src_list_url, retries=4
                )
                post_retry, images_retry = parse_detail_page(
                    detail_html_retry, detail_url, src_list_url, page_num, thumb_url
                )
                if len(images_retry) > len(image_urls) or (
                    post_retry.title and post_retry.title.strip().lower() != "컨텐츠 바로가기"
                ):
                    post, image_urls = post_retry, images_retry
            posts.append(post)

            for idx, image_url in enumerate(image_urls, start=1):
                filename = safe_file_name(urlparse(image_url).path.split("/")[-1] or f"img_{idx:03d}.bin")
                local_rel = Path(args.asset_dir) / post.post_id / f"{idx:02d}_{filename}"
                local_abs = Path(args.repo_root) / local_rel

                status = "skipped"
                size = 0
                sha = ""
                error = ""
                if args.download_images:
                    status, size, sha, error = download_image(
                        session=session,
                        image_url=image_url,
                        dest_path=local_abs,
                        timeout=args.timeout,
                    )

                images.append(
                    ImageRecord(
                        post_id=post.post_id,
                        image_url=image_url,
                        sort_order=idx,
                        is_cover=1 if idx == 1 else 0,
                        local_path=str(local_rel).replace("\\", "/"),
                        sha256=sha,
                        bytes_size=size,
                        status=status,
                        error=error,
                    )
                )
        except Exception as exc:
            failed_posts.append(f"{detail_url} | {exc}")

    # Guardrail: avoid overwriting artifacts with partial/blocked crawl results.
    guard_min_posts = args.min_posts_guard
    if guard_min_posts < 0:
        guard_min_posts = 0
    if args.max_pages:
        guard_min_posts = 0
    if len(posts) < guard_min_posts:
        raise RuntimeError(
            f"Safety guard: fetched posts {len(posts)} is lower than min_posts_guard {guard_min_posts}. "
            "Aborting artifact overwrite."
        )

    # Sort for deterministic output
    posts.sort(key=lambda p: (int(p.source_present_num) if p.source_present_num.isdigit() else -1), reverse=True)
    images.sort(key=lambda i: (i.post_id, i.sort_order))

    image_by_post: Dict[str, List[ImageRecord]] = {}
    for img in images:
        image_by_post.setdefault(img.post_id, []).append(img)

    gallery_data = []
    for p in posts:
        imgs = image_by_post.get(p.post_id, [])
        gallery_data.append(
            {
                "id": p.post_id,
                "title": p.title,
                "author": p.author,
                "date": p.date_text,
                "source_url": p.source_url,
                "source_idx": p.source_idx,
                "source_letter_no": p.source_letter_no,
                "source_present_num": p.source_present_num,
                "list_page_num": p.list_page_num,
                "thumbnail": p.thumb_url,
                "images": [i.local_path for i in imgs],
                "image_meta": [asdict(i) for i in imgs],
            }
        )

    # JSON artifacts
    posts_json = [asdict(p) for p in posts]
    images_json = [asdict(i) for i in images]
    index_json = {
        "run_id": run_id,
        "start_url": args.start_url,
        "list_pages": list_page_map,
        "list_page_count": len(list_page_map),
        "detail_count": len(detail_tasks),
    }

    write_json(output_dir / "source_gallery_index.json", index_json)
    write_json(output_dir / "normalized_gallery_posts.json", posts_json)
    write_json(output_dir / "normalized_gallery_images.json", images_json)
    write_json(output_dir / "gallery-data.json", gallery_data)

    # SQLite
    db_path = output_dir / "gallery_archive.db"
    conn = init_db(db_path)
    cur = conn.cursor()
    migrated_at = dt.datetime.now(dt.timezone.utc).isoformat()
    for p in posts:
        expected_count = sum(1 for i in images if i.post_id == p.post_id)
        cur.execute(
            """
            INSERT INTO gallery_posts (
              post_id, source_url, title, author, date_text, list_page_url, list_page_num,
              thumb_url, source_data_param, source_idx, source_letter_no, source_present_num,
              expected_image_count, migrated_at
            ) VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?)
            ON CONFLICT(post_id) DO UPDATE SET
              source_url=excluded.source_url,
              title=CASE WHEN excluded.title='' THEN gallery_posts.title ELSE excluded.title END,
              author=CASE WHEN excluded.author='' THEN gallery_posts.author ELSE excluded.author END,
              date_text=CASE WHEN excluded.date_text='' THEN gallery_posts.date_text ELSE excluded.date_text END,
              list_page_url=CASE WHEN excluded.list_page_url='' THEN gallery_posts.list_page_url ELSE excluded.list_page_url END,
              list_page_num=COALESCE(excluded.list_page_num, gallery_posts.list_page_num),
              thumb_url=CASE WHEN excluded.thumb_url='' THEN gallery_posts.thumb_url ELSE excluded.thumb_url END,
              source_data_param=excluded.source_data_param,
              source_idx=excluded.source_idx,
              source_letter_no=excluded.source_letter_no,
              source_present_num=excluded.source_present_num,
              expected_image_count=CASE
                WHEN excluded.expected_image_count > 0 THEN excluded.expected_image_count
                ELSE gallery_posts.expected_image_count
              END,
              migrated_at=excluded.migrated_at
            """,
            (
                p.post_id,
                p.source_url,
                p.title,
                p.author,
                p.date_text,
                p.list_page_url,
                p.list_page_num,
                p.thumb_url,
                p.source_data_param,
                p.source_idx,
                p.source_letter_no,
                p.source_present_num,
                expected_count,
                migrated_at,
            ),
        )
    for i in images:
        cur.execute(
            """
            INSERT INTO gallery_images (
              post_id, image_url, sort_order, is_cover, local_path, sha256, bytes_size,
              status, error, migrated_at
            ) VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?)
            ON CONFLICT(post_id, image_url) DO UPDATE SET
              sort_order=excluded.sort_order,
              is_cover=excluded.is_cover,
              local_path=CASE WHEN excluded.local_path='' THEN gallery_images.local_path ELSE excluded.local_path END,
              sha256=CASE WHEN excluded.sha256='' THEN gallery_images.sha256 ELSE excluded.sha256 END,
              bytes_size=CASE WHEN excluded.bytes_size > 0 THEN excluded.bytes_size ELSE gallery_images.bytes_size END,
              status=CASE
                WHEN excluded.status='ok' THEN 'ok'
                WHEN gallery_images.status='ok' THEN 'ok'
                ELSE excluded.status
              END,
              error=CASE WHEN excluded.error='' THEN gallery_images.error ELSE excluded.error END,
              migrated_at=excluded.migrated_at
            """,
            (
                i.post_id,
                i.image_url,
                i.sort_order,
                i.is_cover,
                i.local_path,
                i.sha256,
                i.bytes_size,
                i.status,
                i.error,
                migrated_at,
            ),
        )

    images_expected = len(images)
    images_ok = sum(1 for i in images if i.status == "ok")
    images_failed = sum(1 for i in images if i.status == "error")

    finished = dt.datetime.now(dt.timezone.utc)
    cur.execute(
        """
        INSERT INTO migration_runs (
          run_id, started_at, finished_at, list_pages_discovered, posts_discovered, posts_fetched,
          posts_failed, images_expected, images_ok, images_failed
        ) VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?)
        """,
        (
            run_id,
            started.isoformat(),
            finished.isoformat(),
            len(list_seen),
            len(detail_tasks),
            len(posts),
            len(failed_posts),
            images_expected,
            images_ok,
            images_failed,
        ),
    )
    conn.commit()
    conn.close()

    # Integrity report
    posts_with_zero_images = []
    image_count_map: Dict[str, int] = {}
    for img in images:
        image_count_map[img.post_id] = image_count_map.get(img.post_id, 0) + 1
    for p in posts:
        if image_count_map.get(p.post_id, 0) == 0:
            posts_with_zero_images.append(f"{p.post_id} | {p.title} | {p.source_url}")

    hash_groups: Dict[str, List[str]] = {}
    for img in images:
        if img.sha256:
            hash_groups.setdefault(img.sha256, []).append(img.local_path)
    duplicate_hash_groups = [
        {"sha256": h, "files": files}
        for h, files in hash_groups.items()
        if len(files) > 1
    ]

    image_failures = [
        {"post_id": i.post_id, "image_url": i.image_url, "error": i.error}
        for i in images
        if i.status == "error"
    ]

    unique_page_nums = sorted(
        {
            v.get("page_num")
            for v in list_page_map.values()
            if isinstance(v, dict) and isinstance(v.get("page_num"), int)
        }
    )

    report = {
        "run_id": run_id,
        "started_at": started.isoformat(),
        "finished_at": finished.isoformat(),
        "list_pages_discovered": len(list_seen),
        "list_pages_unique_number_count": len(unique_page_nums),
        "list_pages_unique_numbers": unique_page_nums,
        "posts_discovered": len(detail_tasks),
        "posts_fetched": len(posts),
        "posts_failed": len(failed_posts),
        "images_expected": images_expected,
        "images_ok": images_ok,
        "images_failed": images_failed,
        "failed_posts": failed_posts,
        "posts_with_zero_images": posts_with_zero_images,
        "duplicate_hash_groups": duplicate_hash_groups,
        "image_failures": image_failures,
    }

    write_json(output_dir / "integrity_report.json", report)
    write_markdown_report(output_dir / "integrity_report.md", report)

    print(f"[done] run_id={run_id}")
    print(
        "[summary] "
        f"list_pages={report['list_pages_discovered']} "
        f"posts_discovered={report['posts_discovered']} "
        f"posts_fetched={report['posts_fetched']} "
        f"images_ok={report['images_ok']} "
        f"images_failed={report['images_failed']}"
    )
    print(f"[artifacts] {output_dir}")
    return 0


def build_parser() -> argparse.ArgumentParser:
    p = argparse.ArgumentParser(description="Migrate ASL legacy gallery with integrity checks")
    p.add_argument("--start-url", default=BASE_LIST_URL, help="Legacy gallery list URL")
    p.add_argument("--repo-root", default=".", help="Repository root for local image writes")
    p.add_argument("--output-dir", default="data/gallery_migration", help="Output artifact directory")
    p.add_argument(
        "--asset-dir",
        default="assets/gallery/imported",
        help="Local image asset root (relative to repo root)",
    )
    p.add_argument("--timeout", type=int, default=DEFAULT_TIMEOUT, help="HTTP timeout seconds")
    p.add_argument("--max-pages", type=int, default=0, help="Optional safety cap for list pages")
    p.add_argument(
        "--min-posts-guard",
        type=int,
        default=100,
        help="Abort if fetched posts are fewer than this value (set 0 to disable)",
    )
    p.add_argument(
        "--download-images",
        action="store_true",
        help="Download image files into local assets and compute hashes",
    )
    return p


def main(argv: Optional[List[str]] = None) -> int:
    parser = build_parser()
    args = parser.parse_args(argv)
    args.repo_root = str(Path(args.repo_root).resolve())
    return crawl(args)


if __name__ == "__main__":
    raise SystemExit(main())
