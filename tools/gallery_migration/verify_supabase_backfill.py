"""
Verify Supabase row counts against local JSON source datasets.

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
from pathlib import Path
from typing import Any

import requests


ROOT = Path(__file__).resolve().parents[2]
PUBLICATION_JSON = ROOT / "assets" / "publication-data.json"
MEMBER_JSON = ROOT / "assets" / "member-data.json"
GALLERY_RUNTIME_JSON = ROOT / "data" / "gallery_migration" / "gallery-data.runtime.json"


def load_json(path: Path) -> Any:
    with path.open("r", encoding="utf-8") as f:
        return json.load(f)


def expected_publications() -> int:
    raw = load_json(PUBLICATION_JSON)
    total = 0
    for group_key, items in raw.items():
        for item in items or []:
            title = str(item.get("title", "")).strip()
            journal = str(item.get("journal", "")).strip()
            match = re.search(r"(19|20)\d{2}", str(group_key))
            if title and journal and match:
                total += 1
    return total


def expected_members() -> int:
    raw = load_json(MEMBER_JSON)
    total = 0
    for _, members in raw.items():
        if not isinstance(members, list):
            continue
        total += sum(1 for m in members if str(m.get("name", "")).strip())
    return total


def expected_gallery() -> tuple[int, int]:
    raw = load_json(GALLERY_RUNTIME_JSON)
    posts = len(raw)
    images = sum(len((x.get("images") or [])) for x in raw)
    return posts, images


def fetch_count(base_url: str, service_key: str, table: str, timeout: int) -> int:
    headers = {
        "apikey": service_key,
        "Authorization": f"Bearer {service_key}",
        "Prefer": "count=exact",
    }
    params = {"select": "id", "limit": 1}
    resp = requests.get(
        f"{base_url.rstrip('/')}/rest/v1/{table}",
        headers=headers,
        params=params,
        timeout=timeout,
    )
    if resp.status_code >= 300:
        raise RuntimeError(f"count query failed [{table}] {resp.status_code}: {resp.text[:400]}")
    count_header = resp.headers.get("Content-Range", "")
    # format: "0-0/223"
    if "/" not in count_header:
        return len(resp.json() or [])
    suffix = count_header.split("/")[-1].strip()
    if suffix and suffix != "*" and suffix.isdigit():
        return int(suffix)

    # Fallback when server returns unknown total, e.g. "0-0/*".
    # Count rows by paging through ids.
    page_size = 1000
    offset = 0
    total = 0
    while True:
        page_params = {"select": "id", "limit": page_size, "offset": offset}
        page_resp = requests.get(
            f"{base_url.rstrip('/')}/rest/v1/{table}",
            headers=headers,
            params=page_params,
            timeout=timeout,
        )
        if page_resp.status_code >= 300:
            raise RuntimeError(
                f"fallback count query failed [{table}] {page_resp.status_code}: {page_resp.text[:400]}"
            )
        rows = page_resp.json() or []
        n = len(rows)
        total += n
        if n < page_size:
            break
        offset += page_size
    return total


def main() -> int:
    parser = argparse.ArgumentParser(description="Verify Supabase backfill counts.")
    parser.add_argument("--timeout", type=int, default=30)
    parser.add_argument(
        "--report-out",
        default=str(ROOT / "data" / "gallery_migration" / "backfill_verify_report.json"),
    )
    args = parser.parse_args()

    supabase_url = os.getenv("SUPABASE_URL", "").strip()
    service_key = os.getenv("SUPABASE_SERVICE_ROLE_KEY", "").strip()
    if not supabase_url or not service_key:
        print("Missing SUPABASE_URL or SUPABASE_SERVICE_ROLE_KEY.", file=sys.stderr)
        return 2

    expected_posts, expected_images = expected_gallery()
    expected = {
        "publications": expected_publications(),
        "members": expected_members(),
        "gallery_posts": expected_posts,
        "gallery_images": expected_images,
    }
    actual = {
        "publications": fetch_count(supabase_url, service_key, "publications", args.timeout),
        "members": fetch_count(supabase_url, service_key, "members", args.timeout),
        "gallery_posts": fetch_count(supabase_url, service_key, "gallery_posts", args.timeout),
        "gallery_images": fetch_count(supabase_url, service_key, "gallery_images", args.timeout),
    }
    mismatch = {k: {"expected": expected[k], "actual": actual[k]} for k in expected if expected[k] != actual[k]}
    report = {"expected": expected, "actual": actual, "ok": not mismatch, "mismatch": mismatch}

    report_path = Path(args.report_out)
    report_path.parent.mkdir(parents=True, exist_ok=True)
    with report_path.open("w", encoding="utf-8") as f:
        json.dump(report, f, ensure_ascii=False, indent=2)

    print(json.dumps(report, ensure_ascii=False))
    return 0 if report["ok"] else 1


if __name__ == "__main__":
    raise SystemExit(main())
