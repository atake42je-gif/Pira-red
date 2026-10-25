-- PiraRed security hardening: remove broad table privileges from API roles.
-- RLS does not protect against TRUNCATE, so API roles must not retain broad grants.
begin;
revoke all privileges on table public.profiles, public.businesses, public.ads, public.community_posts, public.payment_orders, public.private_messages, public.user_blocks, public.user_reports from anon, authenticated;
-- Public read-only browsing; RLS filters to approved content.
grant select on public.businesses, public.ads, public.community_posts to anon;
-- Authenticated users can read rows permitted by RLS.
grant select on public.profiles, public.businesses, public.ads, public.community_posts, public.payment_orders, public.private_messages, public.user_blocks, public.user_reports to authenticated;
-- Operations required by the app, still restricted by table policies.
grant insert, update on public.businesses, public.ads, public.community_posts to authenticated;
grant insert on public.private_messages to authenticated;
grant update (read_at) on public.private_messages to authenticated;
grant insert, update on public.user_reports to authenticated;
grant all privileges on public.user_blocks to authenticated;
-- Never permit self-service role changes; only display_name is editable.
grant update (display_name) on public.profiles to authenticated;
commit;
