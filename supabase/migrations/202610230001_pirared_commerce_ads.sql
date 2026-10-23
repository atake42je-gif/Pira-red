-- PiraRed: base segura para comercios y publicidad (Supabase/PostgreSQL)
-- Ejecutar en Supabase SQL Editor. No incluye claves secretas.
begin;

create extension if not exists pgcrypto;

create table if not exists public.profiles (
  id uuid primary key references auth.users(id) on delete cascade,
  display_name text not null default '',
  role text not null default 'user' check (role in ('user','admin')),
  created_at timestamptz not null default now()
);

create table if not exists public.businesses (
  id uuid primary key default gen_random_uuid(),
  owner_id uuid not null references auth.users(id) on delete cascade,
  name text not null check (char_length(name) between 2 and 100),
  category text not null default 'Otro comercio' check (char_length(category) between 2 and 80),
  description text not null default '' check (char_length(description) <= 700),
  public_contact text not null default '' check (char_length(public_contact) <= 120),
  status text not null default 'pending' check (status in ('pending','approved','rejected')),
  created_at timestamptz not null default now(),
  updated_at timestamptz not null default now()
);

create table if not exists public.ads (
  id uuid primary key default gen_random_uuid(),
  business_id uuid not null references public.businesses(id) on delete cascade,
  owner_id uuid not null references auth.users(id) on delete cascade,
  title text not null check (char_length(title) between 3 and 90),
  description text not null check (char_length(description) between 5 and 600),
  category text not null default 'Otro comercio' check (char_length(category) between 2 and 80),
  offer_text text not null default '' check (char_length(offer_text) <= 100),
  ad_type text not null default 'basic' check (ad_type in ('basic','featured')),
  status text not null default 'pending' check (status in ('pending','approved','rejected')),
  starts_at timestamptz,
  ends_at timestamptz,
  reviewed_by uuid references auth.users(id) on delete set null,
  reviewed_at timestamptz,
  review_note text not null default '' check (char_length(review_note) <= 300),
  created_at timestamptz not null default now(),
  updated_at timestamptz not null default now(),
  constraint ad_dates_valid check (ends_at is null or starts_at is null or ends_at > starts_at)
);

create index if not exists businesses_owner_idx on public.businesses(owner_id);
create index if not exists businesses_public_idx on public.businesses(status, created_at desc);
create index if not exists ads_owner_idx on public.ads(owner_id);
create index if not exists ads_business_idx on public.ads(business_id);
create index if not exists ads_public_idx on public.ads(status, ad_type, created_at desc);

create or replace function public.is_pirared_admin()
returns boolean
language sql
stable
security definer
set search_path = ''
as $$
  select exists (
    select 1 from public.profiles p
    where p.id = (select auth.uid()) and p.role = 'admin'
  );
$$;

create or replace function public.handle_new_pirared_user()
returns trigger
language plpgsql
security definer
set search_path = ''
as $$
begin
  insert into public.profiles (id, display_name)
  values (
    new.id,
    coalesce(nullif(new.raw_user_meta_data ->> 'display_name',''), '')
  )
  on conflict (id) do nothing;
  return new;
end;
$$;

drop trigger if exists on_auth_user_created_pirared on auth.users;
create trigger on_auth_user_created_pirared
after insert on auth.users
for each row execute procedure public.handle_new_pirared_user();

alter table public.profiles enable row level security;
alter table public.businesses enable row level security;
alter table public.ads enable row level security;

-- Perfil: cada usuario ve/edita lo suyo; rol nunca se puede editar mediante esta política.
drop policy if exists "profile read self or admin" on public.profiles;
create policy "profile read self or admin" on public.profiles
for select to authenticated using (id = (select auth.uid()) or public.is_pirared_admin());
drop policy if exists "profile update self" on public.profiles;
create policy "profile update self" on public.profiles
for update to authenticated using (id = (select auth.uid())) with check (id = (select auth.uid()));
revoke update (role) on public.profiles from authenticated;
grant select, update (display_name) on public.profiles to authenticated;

-- Comercios aprobados visibles públicamente; propietario administra el suyo; admin revisa.
drop policy if exists "approved businesses public read" on public.businesses;
create policy "approved businesses public read" on public.businesses
for select to anon, authenticated using (status = 'approved' or owner_id = (select auth.uid()) or public.is_pirared_admin());
drop policy if exists "owner submits business" on public.businesses;
create policy "owner submits business" on public.businesses
for insert to authenticated with check (owner_id = (select auth.uid()) and status = 'pending');
drop policy if exists "owner edits pending business" on public.businesses;
create policy "owner edits pending business" on public.businesses
for update to authenticated using (owner_id = (select auth.uid()) and status in ('pending','rejected'))
with check (owner_id = (select auth.uid()) and status in ('pending','rejected'));
drop policy if exists "admin reviews businesses" on public.businesses;
create policy "admin reviews businesses" on public.businesses
for update to authenticated using (public.is_pirared_admin()) with check (public.is_pirared_admin());

-- Solo anuncios aprobados y de comercios aprobados se muestran a visitantes.
drop policy if exists "approved ads public read" on public.ads;
create policy "approved ads public read" on public.ads
for select to anon, authenticated using (
  (status = 'approved' and exists (
    select 1 from public.businesses b
    where b.id = business_id and b.status = 'approved'
  ))
  or owner_id = (select auth.uid())
  or public.is_pirared_admin()
);
drop policy if exists "owner submits pending ad" on public.ads;
create policy "owner submits pending ad" on public.ads
for insert to authenticated with check (
  owner_id = (select auth.uid())
  and status = 'pending'
  and reviewed_by is null
  and reviewed_at is null
  and exists (
    select 1 from public.businesses b
    where b.id = business_id
      and b.owner_id = (select auth.uid())
      and b.status = 'approved'
  )
);
drop policy if exists "owner edits pending or rejected ad" on public.ads;
create policy "owner edits pending or rejected ad" on public.ads
for update to authenticated using (
  owner_id = (select auth.uid()) and status in ('pending','rejected')
) with check (
  owner_id = (select auth.uid()) and status in ('pending','rejected')
  and reviewed_by is null and reviewed_at is null
);
drop policy if exists "admin reviews ads" on public.ads;
create policy "admin reviews ads" on public.ads
for update to authenticated using (public.is_pirared_admin()) with check (public.is_pirared_admin());

grant select on public.businesses, public.ads to anon, authenticated;
grant insert, update on public.businesses, public.ads to authenticated;
grant select on public.profiles to authenticated;
grant update (display_name) on public.profiles to authenticated;
grant execute on function public.is_pirared_admin() to authenticated;

commit;

-- IMPORTANTE: el primer administrador se configura manualmente en SQL Editor,
-- después de registrar esa cuenta y verificar su UUID:
-- update public.profiles set role = 'admin' where id = 'UUID-DE-TU-CUENTA';
-- No ejecutes esa línea hasta reemplazar el UUID por el de tu cuenta verificada.
