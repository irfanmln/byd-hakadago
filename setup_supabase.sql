-- ============================================================
-- Setup Supabase untuk BYD Haka Dago
-- Jalankan di Supabase SQL Editor
-- ============================================================

-- 1. Tabel Test Drive
create table if not exists public.test_drive (
  id          bigserial primary key,
  nama        text not null,
  email       text default '',
  no_hp       text not null,
  tipe_mobil  text not null,
  tanggal     date,
  created_at  timestamptz default now()
);

-- 2. Tabel Simulasi Kredit
create table if not exists public.simulasi_kredit (
  id          bigserial primary key,
  nama        text not null,
  no_hp       text not null,
  tipe_mobil  text not null,
  tenor       text,
  uang_muka   bigint,
  asal_kota   text,
  created_at  timestamptz default now()
);

-- 3. Tabel Gambar Produk
create table if not exists public.product_images (
  id          bigserial primary key,
  car_slug    text not null unique,
  img_listing text,
  img_hero    text,
  img_exterior text,
  img_interior text,
  updated_at  timestamptz default now()
);

-- Seed satu baris per mobil BYD
insert into public.product_images (car_slug) values
  ('seal'), ('atto-3'), ('dolphin'), ('m6'), ('atto-1')
on conflict (car_slug) do nothing;

-- 4. Tabel Warna Mobil
create table if not exists public.color_variants (
  id            bigserial primary key,
  car_slug      text not null,
  variant_group text default '',
  color_name    text not null,
  image_url     text not null,
  sort_order    int default 0,
  created_at    timestamptz default now()
);

-- 5. Tabel Hero Banners
create table if not exists public.hero_banners (
  id          bigserial primary key,
  image_url   text not null,
  sort_order  int default 0,
  is_active   boolean default true,
  created_at  timestamptz default now()
);

-- 6. Tabel Foto Delivery
create table if not exists public.delivery_photos (
  id          bigserial primary key,
  image_url   text not null,
  sort_order  int default 0,
  created_at  timestamptz default now()
);

-- ============================================================
-- Row Level Security (RLS)
-- ============================================================
alter table public.test_drive        enable row level security;
alter table public.simulasi_kredit   enable row level security;
alter table public.product_images    enable row level security;
alter table public.color_variants    enable row level security;
alter table public.hero_banners      enable row level security;
alter table public.delivery_photos   enable row level security;

-- Semua operasi public (anon key) diizinkan
create policy "public all" on public.test_drive        for all using (true) with check (true);
create policy "public all" on public.simulasi_kredit   for all using (true) with check (true);
create policy "public all" on public.product_images    for all using (true) with check (true);
create policy "public all" on public.color_variants    for all using (true) with check (true);
create policy "public all" on public.hero_banners      for all using (true) with check (true);
create policy "public all" on public.delivery_photos   for all using (true) with check (true);

-- ============================================================
-- Storage Buckets (jalankan di Storage > New Bucket)
-- Buat 3 bucket public:
--   - hero-banners
--   - product-images
--   - delivery-photos
-- ============================================================
