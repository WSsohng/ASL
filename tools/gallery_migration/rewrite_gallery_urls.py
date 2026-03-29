#!/usr/bin/env python3
"""Rewrite gallery-data.json image paths using Supabase upload manifest."""

from __future__ import annotations

import argparse
import json
from pathlib import Path


def read_json(path: Path):
    return json.loads(path.read_text(encoding="utf-8"))


def write_json(path: Path, payload):
    path.parent.mkdir(parents=True, exist_ok=True)
    path.write_text(json.dumps(payload, ensure_ascii=False, indent=2), encoding="utf-8")


def normalize(p: str) -> str:
    return p.replace("\\", "/").lstrip("./")


def main() -> int:
    parser = argparse.ArgumentParser(description="Rewrite gallery data image URLs from upload manifest")
    parser.add_argument("--gallery-json", default="data/gallery_migration/gallery-data.json")
    parser.add_argument("--manifest", default="data/gallery_migration/supabase_upload_manifest.json")
    parser.add_argument("--out", default="data/gallery_migration/gallery-data.supabase.json")
    parser.add_argument("--strict", action="store_true", help="Fail if any image mapping is missing")
    parser.add_argument(
        "--include-planned",
        action="store_true",
        help="Also use manifest items with status=planned (useful with dry-run manifests)",
    )
    args = parser.parse_args()

    gallery_path = Path(args.gallery_json)
    manifest_path = Path(args.manifest)
    out_path = Path(args.out)

    gallery = read_json(gallery_path)
    manifest = read_json(manifest_path)
    mapping = {}
    allowed = {"ok"}
    if args.include_planned:
        allowed.add("planned")
    for item in manifest.get("items", []):
        if item.get("status") in allowed and item.get("public_url"):
            mapping[normalize(str(item["local_path"]))] = str(item["public_url"])

    missing = []
    rewritten = []
    for row in gallery:
        row_copy = dict(row)
        new_images = []
        for p in row.get("images", []):
            key = normalize(str(p))
            remote = mapping.get(key)
            if remote:
                new_images.append(remote)
            else:
                new_images.append(p)
                missing.append(key)
        row_copy["images"] = new_images
        rewritten.append(row_copy)

    if args.strict and missing:
        uniq_missing = sorted(set(missing))
        raise SystemExit(
            f"Missing {len(uniq_missing)} mappings in manifest. Example: {uniq_missing[:5]}"
        )

    write_json(out_path, rewritten)
    print(
        f"[done] rows={len(rewritten)} mapped={len(mapping)} missing_refs={len(set(missing))} out={out_path}"
    )
    return 0


if __name__ == "__main__":
    raise SystemExit(main())
