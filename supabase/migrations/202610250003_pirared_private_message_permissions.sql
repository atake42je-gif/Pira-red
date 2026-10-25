-- Restrict message updates to the read receipt only.
begin;
revoke update on public.private_messages from authenticated;
grant update (read_at) on public.private_messages to authenticated;
drop policy if exists "recipient marks messages read" on public.private_messages;
create policy "recipient marks messages read"
  on public.private_messages for update to authenticated
  using ((select auth.uid()) = recipient_id)
  with check ((select auth.uid()) = recipient_id);
commit;
