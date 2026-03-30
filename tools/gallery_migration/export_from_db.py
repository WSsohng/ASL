#!/usr/bin/env python3
"""Rebuild normalized JSON artifacts from gallery_archive.db."""

from __future__ import annotations

import argparse
import json
import sqlite3
from pathlib import Path


def write_json(path: Path, payload):
    path.parent.mkdir(parents=True, exist_ok=True)
    path.write_text(json.dumps(payload, ensure_ascii=False, indent=2), encoding="utf-8")


def main():
    parser = argparse.ArgumentParser(description="Export gallery artifacts from SQLite DB")
    parser.add_argument("--db", default="data/gallery_migration/gallery_archive.db")
    parser.add_argument("--output-dir", default="data/gallery_migration")
    args = parser.parse_args()

    db_path = Path(args.db)
    out_dir = Path(args.output_dir)
    conn = sqlite3.connect(db_path)
    conn.row_factory = sqlite3.Row
    cur = conn.cursor()

    posts = [dict(r) for r in cur.execute("SELECT * FROM gallery_posts ORDER BY CAST(source_present_num AS INTEGER) DESC")]
    images = [dict(r) for r in cur.execute("SELECT * FROM gallery_images ORDER BY post_id, sort_order")]
    runs = [
        dict(r)
        for r in cur.execute(
            "SELECT run_id, started_at, finished_at, posts_fetched, images_ok, images_failed "
            "FROM migration_runs ORDER BY rowid DESC"
        )
    ]

    by_post = {}
    for img in images:
        by_post.setdefault(img["post_id"], []).append(img)

    merged = []
    for p in posts:
        imgs = by_post.get(p["post_id"], [])
        merged.append(
            {
                "id": p["post_id"],
                "title": p.get("title", ""),
                "author": p.get("author", ""),
                "date": p.get("date_text", ""),
                "source_url": p.get("source_url", ""),
                "source_idx": p.get("source_idx", ""),
                "source_letter_no": p.get("source_letter_no", ""),
                "source_present_num": p.get("source_present_num", ""),
                "content": p.get("content", ""),
                "list_page_num": p.get("list_page_num"),
                "thumbnail": p.get("thumb_url", ""),
                "images": [i.get("local_path", "") for i in imgs],
                "image_meta": imgs,
            }
        )

    write_json(out_dir / "normalized_gallery_posts.json", posts)
    write_json(out_dir / "normalized_gallery_images.json", images)
    write_json(out_dir / "gallery-data.json", merged)

    images_ok = sum(1 for i in images if i.get("status") == "ok")
    images_failed = sum(1 for i in images if i.get("status") == "error")
    zero_posts = [p for p in merged if not p.get("images")]
    hash_groups = {}
    for i in images:
        h = i.get("sha256") or ""
        if h:
            hash_groups.setdefault(h, []).append(i.get("local_path", ""))
    dup = [{"sha256": k, "files": v} for k, v in hash_groups.items() if len(v) > 1]

    report = {
        "source": "db-export",
        "posts_fetched": len(posts),
        "images_expected": len(images),
        "images_ok": images_ok,
        "images_failed": images_failed,
        "posts_with_zero_images": [f"{p['id']} | {p.get('title', '')}" for p in zero_posts],
        "duplicate_hash_groups": dup,
        "recent_runs": runs[:5],
    }
    write_json(out_dir / "integrity_report.json", report)
    md = [
        "# Gallery Integrity Report (DB Export)",
        "",
        f"- Posts: **{len(posts)}**",
        f"- Images: **{len(images)}**",
        f"- Images OK: **{images_ok}**",
        f"- Images failed: **{images_failed}**",
        f"- Posts with zero images: **{len(zero_posts)}**",
        f"- Duplicate hash groups: **{len(dup)}**",
        "",
        "## Recent Runs",
    ]
    for r in runs[:5]:
        md.append(
            f"- {r.get('run_id')} | posts_fetched={r.get('posts_fetched')} "
            f"| images_ok={r.get('images_ok')} | images_failed={r.get('images_failed')}"
        )
    (out_dir / "integrity_report.md").write_text("\n".join(md), encoding="utf-8")
    print(f"[ok] exported posts={len(posts)} images={len(images)} -> {out_dir}")


if __name__ == "__main__":
    main()
