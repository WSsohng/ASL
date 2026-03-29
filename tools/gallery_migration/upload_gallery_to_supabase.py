#!/usr/bin/env python3
"""
Upload migrated gallery image assets to Supabase Storage and emit URL manifest.

Required env:
- SUPABASE_URL
- SUPABASE_SERVICE_ROLE_KEY

Example:
  python tools/gallery_migration/upload_gallery_to_supabase.py \
    --bucket asl-gallery \
    --gallery-json data/gallery_migration/gallery-data.json \
    --manifest data/gallery_migration/supabase_upload_manifest.json
"""

from __future__ import annotations

import argparse
import json
import os
import time
from dataclasses import dataclass, asdict
from pathlib import Path
from typing import Dict, List, Tuple
from urllib.parse import quote

import requests


@dataclass
class UploadResult:
    local_path: str
    bucket_path: str
    public_url: str
    status: str
    bytes_size: int
    error: str


def read_json(path: Path):
    return json.loads(path.read_text(encoding="utf-8"))


def write_json(path: Path, payload):
    path.parent.mkdir(parents=True, exist_ok=True)
    path.write_text(json.dumps(payload, ensure_ascii=False, indent=2), encoding="utf-8")


def normalize_path(p: str) -> str:
    return p.replace("\\", "/").lstrip("./")


def extract_unique_local_paths(gallery_data: List[dict]) -> List[str]:
    seen = set()
    out = []
    for row in gallery_data:
        for p in row.get("images", []):
            n = normalize_path(str(p))
            if n and n not in seen:
                seen.add(n)
                out.append(n)
    return out


def upload_one(
    session: requests.Session,
    supabase_url: str,
    service_key: str,
    bucket: str,
    local_abs: Path,
    bucket_path: str,
    timeout: int,
    retries: int,
) -> Tuple[str, str]:
    object_endpoint = (
        f"{supabase_url.rstrip('/')}/storage/v1/object/{quote(bucket, safe='')}/{quote(bucket_path, safe='/')}"
    )
    data = local_abs.read_bytes()
    headers = {
        "apikey": service_key,
        "Authorization": f"Bearer {service_key}",
        "x-upsert": "true",
        "Content-Type": "application/octet-stream",
    }
    last_error = ""
    for attempt in range(retries):
        try:
            resp = session.post(object_endpoint, headers=headers, data=data, timeout=timeout)
            if resp.status_code in (200, 201):
                return "ok", ""
            last_error = f"{resp.status_code} {resp.text[:500]}"
        except Exception as exc:
            last_error = str(exc)
        time.sleep(min(1.5, 0.25 * (attempt + 1)))
    return "error", last_error


def build_parser() -> argparse.ArgumentParser:
    p = argparse.ArgumentParser(description="Upload gallery images to Supabase Storage")
    p.add_argument("--bucket", required=True, help="Supabase storage bucket name")
    p.add_argument("--gallery-json", default="data/gallery_migration/gallery-data.json")
    p.add_argument("--repo-root", default=".")
    p.add_argument("--manifest", default="data/gallery_migration/supabase_upload_manifest.json")
    p.add_argument("--prefix", default="gallery/imported", help="Storage object prefix")
    p.add_argument("--supabase-url", default="", help="Optional explicit Supabase URL (used in dry-run URL generation)")
    p.add_argument("--timeout", type=int, default=60)
    p.add_argument("--retries", type=int, default=3)
    p.add_argument("--dry-run", action="store_true", help="Do not upload, only emit planned manifest")
    return p


def main() -> int:
    args = build_parser().parse_args()
    repo_root = Path(args.repo_root).resolve()
    gallery_json_path = (repo_root / args.gallery_json).resolve()
    manifest_path = (repo_root / args.manifest).resolve()

    supabase_url = (args.supabase_url or os.getenv("SUPABASE_URL", "")).strip()
    service_key = os.getenv("SUPABASE_SERVICE_ROLE_KEY", "").strip()
    if not args.dry_run and (not supabase_url or not service_key):
        raise SystemExit(
            "Missing env. Set SUPABASE_URL and SUPABASE_SERVICE_ROLE_KEY, or run with --dry-run."
        )

    gallery_data = read_json(gallery_json_path)
    local_paths = extract_unique_local_paths(gallery_data)

    session = requests.Session()
    results: List[UploadResult] = []
    ok = 0
    fail = 0

    for rel in local_paths:
        local_abs = (repo_root / rel).resolve()
        if not local_abs.exists():
            results.append(
                UploadResult(
                    local_path=rel,
                    bucket_path="",
                    public_url="",
                    status="missing",
                    bytes_size=0,
                    error="local file not found",
                )
            )
            fail += 1
            continue

        rel_after_assets = rel
        if rel_after_assets.startswith("assets/"):
            rel_after_assets = rel_after_assets[len("assets/") :]
        bucket_path = f"{args.prefix.rstrip('/')}/{rel_after_assets.lstrip('/')}"
        public_url = (
            f"{supabase_url.rstrip('/')}/storage/v1/object/public/"
            f"{quote(args.bucket, safe='')}/{quote(bucket_path, safe='/')}"
            if supabase_url
            else ""
        )
        if args.dry_run:
            results.append(
                UploadResult(
                    local_path=rel,
                    bucket_path=bucket_path,
                    public_url=public_url,
                    status="planned",
                    bytes_size=local_abs.stat().st_size,
                    error="",
                )
            )
            ok += 1
            continue

        status, error = upload_one(
            session=session,
            supabase_url=supabase_url,
            service_key=service_key,
            bucket=args.bucket,
            local_abs=local_abs,
            bucket_path=bucket_path,
            timeout=args.timeout,
            retries=args.retries,
        )
        if status == "ok":
            ok += 1
        else:
            fail += 1
        results.append(
            UploadResult(
                local_path=rel,
                bucket_path=bucket_path,
                public_url=public_url,
                status=status,
                bytes_size=local_abs.stat().st_size,
                error=error,
            )
        )

    manifest = {
        "bucket": args.bucket,
        "prefix": args.prefix,
        "total": len(results),
        "ok": ok,
        "failed": fail,
        "items": [asdict(r) for r in results],
    }
    write_json(manifest_path, manifest)
    print(
        f"[done] total={manifest['total']} ok={manifest['ok']} failed={manifest['failed']} manifest={manifest_path}"
    )
    return 0


if __name__ == "__main__":
    raise SystemExit(main())
