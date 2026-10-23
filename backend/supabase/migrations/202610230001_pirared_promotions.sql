-- PiraRed: base inicial para pagos de promociones.
create extension if not exists pgcrypto;
create table if not exists public.promotion_orders (
 id uuid primary key default gen_random_uuid(),
 user_id uuid not null references auth.users(id) on delete restrict,
 listing_id uuid not null,
 promotion_type text not null check (promotion_type in ('destacada','publicidad')),
 amount numeric(12,2) not null check (amount > 0),
 currency text not null default 'ARS' check (currency = 'ARS'),
 duration_days integer not null check (duration_days between 1 and 90),
 status text not null default 'pending' check (status in ('pending','approved','rejected','refunded')),
 provider text not null default 'mercadopago' check (provider = 'mercadopago'),
 provider_payment_id text unique,
 created_at timestamptz not null default now(),
 approved_at timestamptz,
 expires_at timestamptz
);
create table if not exists public.listing_promotions (
 id uuid primary key default gen_random_uuid(),
 order_id uuid not null unique references public.promotion_orders(id) on delete restrict,
 listing_id uuid not null,
 user_id uuid not null references auth.users(id) on delete restrict,
 promotion_type text not null check (promotion_type in ('destacada','publicidad')),
 starts_at timestamptz not null default now(),
 expires_at timestamptz not null,
 active boolean not null default true,
 created_at timestamptz not null default now()
);
create index if not exists listing_promotions_active_idx on public.listing_promotions (listing_id, active, expires_at);
create index if not exists promotion_orders_status_idx on public.promotion_orders (status, created_at desc);
alter table public.promotion_orders enable row level security;
alter table public.listing_promotions enable row level security;
create policy "read own promotion orders" on public.promotion_orders for select using (auth.uid() = user_id);
create policy "read own promotions" on public.listing_promotions for select using (auth.uid() = user_id);
-- Sin políticas INSERT/UPDATE de cliente: solo el backend confiable puede registrar pagos/activar promociones.
