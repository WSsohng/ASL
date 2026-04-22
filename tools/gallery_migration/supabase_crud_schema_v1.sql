-- ASL unified CRUD schema v1
-- Scope: publications, members, gallery (+ profiles/admin role) and RLS.
-- Run in Supabase SQL editor.

create extension if not exists pgcrypto;

-- ---------------------------------------------------------------------------
-- Core tables
-- ---------------------------------------------------------------------------
create table if not exists public.profiles (
  id uuid primary key references auth.users(id) on delete cascade,
  email text not null default '',
  role text not null default 'viewer' check (role in ('viewer', 'admin')),
  created_at timestamptz not null default now(),
  updated_at timestamptz not null default now()
);

create table if not exists public.publications (
  id uuid primary key default gen_random_uuid(),
  title text not null,
  year integer not null check (year >= 1900 and year <= 2100),
  journal text not null default '',
  authors text not null default '',
  authors_marked text not null default '',
  doi text,
  citations integer not null default 0 check (citations >= 0),
  impact_factor numeric(6,2),
  graphical_abstract_url text,
  pdf_url text,
  source_key text not null default '',
  source_year_group text not null default '',
  created_by uuid references auth.users(id),
  updated_by uuid references auth.users(id),
  created_at timestamptz not null default now(),
  updated_at timestamptz not null default now(),
  unique(title, journal, year)
);

create table if not exists public.members (
  id uuid primary key default gen_random_uuid(),
  name text not null,
  name_ko text,
  role text not null default '',
  email text,
  career text,
  research text,
  track text not null default 'current' check (track in ('faculty', 'current', 'alumni')),
  image_url text,
  source_image text,
  source_section text,
  created_by uuid references auth.users(id),
  updated_by uuid references auth.users(id),
  created_at timestamptz not null default now(),
  updated_at timestamptz not null default now(),
  unique(name, track)
);

create table if not exists public.gallery_posts (
  id text primary key,
  title text not null default '',
  content text not null default '',
  author text not null default '',
  date_text text not null default '',
  source_url text not null,
  source_idx text not null default '',
  source_letter_no text not null default '',
  source_present_num text not null default '',
  list_page_num integer,
  thumbnail_url text not null default '',
  created_by uuid references auth.users(id),
  updated_by uuid references auth.users(id),
  created_at timestamptz not null default now(),
  updated_at timestamptz not null default now()
);

alter table if exists public.gallery_posts
  add column if not exists content text not null default '';

create table if not exists public.gallery_images (
  id bigint generated always as identity primary key,
  post_id text not null references public.gallery_posts(id) on delete cascade,
  image_url text not null,
  local_path text not null,
  sha256 text not null default '',
  bytes_size bigint not null default 0,
  sort_order integer not null,
  is_cover boolean not null default false,
  status text not null default 'ok',
  error text not null default '',
  created_by uuid references auth.users(id),
  updated_by uuid references auth.users(id),
  created_at timestamptz not null default now(),
  updated_at timestamptz not null default now(),
  unique(post_id, sort_order),
  unique(post_id, image_url)
);

create table if not exists public.intern_applications (
  id uuid primary key default gen_random_uuid(),
  name text not null,
  student_id text not null default '',
  phone text not null default '',
  email text not null default '',
  period text not null default '',
  motivation text not null default '',
  submitted_at timestamptz not null default now(),
  created_at timestamptz not null default now(),
  updated_at timestamptz not null default now()
);

create table if not exists public.notification_recipients (
  id uuid primary key default gen_random_uuid(),
  channel text not null default 'intern_application',
  email text not null,
  is_active boolean not null default true,
  created_at timestamptz not null default now(),
  updated_at timestamptz not null default now(),
  unique(channel, email)
);

-- ---------------------------------------------------------------------------
-- Indexes
-- ---------------------------------------------------------------------------
create index if not exists idx_publications_year on public.publications(year desc);
create index if not exists idx_publications_created_at on public.publications(created_at desc);
create index if not exists idx_members_track on public.members(track);
create index if not exists idx_members_name on public.members(name);
create index if not exists idx_gallery_posts_source_present_num on public.gallery_posts(source_present_num);
create index if not exists idx_gallery_images_post_sort on public.gallery_images(post_id, sort_order);
create index if not exists idx_gallery_images_sha256 on public.gallery_images(sha256);
create index if not exists idx_intern_applications_submitted_at on public.intern_applications(submitted_at desc);
create index if not exists idx_notification_recipients_channel_active on public.notification_recipients(channel, is_active);

-- ---------------------------------------------------------------------------
-- Updated-at trigger
-- ---------------------------------------------------------------------------
create or replace function public.tg_set_updated_at()
returns trigger
language plpgsql
as $$
begin
  new.updated_at = now();
  return new;
end;
$$;

drop trigger if exists trg_profiles_updated_at on public.profiles;
create trigger trg_profiles_updated_at
before update on public.profiles
for each row execute function public.tg_set_updated_at();

drop trigger if exists trg_publications_updated_at on public.publications;
create trigger trg_publications_updated_at
before update on public.publications
for each row execute function public.tg_set_updated_at();

drop trigger if exists trg_members_updated_at on public.members;
create trigger trg_members_updated_at
before update on public.members
for each row execute function public.tg_set_updated_at();

drop trigger if exists trg_gallery_posts_updated_at on public.gallery_posts;
create trigger trg_gallery_posts_updated_at
before update on public.gallery_posts
for each row execute function public.tg_set_updated_at();

drop trigger if exists trg_gallery_images_updated_at on public.gallery_images;
create trigger trg_gallery_images_updated_at
before update on public.gallery_images
for each row execute function public.tg_set_updated_at();

drop trigger if exists trg_intern_applications_updated_at on public.intern_applications;
create trigger trg_intern_applications_updated_at
before update on public.intern_applications
for each row execute function public.tg_set_updated_at();

drop trigger if exists trg_notification_recipients_updated_at on public.notification_recipients;
create trigger trg_notification_recipients_updated_at
before update on public.notification_recipients
for each row execute function public.tg_set_updated_at();

-- ---------------------------------------------------------------------------
-- RLS
-- ---------------------------------------------------------------------------
alter table public.profiles enable row level security;
alter table public.publications enable row level security;
alter table public.members enable row level security;
alter table public.gallery_posts enable row level security;
alter table public.gallery_images enable row level security;
alter table public.intern_applications enable row level security;
alter table public.notification_recipients enable row level security;

create or replace function public.is_admin()
returns boolean
language sql
stable
as $$
  select exists (
    select 1
    from public.profiles p
    where p.id = auth.uid() and p.role = 'admin'
  );
$$;

drop policy if exists profiles_self_select on public.profiles;
create policy profiles_self_select on public.profiles
for select to authenticated
using (id = auth.uid() or public.is_admin());

drop policy if exists profiles_admin_write on public.profiles;
create policy profiles_admin_write on public.profiles
for all to authenticated
using (public.is_admin())
with check (public.is_admin());

drop policy if exists publications_read_all on public.publications;
create policy publications_read_all on public.publications
for select
using (true);

drop policy if exists publications_admin_write on public.publications;
create policy publications_admin_write on public.publications
for all to authenticated
using (public.is_admin())
with check (public.is_admin());

drop policy if exists members_read_all on public.members;
create policy members_read_all on public.members
for select
using (true);

drop policy if exists members_admin_write on public.members;
create policy members_admin_write on public.members
for all to authenticated
using (public.is_admin())
with check (public.is_admin());

drop policy if exists gallery_posts_read_all on public.gallery_posts;
create policy gallery_posts_read_all on public.gallery_posts
for select
using (true);

drop policy if exists gallery_posts_admin_write on public.gallery_posts;
create policy gallery_posts_admin_write on public.gallery_posts
for all to authenticated
using (public.is_admin())
with check (public.is_admin());

drop policy if exists gallery_images_read_all on public.gallery_images;
create policy gallery_images_read_all on public.gallery_images
for select
using (true);

drop policy if exists gallery_images_admin_write on public.gallery_images;
create policy gallery_images_admin_write on public.gallery_images
for all to authenticated
using (public.is_admin())
with check (public.is_admin());

drop policy if exists intern_applications_public_insert on public.intern_applications;
create policy intern_applications_public_insert on public.intern_applications
for insert to anon, authenticated
with check (true);

drop policy if exists intern_applications_admin_read on public.intern_applications;
create policy intern_applications_admin_read on public.intern_applications
for select to authenticated
using (public.is_admin());

drop policy if exists intern_applications_admin_write on public.intern_applications;
create policy intern_applications_admin_write on public.intern_applications
for update to authenticated
using (public.is_admin())
with check (public.is_admin());

drop policy if exists intern_applications_admin_delete on public.intern_applications;
create policy intern_applications_admin_delete on public.intern_applications
for delete to authenticated
using (public.is_admin());

drop policy if exists notification_recipients_admin_read on public.notification_recipients;
create policy notification_recipients_admin_read on public.notification_recipients
for select to authenticated
using (public.is_admin());

drop policy if exists notification_recipients_admin_write on public.notification_recipients;
create policy notification_recipients_admin_write on public.notification_recipients
for all to authenticated
using (public.is_admin())
with check (public.is_admin());

