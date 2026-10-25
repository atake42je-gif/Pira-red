-- Prevent private messages between users who blocked each other.
begin;
drop policy if exists "send own private messages" on public.private_messages;
create policy "send own private messages" on public.private_messages
for insert to authenticated
with check (
  sender_id = (select auth.uid())
  and recipient_id <> (select auth.uid())
  and not exists (
    select 1 from public.user_blocks b
    where (b.blocker_id = (select auth.uid()) and b.blocked_id = recipient_id)
       or (b.blocker_id = recipient_id and b.blocked_id = (select auth.uid()))
  )
);
commit;
