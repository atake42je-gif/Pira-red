-- PiraRed: image storage for community listings.
begin;
alter table public.community_posts add column if not exists image_url text;
create index if not exists community_posts_image_url_idx on public.community_posts(id) where image_url is not null;
insert into storage.buckets (id, name, public, file_size_limit, allowed_mime_types)
values ('community-images','community-images',true,5242880,array['image/jpeg','image/png','image/webp'])
on conflict (id) do update set public=true,file_size_limit=5242880,allowed_mime_types=array['image/jpeg','image/png','image/webp'];
drop policy if exists "community images public read" on storage.objects;
create policy "community images public read" on storage.objects for select to anon, authenticated using (bucket_id='community-images');
drop policy if exists "users upload own community images" on storage.objects;
create policy "users upload own community images" on storage.objects for insert to authenticated with check (bucket_id='community-images' and (storage.foldername(name))[1]=(select auth.uid())::text);
drop policy if exists "users update own community images" on storage.objects;
create policy "users update own community images" on storage.objects for update to authenticated using (bucket_id='community-images' and owner_id=(select auth.uid())::text) with check (bucket_id='community-images' and owner_id=(select auth.uid())::text);
drop policy if exists "users delete own community images" on storage.objects;
create policy "users delete own community images" on storage.objects for delete to authenticated using (bucket_id='community-images' and owner_id=(select auth.uid())::text);
commit;
