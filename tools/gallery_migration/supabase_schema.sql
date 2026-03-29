-- Supabase schema for ASL gallery archive migration

create table if not exists public.gallery_posts (
  id text primary key,
  title text not null default '',
  author text not null default '',
  date_text text not null default '',
  source_url text not null,
  source_idx text not null default '',
  source_letter_no text not null default '',
  source_present_num text not null default '',
  list_page_num integer,
  thumbnail_url text not null default '',
  created_at timestamptz not null default now(),
  updated_at timestamptz not null default now()
);

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
  created_at timestamptz not null default now(),
  updated_at timestamptz not null default now(),
  unique(post_id, image_url)
);

create index if not exists idx_gallery_posts_source_present_num
  on public.gallery_posts (source_present_num);

create index if not exists idx_gallery_images_post_sort
  on public.gallery_images (post_id, sort_order);

create index if not exists idx_gallery_images_sha256
  on public.gallery_images (sha256);

