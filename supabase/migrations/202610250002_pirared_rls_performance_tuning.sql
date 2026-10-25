-- Small RLS/performance maintenance for PiraRed.
begin;
create index if not exists ads_reviewed_by_idx on public.ads(reviewed_by);
drop policy if exists "Users can read their own payment orders" on public.payment_orders;
create policy "Users can read their own payment orders"
  on public.payment_orders for select to authenticated
  using ((select auth.uid()) = user_id);
commit;
