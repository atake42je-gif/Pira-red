-- Reports and user blocks for PiraRed moderation.
begin;
create table if not exists public.user_reports (
  id uuid primary key default gen_random_uuid(),
  reporter_id uuid not null references auth.users(id) on delete cascade,
  reported_user_id uuid references auth.users(id) on delete set null,
  community_post_id uuid references public.community_posts(id) on delete set null,
  reason text not null check (reason in ('spam','harassment','fraud','unsafe','other')),
  details text not null default '' check (char_length(details) <= 1000),
  status text not null default 'pending' check (status in ('pending','reviewing','resolved','dismissed')),
  created_at timestamptz not null default now(),
  constraint report_target_required check (reported_user_id is not null or community_post_id is not null),
  constraint report_not_self check (reported_user_id is null or reported_user_id <> reporter_id)
);
create index if not exists user_reports_status_created_idx on public.user_reports(status, created_at desc);
create index if not exists user_reports_reporter_idx on public.user_reports(reporter_id, created_at desc);
alter table public.user_reports enable row level security;
drop policy if exists "users submit own reports" on public.user_reports;
create policy "users submit own reports" on public.user_reports for insert to authenticated with check (reporter_id = (select auth.uid()));
drop policy if exists "reporters read own reports" on public.user_reports;
create policy "reporters read own reports" on public.user_reports for select to authenticated using (reporter_id = (select auth.uid()) or private.is_pirared_admin());
drop policy if exists "admins review reports" on public.user_reports;
create policy "admins review reports" on public.user_reports for update to authenticated using (private.is_pirared_admin()) with check (private.is_pirared_admin());
grant select, insert on public.user_reports to authenticated;
grant update (status) on public.user_reports to authenticated;

create table if not exists public.user_blocks (
  blocker_id uuid not null references auth.users(id) on delete cascade,
  blocked_id uuid not null references auth.users(id) on delete cascade,
  created_at timestamptz not null default now(),
  primary key (blocker_id, blocked_id),
  constraint user_blocks_no_self check (blocker_id <> blocked_id)
);
alter table public.user_blocks enable row level security;
drop policy if exists "users manage their own blocks" on public.user_blocks;
create policy "users manage their own blocks" on public.user_blocks for all to authenticated using (blocker_id = (select auth.uid())) with check (blocker_id = (select auth.uid()));
grant select, insert, delete on public.user_blocks to authenticated;
commit;
