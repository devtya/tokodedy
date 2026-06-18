-- ============================================================
-- Public Read Policy untuk DedyStore (Anon Access)
-- Jalankan di: Supabase Dashboard → SQL Editor → New Query
-- ============================================================
-- Tambah policy SELECT untuk anon/public pada tabel produk & satuan_produk
-- agar DedyStore bisa membaca katalog tanpa login.

CREATE POLICY "public_read" ON produk
  FOR SELECT USING (true);

CREATE POLICY "public_read" ON satuan_produk
  FOR SELECT USING (true);

-- Verifikasi: tampilkan policy yang aktif
SELECT
  schemaname,
  tablename,
  policyname,
  roles,
  cmd
FROM pg_policies
WHERE tablename IN ('produk', 'satuan_produk')
ORDER BY tablename, policyname;
