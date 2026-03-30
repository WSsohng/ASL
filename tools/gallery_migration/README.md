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

## Enrich Gallery Body Content (2nd pass)
If titles/images are already migrated but body content is missing, run:
```powershell
python tools/gallery_migration/enrich_gallery_content.py --export-json
```

Optional full refresh:
```powershell
python tools/gallery_migration/enrich_gallery_content.py --force --export-json
```

## Safety guard
- Default `--min-posts-guard 100` prevents overwriting artifacts with partial crawls.
- Set `--min-posts-guard 0` only for intentional partial tests.

## Stable Ops Migration (Supabase Storage)
One-command PowerShell runner:
```powershell
powershell -ExecutionPolicy Bypass -File tools/gallery_migration/run_supabase_migration.ps1 -SupabaseUrl "https://<project-ref>.supabase.co" -ServiceRoleKey "<service-role-key>" -Bucket "asl-gallery"
```

Manual steps:
1. Create a public storage bucket in Supabase (example: `asl-gallery`).
2. Set environment variables:
```powershell
$env:SUPABASE_URL="https://<project-ref>.supabase.co"
$env:SUPABASE_SERVICE_ROLE_KEY="<service-role-key>"
```
3. Upload local gallery assets:
```powershell
python tools/gallery_migration/upload_gallery_to_supabase.py `
  --bucket asl-gallery `
  --gallery-json data/gallery_migration/gallery-data.json `
  --manifest data/gallery_migration/supabase_upload_manifest.json
```

Dry-run URL simulation:
```powershell
python tools/gallery_migration/upload_gallery_to_supabase.py `
  --bucket asl-gallery `
  --gallery-json data/gallery_migration/gallery-data.json `
  --manifest data/gallery_migration/supabase_upload_manifest.json `
  --supabase-url https://<project-ref>.supabase.co `
  --dry-run
```
4. Rewrite gallery data to remote URLs:
```powershell
python tools/gallery_migration/rewrite_gallery_urls.py `
  --gallery-json data/gallery_migration/gallery-data.json `
  --manifest data/gallery_migration/supabase_upload_manifest.json `
  --out data/gallery_migration/gallery-data.supabase.json `
  --strict
```

When rewriting from a dry-run manifest, add `--include-planned`.
5. Runtime switchover:
- `gallery-archive.js` automatically tries this order:
  1) `gallery-data.runtime.json`
  2) `gallery-data.supabase.json`
  3) `gallery-data.json`
- For production cutover, copy `gallery-data.supabase.json` to `gallery-data.runtime.json`.

## Admin Console (Web Upload)
- Page: `admin.html`
- Client code: `admin.js`
- Config file: `admin-config.js` (copy from `admin-config.example.js` and fill `url`, `anonKey`)

Required schema/RLS:
- Run `tools/gallery_migration/supabase_admin_console_schema.sql` in Supabase SQL editor.
- In `profiles`, assign admin role to your account:
```sql
update public.profiles
set role = 'admin'
where email = 'your-admin-email@example.com';
```

Storage buckets used by admin page:
- `asl-gallery`
- `asl-publications`
- `asl-members`

Public-site data source:
- `public-data.js` reads Supabase first when `admin-config.js` has `url` and `anonKey`.
- If not configured or request fails, pages automatically fall back to local JSON files.

## Unified CRUD Migration (Publications / Members / Gallery)
This is the next-step migration that moves all currently-served JSON data into Supabase tables so the admin console can become the single source of truth.

1. Run the unified schema:
```sql
-- Supabase SQL editor
-- file: tools/gallery_migration/supabase_crud_schema_v1.sql
```

2. Set environment variables:
```powershell
$env:SUPABASE_URL="https://<project-ref>.supabase.co"
$env:SUPABASE_SERVICE_ROLE_KEY="<service-role-key>"
```

3. Backfill all datasets:
```powershell
python tools/gallery_migration/backfill_supabase_from_json.py --only all
```

If `gallery_posts.content` does not exist yet in Supabase, run this once in SQL Editor:
```sql
alter table if exists public.gallery_posts
  add column if not exists content text not null default '';
```

Optional scope runs:
```powershell
python tools/gallery_migration/backfill_supabase_from_json.py --only publications
python tools/gallery_migration/backfill_supabase_from_json.py --only members
python tools/gallery_migration/backfill_supabase_from_json.py --only gallery
```

4. Verify report:
- `data/gallery_migration/backfill_report.json`

5. Verify table counts vs local source datasets:
```powershell
python tools/gallery_migration/verify_supabase_backfill.py
```

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
