-- Cover foreign keys used by reports and blocks.
begin;
create index if not exists user_blocks_blocked_idx on public.user_blocks(blocked_id);
create index if not exists user_reports_post_idx on public.user_reports(community_post_id);
create index if not exists user_reports_target_user_idx on public.user_reports(reported_user_id);
commit;
