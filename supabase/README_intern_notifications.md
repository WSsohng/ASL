# Intern Notification Setup Guide

This project sends a lightweight notification email when a new intern application is submitted.
The email contains only the applicant name.

## 1) Apply database schema and policies

Run these SQL files in Supabase SQL Editor:

1. `tools/gallery_migration/supabase_crud_schema_v1.sql`
2. `supabase/sql/intern_notification.sql`

The schema adds:

- `public.intern_applications` (RLS: public insert, admin read/write/delete)
- `public.notification_recipients` (RLS: admin only)
- trigger `trg_notify_intern_application_insert`

## 2) Deploy Edge Function

Deploy `supabase/functions/intern-notify`.

The function expects this payload from DB trigger:

```json
{
  "record": {
    "id": "<uuid>",
    "name": "지원자 이름"
  },
  "event": "INSERT",
  "table": "intern_applications"
}
```

## 3) Configure secrets

Set Edge Function secrets:

- `SUPABASE_URL`
- `SUPABASE_SERVICE_ROLE_KEY`
- `RESEND_API_KEY`
- `NOTIFY_FROM_EMAIL` (example: `ASL Notify <notify@yourdomain.com>`)
- `NOTIFY_ADMIN_URL` (optional, admin page URL)
- `NOTIFY_EMAIL_FALLBACK` (optional, fallback destination)
- `NOTIFY_WEBHOOK_SECRET` (recommended)

If `NOTIFY_WEBHOOK_SECRET` is used, create the same value in Supabase Vault:

```sql
select vault.create_secret('replace-with-random-long-secret', 'intern_notify_webhook_secret');
```

## 4) Configure trigger endpoint

Set database settings used by `supabase/sql/intern_notification.sql`:

```sql
alter database postgres set app.settings.intern_notify_url =
  'https://<project-ref>.supabase.co/functions/v1/intern-notify';

alter database postgres set app.settings.intern_notify_timeout_ms = '5000';
```

## 5) Domain authentication

In Resend:

1. Add sender domain
2. Configure SPF/DKIM DNS records
3. Verify domain before production use

## 6) Admin operation

In `admin.html > Intern Applications`:

- Add one or more recipients using comma-separated emails
- Toggle `Enable/Disable` per recipient
- Delete stale recipients

Recipients are stored in `public.notification_recipients` with channel `intern_application`.

## 7) End-to-end verification checklist

1. Add at least one recipient in admin.
2. Submit a test application from `intern.html`.
3. Confirm recipient inbox gets a notification with:
   - Subject: `ASL 신규 인턴 지원 - {name}`
   - Body includes applicant name only.
4. Confirm no phone/email/motivation content is included in the email.
5. Disable all recipients and re-test fallback behavior.
6. Check function logs for failures or retries.

