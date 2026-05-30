-- ============================================================
-- RLS Fix — Registration Flow
-- Jalankan di: Supabase Dashboard → SQL Editor → New Query
-- ============================================================

-- 1. Fix: register_insert_toko — pastikan WITH CHECK (true) untuk anon signup
DROP POLICY IF EXISTS "register_insert_toko" ON public.toko;
CREATE POLICY "register_insert_toko" ON public.toko
  FOR INSERT
  WITH CHECK (true);

-- 2. Fix: register_insert_profiles — pastikan WITH CHECK (true) untuk anon signup
DROP POLICY IF EXISTS "register_insert_profiles" ON public.profiles;
CREATE POLICY "register_insert_profiles" ON public.profiles
  FOR INSERT
  WITH CHECK (true);

-- 3. Verifikasi: tampilkan policy yang aktif
SELECT
  schemaname,
  tablename,
  policyname,
  permissive,
  roles,
  cmd,
  qual,
  with_check
FROM pg_policies
WHERE tablename IN ('toko', 'profiles')
ORDER BY tablename, policyname;
