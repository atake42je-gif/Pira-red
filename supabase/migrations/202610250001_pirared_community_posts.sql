-- PiraRed community listings with moderation and row-level security.
begin;

create table if not exists public.community_posts (
  id uuid primary key default gen_random_uuid(),
  owner_id uuid not null references auth.users(id) on delete cascade,
  category text not null check (category in ('Compra / Venta','Trabajos','Servicios')),
  title text not null check (char_length(title) between 3 and 100),
  description text not null check (char_length(description) between 5 and 1000),
  price_text text not null default '' check (char_length(price_text) <= 80),
  location_text text not null default 'Pirané' check (char_length(location_text) <= 100),
  public_contact text not null default '' check (char_length(public_contact) <= 120),
  status text not null default 'pending' check (status in ('pending','approved','rejected')),
  created_at timestamptz not null default now(),
  updated_at timestamptz not null default now()
);
create index if not exists community_posts_public_idx on public.community_posts(status, category, created_at desc);
create index if not exists community_posts_owner_idx on public.community_posts(owner_id, created_at desc);
alter table public.community_posts enable row level security;

drop policy if exists "approved community posts public read" on public.community_posts;
create policy "approved community posts public read" on public.community_posts
for select to anon, authenticated
using (status = 'approved' or owner_id = (select auth.uid()) or private.is_pirared_admin());

drop policy if exists "users submit pending community posts" on public.community_posts;
create policy "users submit pending community posts" on public.community_posts
for insert to authenticated with check (owner_id = (select auth.uid()) and status = 'pending');

drop policy if exists "owners edit pending or rejected community posts" on public.community_posts;
create policy "owners edit pending or rejected community posts" on public.community_posts
for update to authenticated
using (owner_id = (select auth.uid()) and status in ('pending','rejected'))
with check (owner_id = (select auth.uid()) and status in ('pending','rejected'));

drop policy if exists "admins review community posts" on public.community_posts;
create policy "admins review community posts" on public.community_posts
for update to authenticated using (private.is_pirared_admin()) with check (private.is_pirared_admin());

grant select on public.community_posts to anon, authenticated;
grant insert, update on public.community_posts to authenticated;
commit;
