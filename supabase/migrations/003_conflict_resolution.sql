-- ============================================================
-- Migration 003: Conflict Resolution (Last-Write-Wins)
-- ============================================================
-- Menambahkan updated_at + trigger untuk tabel yang belum
-- punya agar Last-Write-Wins conflict resolution berfungsi penuh.
-- ============================================================

-- 1. Tambah kolom updated_at untuk tabel yang belum punya
ALTER TABLE pending_order      ADD COLUMN IF NOT EXISTS updated_at TIMESTAMPTZ DEFAULT NOW();
ALTER TABLE pending_pembelian  ADD COLUMN IF NOT EXISTS updated_at TIMESTAMPTZ DEFAULT NOW();

-- 2. Trigger function (sudah ada di setup_v2.sql, aman di-run ulang)
CREATE OR REPLACE FUNCTION update_updated_at_column()
RETURNS TRIGGER LANGUAGE plpgsql AS $$
BEGIN
  NEW.updated_at = NOW();
  RETURN NEW;
END;
$$;

-- 3. Tambah trigger untuk pending_order & pending_pembelian (safe untuk re-run)
DO $$
BEGIN
  IF NOT EXISTS (SELECT 1 FROM pg_trigger WHERE tgname = 'set_updated_at_pending_order') THEN
    CREATE TRIGGER set_updated_at_pending_order
      BEFORE UPDATE ON pending_order
      FOR EACH ROW EXECUTE FUNCTION update_updated_at_column();
  END IF;
  IF NOT EXISTS (SELECT 1 FROM pg_trigger WHERE tgname = 'set_updated_at_pending_pembelian') THEN
    CREATE TRIGGER set_updated_at_pending_pembelian
      BEFORE UPDATE ON pending_pembelian
      FOR EACH ROW EXECUTE FUNCTION update_updated_at_column();
  END IF;
  IF NOT EXISTS (SELECT 1 FROM pg_trigger WHERE tgname = 'set_updated_at_toko') THEN
    CREATE TRIGGER set_updated_at_toko
      BEFORE UPDATE ON toko
      FOR EACH ROW EXECUTE FUNCTION update_updated_at_column();
  END IF;
END;
$$;

-- 4. Pastikan index updated_at untuk performa pull
CREATE INDEX IF NOT EXISTS idx_pending_order_updated_at      ON pending_order     (updated_at);
CREATE INDEX IF NOT EXISTS idx_pending_pembelian_updated_at  ON pending_pembelian (updated_at);
