-- ============================================================
-- Supabase SQL Setup for Hend Kasir Sync
-- Jalankan seluruh SQL ini di Supabase SQL Editor
-- https://supabase.com/dashboard/project/YOUR_PROJECT/sql/new
-- ============================================================

-- 1. Create records table (jika belum ada)
CREATE TABLE IF NOT EXISTS records (
  uuid UUID PRIMARY KEY,
  data JSONB NOT NULL,
  updated_at BIGINT DEFAULT 0,
  created_at TIMESTAMPTZ DEFAULT NOW()
);

-- 2. Migration: tambah kolom updated_at jika tabel sudah ada
ALTER TABLE records ADD COLUMN IF NOT EXISTS updated_at BIGINT DEFAULT 0;

-- 3. Trigger function: auto-update updated_at setiap kali row berubah
CREATE OR REPLACE FUNCTION update_records_updated_at()
RETURNS TRIGGER AS $$
BEGIN
  NEW.updated_at = EXTRACT(EPOCH FROM NOW()) * 1000;
  RETURN NEW;
END;
$$ LANGUAGE plpgsql;

DROP TRIGGER IF EXISTS trg_records_updated_at ON records;
CREATE TRIGGER trg_records_updated_at
  BEFORE INSERT OR UPDATE ON records
  FOR EACH ROW
  EXECUTE FUNCTION update_records_updated_at();

-- 4. Indexes
CREATE INDEX IF NOT EXISTS idx_records_updated_at ON records (updated_at);
CREATE INDEX IF NOT EXISTS idx_records_data_key ON records USING gin (data jsonb_path_ops);

-- 5. Row Level Security (opsional, untuk production)
ALTER TABLE records ENABLE ROW LEVEL SECURITY;

-- 6. Allow anon key access (drop first if re-running)
DROP POLICY IF EXISTS "Enable all for anon" ON records;
CREATE POLICY "Enable all for anon" ON records
  FOR ALL
  USING (true)
  WITH CHECK (true);

-- 7. Reload PostgREST schema cache agar kolom baru langsung dikenali
NOTIFY pgrst, 'reload schema';
