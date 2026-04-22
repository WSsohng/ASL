-- Admin console schema for Publications / Gallery / Members with RLS.
-- Run in Supabase SQL editor.

create extension if not exists pgcrypto;

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
  year integer not null,
  journal text not null default '',
  authors text not null default '',
  doi text,
  citations integer not null default 0,
  impact_factor numeric(6,2),
  graphical_abstract_url text,
  created_by uuid references auth.users(id),
  created_at timestamptz not null default now(),
  updated_at timestamptz not null default now()
);

create table if not exists public.members (
  id uuid primary key default gen_random_uuid(),
  name text not null,
  role text not null default '',
  email text,
  career text,
  track text not null default 'current' check (track in ('faculty','current','alumni')),
  image_url text,
  created_by uuid references auth.users(id),
  created_at timestamptz not null default now(),
  updated_at timestamptz not null default now()
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

-- Ensure columns exist for admin UI compatibility with existing gallery tables.
alter table if exists public.gallery_posts
  add column if not exists content text not null default '',
  add column if not exists created_by uuid references auth.users(id),
  add column if not exists created_at timestamptz not null default now(),
  add column if not exists updated_at timestamptz not null default now();

alter table if exists public.gallery_images
  add column if not exists created_by uuid references auth.users(id),
  add column if not exists created_at timestamptz not null default now(),
  add column if not exists updated_at timestamptz not null default now();

create index if not exists idx_publications_year on public.publications(year desc);
create index if not exists idx_members_track on public.members(track);
create index if not exists idx_intern_applications_submitted_at on public.intern_applications(submitted_at desc);
create index if not exists idx_notification_recipients_channel_active on public.notification_recipients(channel, is_active);

alter table public.profiles enable row level security;
alter table public.publications enable row level security;
alter table public.members enable row level security;
alter table public.gallery_posts enable row level security;
alter table public.gallery_images enable row level security;
alter table public.intern_applications enable row level security;
alter table public.notification_recipients enable row level security;

-- Helper: check current user admin role.
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

-- Profiles
drop policy if exists profiles_self_select on public.profiles;
create policy profiles_self_select on public.profiles
for select to authenticated
using (id = auth.uid() or public.is_admin());

drop policy if exists profiles_admin_write on public.profiles;
create policy profiles_admin_write on public.profiles
for all to authenticated
using (public.is_admin())
with check (public.is_admin());

-- Publications
drop policy if exists publications_read_all on public.publications;
create policy publications_read_all on public.publications
for select
using (true);

drop policy if exists publications_admin_write on public.publications;
create policy publications_admin_write on public.publications
for all to authenticated
using (public.is_admin())
with check (public.is_admin());

-- Members
drop policy if exists members_read_all on public.members;
create policy members_read_all on public.members
for select
using (true);

drop policy if exists members_admin_write on public.members;
create policy members_admin_write on public.members
for all to authenticated
using (public.is_admin())
with check (public.is_admin());

-- Gallery
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

