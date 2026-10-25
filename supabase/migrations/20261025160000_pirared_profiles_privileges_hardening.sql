-- PiraRed security hardening: remove broad table privileges on profiles.
-- RLS alone is not sufficient if a user has table-level UPDATE; grant only the intended columns.
begin;
revoke all privileges on table public.profiles from anon, authenticated;
grant select on table public.profiles to authenticated;
grant update (display_name) on table public.profiles to authenticated;
commit;
