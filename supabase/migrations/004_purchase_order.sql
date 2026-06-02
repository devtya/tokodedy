-- ============================================================
-- Migration 004: Purchase Order (PO)
-- ============================================================
-- Tambah tabel purchase_orders dan purchase_order_items
-- untuk fitur Pesan ke Supplier (barang indent/kosong).
--
-- NOTE: Jika database masih kosong, cukup jalankan setup_v2.sql
-- yang sudah include tabel ini. Migration ini hanya untuk
-- upgrade database yang sudah berisi data.
-- ============================================================

-- 1. PURCHASE ORDERS
CREATE TABLE IF NOT EXISTS purchase_orders (
  id           UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
  supplier_id  UUID REFERENCES supplier(id) ON DELETE SET NULL,
  nama_supplier TEXT,
  status       TEXT NOT NULL DEFAULT 'open' CHECK (status IN ('open', 'partial', 'received', 'cancelled')),
  total_harga  NUMERIC(15,2) NOT NULL DEFAULT 0,
  notes        TEXT,
  updated_at   TIMESTAMPTZ DEFAULT NOW(),
  created_at   TIMESTAMPTZ DEFAULT NOW()
);

-- 2. PURCHASE ORDER ITEMS
CREATE TABLE IF NOT EXISTS purchase_order_items (
  id            UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
  po_id         UUID NOT NULL REFERENCES purchase_orders(id) ON DELETE CASCADE,
  produk_id     UUID NOT NULL REFERENCES produk(id) ON DELETE CASCADE,
  nama_produk   TEXT,
  qty_pesan     INTEGER NOT NULL DEFAULT 1,
  qty_terima    INTEGER NOT NULL DEFAULT 0,
  harga_satuan  NUMERIC(15,2) NOT NULL DEFAULT 0,
  subtotal      NUMERIC(15,2) NOT NULL DEFAULT 0,
  satuan_id     TEXT,
  konversi      NUMERIC(15,4) NOT NULL DEFAULT 1.0
);

-- 3. INDEX
CREATE INDEX IF NOT EXISTS idx_purchase_order_items_po_id ON purchase_order_items (po_id);
CREATE INDEX IF NOT EXISTS idx_purchase_orders_updated_at ON purchase_orders (updated_at);
CREATE INDEX IF NOT EXISTS idx_purchase_orders_status     ON purchase_orders (status);

-- 4. TRIGGER updated_at
CREATE TRIGGER IF NOT EXISTS set_updated_at_purchase_orders
  BEFORE UPDATE ON purchase_orders
  FOR EACH ROW EXECUTE FUNCTION update_updated_at_column();

-- 5. RLS (Row Level Security)
ALTER TABLE purchase_orders ENABLE ROW LEVEL SECURITY;
ALTER TABLE purchase_order_items ENABLE ROW LEVEL SECURITY;

CREATE POLICY "authorized_access" ON purchase_orders
  FOR ALL USING (EXISTS (SELECT 1 FROM profiles WHERE id = auth.uid()));

CREATE POLICY "authorized_access" ON purchase_order_items
  FOR ALL USING (EXISTS (SELECT 1 FROM profiles WHERE id = auth.uid()));

NOTIFY pgrst, 'reload schema';
