-- PiraRed: órdenes de pago. Ejecutar en el SQL Editor del proyecto Supabase.
create extension if not exists pgcrypto;

create table if not exists public.payment_orders (
  id uuid primary key default gen_random_uuid(),
  user_id uuid not null references auth.users(id) on delete restrict,
  product_type text not null check (product_type in ('featured_post_7d', 'advertising_7d')),
  amount_ars integer not null check (amount_ars > 0),
  currency text not null default 'ARS' check (currency = 'ARS'),
  status text not null default 'pending' check (status in ('pending', 'approved', 'rejected', 'cancelled', 'refunded')),
  mp_preference_id text unique,
  mp_payment_id text unique,
  created_at timestamptz not null default now(),
  updated_at timestamptz not null default now(),
  approved_at timestamptz
);

create index if not exists payment_orders_user_created_idx
  on public.payment_orders(user_id, created_at desc);
create index if not exists payment_orders_status_created_idx
  on public.payment_orders(status, created_at desc);

alter table public.payment_orders enable row level security;

drop policy if exists "Users can read their own payment orders" on public.payment_orders;
create policy "Users can read their own payment orders"
  on public.payment_orders for select
  to authenticated
  using (auth.uid() = user_id);

-- No se habilitan INSERT/UPDATE/DELETE para clientes: solo las funciones
-- Edge con SERVICE_ROLE pueden crear o actualizar órdenes.
revoke insert, update, delete on public.payment_orders from anon, authenticated;
grant select on public.payment_orders to authenticated;
