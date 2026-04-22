-- Intern application notification hook
-- Run in Supabase SQL editor after deploying `intern-notify` Edge Function.
--
-- Required one-time project settings (replace project-ref):
--   alter database postgres set app.settings.intern_notify_url =
--     'https://<project-ref>.supabase.co/functions/v1/intern-notify';
--   alter database postgres set app.settings.intern_notify_timeout_ms = '5000';
--
-- Optional shared secret (recommended):
--   select vault.create_secret('replace-with-random-long-secret', 'intern_notify_webhook_secret');
--   -- and set the same value as Edge Function secret: NOTIFY_WEBHOOK_SECRET

create extension if not exists pg_net;
create extension if not exists supabase_vault;

create or replace function public.notify_intern_application_insert()
returns trigger
language plpgsql
security definer
set search_path = public
as $$
declare
  notify_url text;
  timeout_ms integer;
  webhook_secret text;
  headers jsonb;
  payload jsonb;
begin
  notify_url := current_setting('app.settings.intern_notify_url', true);
  if notify_url is null or notify_url = '' then
    raise warning 'intern notify url is not configured (app.settings.intern_notify_url)';
    return new;
  end if;

  timeout_ms := coalesce(nullif(current_setting('app.settings.intern_notify_timeout_ms', true), '')::integer, 5000);
  webhook_secret := (
    select decrypted_secret
    from vault.decrypted_secrets
    where name = 'intern_notify_webhook_secret'
    limit 1
  );

  headers := jsonb_build_object('Content-Type', 'application/json');
  if webhook_secret is not null and webhook_secret <> '' then
    headers := headers || jsonb_build_object('x-webhook-secret', webhook_secret);
  end if;

  payload := jsonb_build_object(
    'record', jsonb_build_object(
      'id', new.id,
      'name', new.name
    ),
    'event', 'INSERT',
    'table', 'intern_applications'
  );

  perform net.http_post(
    url := notify_url,
    headers := headers,
    body := payload,
    timeout_milliseconds := timeout_ms
  );
  return new;
end;
$$;

drop trigger if exists trg_notify_intern_application_insert on public.intern_applications;
create trigger trg_notify_intern_application_insert
after insert on public.intern_applications
for each row execute function public.notify_intern_application_insert();
