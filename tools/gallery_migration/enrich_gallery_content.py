#!/usr/bin/env python3
"""Enrich gallery post body content from legacy detail pages into SQLite + JSON artifacts."""

from __future__ import annotations

import argparse
import re
import sqlite3
import subprocess
import sys
import time
from pathlib import Path
from typing import List, Tuple

import requests
from bs4 import BeautifulSoup

USER_AGENT = (
    "Mozilla/5.0 (Windows NT 10.0; Win64; x64) "
    "AppleWebKit/537.36 (KHTML, like Gecko) "
    "Chrome/122.0.0.0 Safari/537.36 ASL-Gallery-Content-Enricher/1.0"
)


def fetch_html(session: requests.Session, url: str, timeout: int, retries: int = 3) -> str:
    last = None
    for i in range(retries):
        try:
            resp = session.get(url, timeout=timeout)
            resp.raise_for_status()
            if not resp.encoding or resp.encoding.lower() in {"iso-8859-1", "ascii"}:
                resp.encoding = "euc-kr"
            return resp.text
        except Exception as exc:  # noqa: BLE001
            last = exc
            time.sleep(0.2 * (i + 1))
    raise RuntimeError(f"fetch failed: {url} | {last}")


def extract_post_content(html: str, title: str) -> str:
    soup = BeautifulSoup(html, "html.parser")
    for tag in soup(["script", "style", "noscript"]):
        tag.decompose()

    title_norm = re.sub(r"\s+", " ", (title or "")).strip()
    raw_lines = [re.sub(r"\s+", " ", x).strip() for x in soup.get_text("\n", strip=True).splitlines()]
    lines: List[str] = []
    for line in raw_lines:
        if line and line not in lines:
            lines.append(line)

    start_idx = 0
    for i, line in enumerate(lines):
        if "등록일" in line:
            start_idx = i + 1
            break

    stop_keywords = ("리스트", "COPYRIGHT", "한양대 ASL 분광분석연구실")
    blocked_contains = (
        "Professor Research",
        "Research Field | Publication",
        "Lecture | Experiment",
        "Professor Research Member Lecture Gallery",
        "Gallery ",
        "이름 :",
        "등록일",
    )

    picked: List[str] = []
    for line in lines[start_idx:]:
        low = line.lower()
        if any(k in line for k in stop_keywords):
            break
        if (
            not line
            or len(line) < 6
            or len(line) > 500
            or line == title_norm
            or low in {"content", "컨텐츠 바로가기", "콘텐츠 바로가기"}
            or any(k.lower() in low for k in blocked_contains)
        ):
            continue
        picked.append(line)
    return "\n\n".join(picked[:6]).strip()


def ensure_column(conn: sqlite3.Connection) -> None:
    cur = conn.cursor()
    try:
        cur.execute("ALTER TABLE gallery_posts ADD COLUMN content TEXT DEFAULT ''")
    except Exception:
        pass
    conn.commit()


def fetch_targets(conn: sqlite3.Connection, force: bool) -> List[Tuple[str, str, str]]:
    cur = conn.cursor()
    if force:
        cur.execute("SELECT post_id, source_url, COALESCE(title,'') FROM gallery_posts ORDER BY CAST(source_present_num AS INTEGER) DESC")
    else:
        cur.execute(
            "SELECT post_id, source_url, COALESCE(title,'') FROM gallery_posts "
            "WHERE COALESCE(content,'')='' ORDER BY CAST(source_present_num AS INTEGER) DESC"
        )
    return [(str(a), str(b), str(c)) for a, b, c in cur.fetchall() if b]


def main() -> int:
    p = argparse.ArgumentParser(description="Enrich gallery content field from legacy source URLs")
    p.add_argument("--db", default="data/gallery_migration/gallery_archive.db")
    p.add_argument("--timeout", type=int, default=20)
    p.add_argument("--force", action="store_true", help="Re-scrape all posts (not only empty content)")
    p.add_argument("--limit", type=int, default=0, help="Optional max number of posts to process")
    p.add_argument(
        "--export-json",
        action="store_true",
        help="Run export_from_db.py after enrichment to rebuild JSON artifacts",
    )
    args = p.parse_args()

    db_path = Path(args.db)
    if not db_path.exists():
        print(f"DB not found: {db_path}", file=sys.stderr)
        return 2

    conn = sqlite3.connect(db_path)
    ensure_column(conn)
    targets = fetch_targets(conn, args.force)
    if args.limit and args.limit > 0:
        targets = targets[: args.limit]

    session = requests.Session()
    session.headers.update({"User-Agent": USER_AGENT})

    ok = 0
    fail = 0
    cur = conn.cursor()
    for post_id, url, title in targets:
        try:
            html = fetch_html(session, url, args.timeout)
            content = extract_post_content(html, title)
            cur.execute(
                "UPDATE gallery_posts SET content=? WHERE post_id=?",
                (content, post_id),
            )
            ok += 1
        except Exception as exc:  # noqa: BLE001
            print(f"[warn] {post_id} {url} :: {exc}")
            fail += 1
    conn.commit()
    conn.close()

    print(f"[done] targets={len(targets)} ok={ok} fail={fail}")

    if args.export_json:
        cmd = [
            sys.executable,
            str(Path(__file__).with_name("export_from_db.py")),
            "--db",
            str(db_path),
            "--output-dir",
            str(db_path.parent),
        ]
        subprocess.run(cmd, check=True)
    return 0


if __name__ == "__main__":
    raise SystemExit(main())
