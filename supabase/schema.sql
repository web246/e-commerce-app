-- Supabase schema for your marketplace app
-- Run this in Supabase SQL editor or via psql

-- 1) Profiles table - linked to auth.users
create table if not exists profiles (
  id uuid primary key references auth.users(id) on delete cascade,
  full_name text,
  phone text,
  role text not null default 'customer',
  avatar_url text,
  created_at timestamptz not null default now(),
  updated_at timestamptz not null default now()
);

-- 2) Categories table
create table if not exists categories (
  id serial primary key,
  name text not null unique,
  slug text not null unique,
  description text,
  created_at timestamptz not null default now()
);

-- 3) Stores table
create table if not exists stores (
  id uuid primary key default gen_random_uuid(),
  user_id uuid references profiles(id) on delete set null,
  name text not null,
  slug text not null unique,
  description text,
  logo_url text,
  products_count int not null default 0,
  created_at timestamptz not null default now(),
  updated_at timestamptz not null default now()
);

-- 4) Products table
create table if not exists products (
  id uuid primary key default gen_random_uuid(),
  name text not null,
  slug text not null unique,
  description text,
  store_id uuid references stores(id) on delete set null,
  store_name text,
  category text,
  subcategory text,
  brand text,
  price numeric not null default 0,
  old_price numeric,
  discount_percent int not null default 0,
  currency text not null default 'KES',
  images jsonb not null default '[]'::jsonb,
  thumbnail text,
  stock int not null default 0,
  sku text,
  rating numeric not null default 0,
  reviews_count int not null default 0,
  sold_count int not null default 0,
  status text not null default 'active',
  is_featured boolean not null default false,
  is_flash_sale boolean not null default false,
  flash_sale_end timestamptz,
  flash_sale_stock int not null default 0,
  free_shipping boolean not null default false,
  shipping_fee numeric not null default 0,
  tags jsonb not null default '[]'::jsonb,
  specifications jsonb not null default '{}'::jsonb,
  variants jsonb not null default '[]'::jsonb,
  weight numeric not null default 0,
  dimensions text,
  is_new_arrival boolean not null default false,
  is_best_seller boolean not null default false,
  condition text not null default 'new',
  created_at timestamptz not null default now(),
  updated_at timestamptz not null default now()
);

-- 5) Reviews table
create table if not exists reviews (
  id uuid primary key default gen_random_uuid(),
  product_id uuid references products(id) on delete cascade,
  user_id uuid references profiles(id) on delete set null,
  rating int not null check (rating >= 1 and rating <= 5),
  title text,
  comment text,
  images jsonb not null default '[]'::jsonb,
  created_at timestamptz not null default now()
);

-- 6) Orders table
create table if not exists orders (
  id uuid primary key default gen_random_uuid(),
  order_number text not null unique,
  buyer_id uuid references profiles(id) on delete set null,
  buyer_name text,
  buyer_email text,
  buyer_phone text,
  items jsonb not null default '[]'::jsonb,
  subtotal numeric not null default 0,
  shipping_fee numeric not null default 0,
  tax numeric not null default 0,
  discount numeric not null default 0,
  total numeric not null default 0,
  currency text not null default 'KES',
  status text not null default 'pending',
  payment_method text not null default 'mpesa',
  payment_status text not null default 'pending',
  payment_reference text,
  shipping_address jsonb not null default '{}'::jsonb,
  delivery_method text not null default 'standard',
  estimated_delivery timestamptz,
  tracking_number text,
  carrier text,
  coupon_code text,
  store_id uuid references stores(id) on delete set null,
  store_name text,
  timeline jsonb not null default '[]'::jsonb,
  created_at timestamptz not null default now(),
  updated_at timestamptz not null default now()
);

-- 7) Wishlist table
create table if not exists wishlist_items (
  id uuid primary key default gen_random_uuid(),
  user_id uuid references profiles(id) on delete cascade,
  product_id uuid references products(id) on delete cascade,
  created_at timestamptz not null default now()
);

-- 8) Coupons table
create table if not exists coupons (
  id uuid primary key default gen_random_uuid(),
  code text not null unique,
  description text,
  discount_percent int not null default 0,
  amount_off numeric,
  min_order_value numeric,
  expires_at timestamptz,
  active boolean not null default true,
  created_at timestamptz not null default now(),
  updated_at timestamptz not null default now()
);

-- Add indexes for faster querying
create index if not exists idx_products_category on products(category);
create index if not exists idx_products_store_id on products(store_id);
create index if not exists idx_orders_buyer_id on orders(buyer_id);
create index if not exists idx_wishlist_user_id on wishlist_items(user_id);
create index if not exists idx_reviews_product_id on reviews(product_id);
