"""
Backfill ASL Supabase tables from current JSON runtime data.

Targets:
- publications       <- assets/publication-data.json
- members            <- assets/member-data.json
- gallery_posts      <- data/gallery_migration/gallery-data.runtime.json
- gallery_images     <- data/gallery_migration/gallery-data.runtime.json

Env required:
- SUPABASE_URL
- SUPABASE_SERVICE_ROLE_KEY
"""

from __future__ import annotations

import argparse
import json
import os
import re
import sys
import uuid
from dataclasses import dataclass
from pathlib import Path
from typing import Any, Iterable

import requests


ROOT = Path(__file__).resolve().parents[2]
PUBLICATION_JSON = ROOT / "assets" / "publication-data.json"
MEMBER_JSON = ROOT / "assets" / "member-data.json"
GALLERY_RUNTIME_JSON = ROOT / "data" / "gallery_migration" / "gallery-data.runtime.json"


def load_json(path: Path) -> Any:
    with path.open("r", encoding="utf-8") as f:
        return json.load(f)


def detect_year(group_key: str, item: dict[str, Any]) -> int:
    candidate = str(item.get("year", "")).strip()
    if candidate.isdigit():
        return int(candidate)
    match = re.search(r"(19|20)\d{2}", group_key)
    if match:
        return int(match.group(0))
    return 0


def norm_text(value: Any) -> str:
    if value is None:
        return ""
    return str(value).strip()


def parse_numeric(value: Any) -> float | None:
    if value in (None, "", "N/A", "-", "n/a"):
        return None
    text = str(value).strip().replace(",", "")
    try:
        return float(text)
    except ValueError:
        return None


def is_missing_graphical(url: str) -> bool:
    u = url.strip().lower()
    if not u:
        return True
    return "no-graphical-abstract" in u or "publication-placeholder" in u


def stable_uuid(*parts: str) -> str:
    key = "|".join(parts)
    return str(uuid.uuid5(uuid.NAMESPACE_URL, key))


def parse_section_track(section_key: str) -> str:
    if section_key == "faculty":
        return "faculty"
    if section_key == "alumni":
        return "alumni"
    return "current"


@dataclass
class SupabaseRest:
    base_url: str
    service_role_key: str
    timeout: int

    def __post_init__(self) -> None:
        self.session = requests.Session()
        self.base_url = self.base_url.rstrip("/")
        self.headers = {
            "apikey": self.service_role_key,
            "Authorization": f"Bearer {self.service_role_key}",
            "Content-Type": "application/json",
        }

    def upsert(self, table: str, rows: list[dict[str, Any]], on_conflict: str | None = None) -> None:
        if not rows:
            return
        params = {"select": "id"}
        if on_conflict:
            params["on_conflict"] = on_conflict
        headers = dict(self.headers)
        headers["Prefer"] = "resolution=merge-duplicates,return=minimal"
        resp = self.session.post(
            f"{self.base_url}/rest/v1/{table}",
            params=params,
            headers=headers,
            data=json.dumps(rows, ensure_ascii=False).encode("utf-8"),
            timeout=self.timeout,
        )
        if resp.status_code >= 300:
            raise RuntimeError(f"upsert failed [{table}] {resp.status_code}: {resp.text[:400]}")


def chunked(items: list[dict[str, Any]], size: int) -> Iterable[list[dict[str, Any]]]:
    for i in range(0, len(items), size):
        yield items[i : i + size]


def build_publication_rows(raw: dict[str, list[dict[str, Any]]]) -> list[dict[str, Any]]:
    rows: list[dict[str, Any]] = []
    for group_key, items in raw.items():
        for i, item in enumerate(items or [], start=1):
            title = norm_text(item.get("title"))
            journal = norm_text(item.get("journal"))
            authors = norm_text(item.get("authors"))
            authors_marked = norm_text(item.get("authors_marked")) or authors
            year = detect_year(group_key, item)
            if not title or not journal or year <= 0:
                continue
            images = item.get("images") or []
            graphical = ""
            if isinstance(images, list) and images:
                first = norm_text(images[0])
                if not is_missing_graphical(first):
                    graphical = first
            row = {
                "id": stable_uuid("pub", str(year), title, journal),
                "title": title,
                "year": year,
                "journal": journal,
                "authors": authors,
                "authors_marked": authors_marked,
                "doi": norm_text(item.get("doi")) or None,
                "citations": int(parse_numeric(item.get("citations")) or 0),
                "impact_factor": parse_numeric(item.get("impact_factor")),
                "graphical_abstract_url": graphical or None,
                "pdf_url": norm_text(item.get("pdf")) or None,
                "source_key": f"{group_key}:{i}",
                "source_year_group": group_key,
            }
            rows.append(row)
    return rows


def build_member_rows(raw: dict[str, list[dict[str, Any]]]) -> list[dict[str, Any]]:
    rows: list[dict[str, Any]] = []
    for section_key, members in raw.items():
        if not isinstance(members, list):
            continue
        track = parse_section_track(section_key)
        for m in members:
            name = norm_text(m.get("name"))
            role = norm_text(m.get("role"))
            if not name:
                continue
            row = {
                "id": stable_uuid("member", track, name),
                "name": name,
                "name_ko": norm_text(m.get("name_ko")) or None,
                "role": role,
                "email": norm_text(m.get("email")) or None,
                "career": norm_text(m.get("career")) or None,
                "research": norm_text(m.get("research")) or None,
                "track": track,
                "image_url": norm_text(m.get("image")) or None,
                "source_image": norm_text(m.get("source_image")) or None,
                "source_section": norm_text(m.get("source_section")) or section_key,
            }
            rows.append(row)
    return rows


def build_gallery_rows(raw: list[dict[str, Any]]) -> tuple[list[dict[str, Any]], list[dict[str, Any]]]:
    posts: list[dict[str, Any]] = []
    images: list[dict[str, Any]] = []
    for post in raw:
        post_id = norm_text(post.get("id"))
        if not post_id:
            continue
        post_row = {
            "id": post_id,
            "title": norm_text(post.get("title")),
            "author": norm_text(post.get("author")),
            "date_text": norm_text(post.get("date")),
            "source_url": norm_text(post.get("source_url")),
            "source_idx": norm_text(post.get("source_idx")),
            "source_letter_no": norm_text(post.get("source_letter_no")),
            "source_present_num": norm_text(post.get("source_present_num")),
            "list_page_num": post.get("list_page_num"),
            "thumbnail_url": norm_text(post.get("thumbnail")),
        }
        posts.append(post_row)

        image_urls = post.get("images") or []
        image_meta = post.get("image_meta") or []
        meta_by_url = {}
        for meta in image_meta:
            url = norm_text(meta.get("image_url"))
            if url:
                meta_by_url[url] = meta
        for idx, image_url in enumerate(image_urls, start=1):
            u = norm_text(image_url)
            meta = meta_by_url.get(u, {})
            images.append(
                {
                    "post_id": post_id,
                    "image_url": u,
                    "local_path": norm_text(meta.get("local_path")) or u,
                    "sha256": norm_text(meta.get("sha256")),
                    "bytes_size": int(meta.get("bytes_size") or 0),
                    "sort_order": idx,
                    "is_cover": idx == 1,
                    "status": norm_text(meta.get("status")) or "ok",
                    "error": norm_text(meta.get("error")),
                }
            )
    return posts, images


def main() -> int:
    parser = argparse.ArgumentParser(description="Backfill Supabase from ASL JSON datasets.")
    parser.add_argument(
        "--only",
        choices=["all", "publications", "members", "gallery"],
        default="all",
        help="Scope to backfill.",
    )
    parser.add_argument("--chunk-size", type=int, default=200, help="REST upsert chunk size.")
    parser.add_argument("--timeout", type=int, default=60, help="HTTP timeout seconds.")
    parser.add_argument(
        "--report-out",
        default=str(ROOT / "data" / "gallery_migration" / "backfill_report.json"),
        help="Path to write backfill report JSON.",
    )
    args = parser.parse_args()

    supabase_url = os.getenv("SUPABASE_URL", "").strip()
    service_key = os.getenv("SUPABASE_SERVICE_ROLE_KEY", "").strip()
    if not supabase_url or not service_key:
        print("Missing SUPABASE_URL or SUPABASE_SERVICE_ROLE_KEY.", file=sys.stderr)
        return 2

    api = SupabaseRest(supabase_url, service_key, timeout=args.timeout)

    report: dict[str, Any] = {"scope": args.only, "counts": {}}

    try:
        if args.only in ("all", "publications"):
            pubs_raw = load_json(PUBLICATION_JSON)
            pub_rows = build_publication_rows(pubs_raw)
            for batch in chunked(pub_rows, args.chunk_size):
                api.upsert("publications", batch, on_conflict="title,journal,year")
            report["counts"]["publications"] = len(pub_rows)

        if args.only in ("all", "members"):
            members_raw = load_json(MEMBER_JSON)
            member_rows = build_member_rows(members_raw)
            for batch in chunked(member_rows, args.chunk_size):
                api.upsert("members", batch, on_conflict="name,track")
            report["counts"]["members"] = len(member_rows)

        if args.only in ("all", "gallery"):
            gallery_raw = load_json(GALLERY_RUNTIME_JSON)
            post_rows, image_rows = build_gallery_rows(gallery_raw)
            for batch in chunked(post_rows, args.chunk_size):
                api.upsert("gallery_posts", batch, on_conflict="id")
            for batch in chunked(image_rows, args.chunk_size):
                api.upsert("gallery_images", batch, on_conflict="post_id,sort_order")
            report["counts"]["gallery_posts"] = len(post_rows)
            report["counts"]["gallery_images"] = len(image_rows)

        report_path = Path(args.report_out)
        report_path.parent.mkdir(parents=True, exist_ok=True)
        with report_path.open("w", encoding="utf-8") as f:
            json.dump(report, f, ensure_ascii=False, indent=2)
        print(json.dumps(report, ensure_ascii=False))
        return 0
    except Exception as exc:  # noqa: BLE001
        print(f"Backfill failed: {exc}", file=sys.stderr)
        return 1


if __name__ == "__main__":
    raise SystemExit(main())

