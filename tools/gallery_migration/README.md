# Legacy Gallery Migration

This tool migrates ASL legacy gallery data (`boardIndex=2`, `sub=1`) with integrity checks.

## What It Produces
- `data/gallery_migration/source_gallery_index.json`
- `data/gallery_migration/normalized_gallery_posts.json`
- `data/gallery_migration/normalized_gallery_images.json`
- `data/gallery_migration/gallery-data.json` (frontend-ready merged structure)
- `data/gallery_migration/gallery_archive.db`
- `data/gallery_migration/integrity_report.json`
- `data/gallery_migration/integrity_report.md`

If `--download-images` is enabled, it also stores images under:
- `assets/gallery/imported/<post_id>/<sort_order>_<filename>`

## Run
```powershell
python tools/gallery_migration/migrate_gallery.py --download-images
```

## Fast dry run (no file downloads)
```powershell
python tools/gallery_migration/migrate_gallery.py
```

## Optional page cap while testing
```powershell
python tools/gallery_migration/migrate_gallery.py --max-pages 2
```

## Rebuild JSON from DB (if a later crawl is partial)
```powershell
python tools/gallery_migration/export_from_db.py
```

## Safety guard
- Default `--min-posts-guard 100` prevents overwriting artifacts with partial crawls.
- Set `--min-posts-guard 0` only for intentional partial tests.

## Integrity Criteria
- All list pages reachable through pagination are discovered.
- All detail links from list pages are collected (deduplicated by URL).
- Every post has a stable `post_id` (prefer `idx`, fallback to `present_num/letter_no`).
- Per-post image list is preserved with stable `sort_order`.
- Downloaded image file hashes (`sha256`) are stored for duplicate and corruption checks.
- A summary report lists:
  - missing/failed posts
  - posts with zero images
  - failed image downloads
  - duplicate hash groups
