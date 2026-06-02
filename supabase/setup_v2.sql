-- ============================================================
-- Tokodedy — Supabase Setup SQL (Single-Toko / Single-Store)
-- Jalankan di: Supabase Dashboard → SQL Editor → New Query
-- ============================================================

CREATE EXTENSION IF NOT EXISTS "uuid-ossp";

-- ============================================================
-- 1. PROFILES (linked ke Supabase Auth.users)
-- ============================================================
CREATE TABLE IF NOT EXISTS profiles (
  id         UUID PRIMARY KEY REFERENCES auth.users(id) ON DELETE CASCADE,
  nama       TEXT,
  role       TEXT NOT NULL DEFAULT 'kasir' CHECK (role IN ('owner', 'kasir')),
  created_at TIMESTAMPTZ DEFAULT NOW()
);

-- ============================================================
-- 2. PRODUK
-- ============================================================
CREATE TABLE IF NOT EXISTS produk (
  id          UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
  nama        TEXT NOT NULL,
  barcode     TEXT,
  harga_beli  NUMERIC(15,2) NOT NULL DEFAULT 0,
  harga_jual  NUMERIC(15,2) NOT NULL DEFAULT 0,
  stok        INTEGER NOT NULL DEFAULT 0,
  stok_minimum INTEGER,
  kategori    TEXT,
  satuan      TEXT NOT NULL DEFAULT 'pcs',
  updated_at  TIMESTAMPTZ DEFAULT NOW(),
  created_at  TIMESTAMPTZ DEFAULT NOW()
);

-- ============================================================
-- 3. SATUAN PRODUK (multi-satuan)
-- ============================================================
CREATE TABLE IF NOT EXISTS satuan_produk (
  id         UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
  produk_id  UUID NOT NULL REFERENCES produk(id) ON DELETE CASCADE,
  nama       TEXT NOT NULL,
  konversi   NUMERIC(15,4) NOT NULL DEFAULT 1,
  harga_beli NUMERIC(15,2) NOT NULL DEFAULT 0,
  harga_jual NUMERIC(15,2) NOT NULL DEFAULT 0,
  updated_at TIMESTAMPTZ DEFAULT NOW()
);

-- ============================================================
-- 4. SUPPLIER
-- ============================================================
CREATE TABLE IF NOT EXISTS supplier (
  id         UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
  nama       TEXT NOT NULL,
  telepon    TEXT,
  alamat     TEXT,
  updated_at TIMESTAMPTZ DEFAULT NOW(),
  created_at TIMESTAMPTZ DEFAULT NOW()
);

-- ============================================================
-- 5. TRANSAKSI (penjualan kasir)
-- ============================================================
CREATE TABLE IF NOT EXISTS transaksi (
  id           UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
  kasir_id     UUID REFERENCES profiles(id) ON DELETE SET NULL,
  total_harga  NUMERIC(15,2) NOT NULL DEFAULT 0,
  jumlah_bayar NUMERIC(15,2) NOT NULL DEFAULT 0,
  kembalian    NUMERIC(15,2) NOT NULL DEFAULT 0,
  status       TEXT NOT NULL DEFAULT 'lunas' CHECK (status IN ('lunas','hutang')),
  updated_at   TIMESTAMPTZ DEFAULT NOW(),
  created_at   TIMESTAMPTZ DEFAULT NOW()
);

-- ============================================================
-- 6. ITEM TRANSAKSI
-- ============================================================
CREATE TABLE IF NOT EXISTS item_transaksi (
  id           UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
  transaksi_id UUID NOT NULL REFERENCES transaksi(id) ON DELETE CASCADE,
  produk_id    UUID NOT NULL REFERENCES produk(id) ON DELETE RESTRICT,
  jumlah       INTEGER NOT NULL DEFAULT 1,
  harga_satuan NUMERIC(15,2) NOT NULL DEFAULT 0,
  subtotal     NUMERIC(15,2) NOT NULL DEFAULT 0
);

-- ============================================================
-- 7. HUTANG PIUTANG
-- ============================================================
CREATE TABLE IF NOT EXISTS hutang_piutang (
  id                  UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
  transaksi_id        UUID REFERENCES transaksi(id) ON DELETE SET NULL,
  nama_pelanggan      TEXT NOT NULL,
  jumlah              NUMERIC(15,2) NOT NULL DEFAULT 0,
  status              TEXT NOT NULL DEFAULT 'belum_lunas' CHECK (status IN ('belum_lunas','lunas')),
  tanggal_jatuh_tempo TIMESTAMPTZ,
  updated_at          TIMESTAMPTZ DEFAULT NOW(),
  created_at          TIMESTAMPTZ DEFAULT NOW()
);

-- ============================================================
-- 8. PEMBELIAN (dari supplier)
-- ============================================================
CREATE TABLE IF NOT EXISTS pembelian (
  id            UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
  supplier_id   UUID REFERENCES supplier(id) ON DELETE SET NULL,
  nama_supplier TEXT,
  total_harga   NUMERIC(15,2) NOT NULL DEFAULT 0,
  updated_at    TIMESTAMPTZ DEFAULT NOW(),
  created_at    TIMESTAMPTZ DEFAULT NOW()
);

-- ============================================================
-- 9. ITEM PEMBELIAN
-- ============================================================
CREATE TABLE IF NOT EXISTS item_pembelian (
  id                UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
  pembelian_id      UUID NOT NULL REFERENCES pembelian(id) ON DELETE CASCADE,
  produk_id         UUID NOT NULL REFERENCES produk(id) ON DELETE RESTRICT,
  jumlah            INTEGER NOT NULL DEFAULT 1,
  harga_beli_satuan NUMERIC(15,2) NOT NULL DEFAULT 0,
  subtotal          NUMERIC(15,2) NOT NULL DEFAULT 0,
  satuan_id         UUID REFERENCES satuan_produk(id) ON DELETE SET NULL,
  konversi          NUMERIC(15,4) NOT NULL DEFAULT 1
);

-- ============================================================
-- 10. RIWAYAT STOK
-- ============================================================
CREATE TABLE IF NOT EXISTS riwayat_stok (
  id         UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
  produk_id  UUID NOT NULL REFERENCES produk(id) ON DELETE CASCADE,
  tipe       TEXT NOT NULL,
  jumlah     INTEGER NOT NULL DEFAULT 0,
  keterangan TEXT,
  created_at TIMESTAMPTZ DEFAULT NOW()
);

-- ============================================================
-- 11. NOTIFIKASI
-- ============================================================
CREATE TABLE IF NOT EXISTS notifikasi (
  id         UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
  judul      TEXT NOT NULL,
  pesan      TEXT NOT NULL,
  tipe       TEXT NOT NULL DEFAULT 'INFO',
  is_read    BOOLEAN NOT NULL DEFAULT FALSE,
  created_at TIMESTAMPTZ DEFAULT NOW()
);

-- ============================================================
-- 12. PENDING ORDER
-- ============================================================
CREATE TABLE IF NOT EXISTS pending_order (
  id             UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
  nama_pelanggan TEXT NOT NULL,
  catatan        TEXT,
  created_at     TIMESTAMPTZ DEFAULT NOW()
);

CREATE TABLE IF NOT EXISTS pending_order_item (
  id               UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
  pending_order_id UUID NOT NULL REFERENCES pending_order(id) ON DELETE CASCADE,
  produk_id        UUID NOT NULL REFERENCES produk(id) ON DELETE RESTRICT,
  nama_produk      TEXT NOT NULL,
  harga_jual       NUMERIC(15,2) NOT NULL DEFAULT 0,
  jumlah           INTEGER NOT NULL DEFAULT 1,
  diskon_tipe      INTEGER NOT NULL DEFAULT 0,
  diskon_value     NUMERIC(15,2) NOT NULL DEFAULT 0,
  subtotal         NUMERIC(15,2) NOT NULL DEFAULT 0
);

-- ============================================================
-- 13. PENDING PEMBELIAN
-- ============================================================
CREATE TABLE IF NOT EXISTS pending_pembelian (
  id             UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
  supplier_id    UUID REFERENCES supplier(id) ON DELETE SET NULL,
  nama_supplier  TEXT,
  is_ppn_enabled BOOLEAN NOT NULL DEFAULT FALSE,
  ppn_percent    NUMERIC(5,2) NOT NULL DEFAULT 11.0,
  created_at     TIMESTAMPTZ DEFAULT NOW()
);

CREATE TABLE IF NOT EXISTS pending_pembelian_item (
  id                   UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
  pending_pembelian_id UUID NOT NULL REFERENCES pending_pembelian(id) ON DELETE CASCADE,
  produk_id            UUID NOT NULL REFERENCES produk(id) ON DELETE RESTRICT,
  nama_produk          TEXT NOT NULL,
  jumlah               INTEGER NOT NULL DEFAULT 1,
  harga_beli_satuan    NUMERIC(15,2) NOT NULL DEFAULT 0,
  harga_beli_lama      NUMERIC(15,2) NOT NULL DEFAULT 0,
  diskon_tipe          INTEGER NOT NULL DEFAULT 0,
  diskon_value         NUMERIC(15,2) NOT NULL DEFAULT 0,
  satuan_id            UUID REFERENCES satuan_produk(id) ON DELETE SET NULL,
  konversi             NUMERIC(15,4) NOT NULL DEFAULT 1
);

-- ============================================================
-- 14. SUPPLIER PRODUCTS
-- ============================================================
CREATE TABLE IF NOT EXISTS supplier_products (
  id          UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
  supplier_id UUID NOT NULL REFERENCES supplier(id) ON DELETE CASCADE,
  produk_id   UUID NOT NULL REFERENCES produk(id) ON DELETE CASCADE,
  harga       NUMERIC(15,2) NOT NULL DEFAULT 0,
  updated_at  TIMESTAMPTZ DEFAULT NOW(),
  UNIQUE(supplier_id, produk_id)
);

-- ============================================================
-- 15. PURCHASE ORDER (PO)
-- ============================================================
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

-- ============================================================
-- INDEX
-- ============================================================
CREATE INDEX IF NOT EXISTS idx_purchase_order_items_po_id ON purchase_order_items (po_id);
CREATE INDEX IF NOT EXISTS idx_purchase_orders_updated_at ON purchase_orders (updated_at);
CREATE INDEX IF NOT EXISTS idx_purchase_orders_status     ON purchase_orders (status);

-- ============================================================
-- AUTO-UPDATE updated_at TRIGGER
-- ============================================================
CREATE OR REPLACE FUNCTION update_updated_at_column()
RETURNS TRIGGER LANGUAGE plpgsql AS $$
BEGIN
  NEW.updated_at = NOW();
  RETURN NEW;
END;
$$;

CREATE TRIGGER set_updated_at_produk           BEFORE UPDATE ON produk                FOR EACH ROW EXECUTE FUNCTION update_updated_at_column();
CREATE TRIGGER set_updated_at_satuan_produk    BEFORE UPDATE ON satuan_produk         FOR EACH ROW EXECUTE FUNCTION update_updated_at_column();
CREATE TRIGGER set_updated_at_supplier         BEFORE UPDATE ON supplier              FOR EACH ROW EXECUTE FUNCTION update_updated_at_column();
CREATE TRIGGER set_updated_at_transaksi        BEFORE UPDATE ON transaksi             FOR EACH ROW EXECUTE FUNCTION update_updated_at_column();
CREATE TRIGGER set_updated_at_hutang_piutang   BEFORE UPDATE ON hutang_piutang        FOR EACH ROW EXECUTE FUNCTION update_updated_at_column();
CREATE TRIGGER set_updated_at_pembelian        BEFORE UPDATE ON pembelian             FOR EACH ROW EXECUTE FUNCTION update_updated_at_column();
CREATE TRIGGER set_updated_at_supplier_products BEFORE UPDATE ON supplier_products    FOR EACH ROW EXECUTE FUNCTION update_updated_at_column();
CREATE TRIGGER set_updated_at_pending_order    BEFORE UPDATE ON pending_order         FOR EACH ROW EXECUTE FUNCTION update_updated_at_column();
CREATE TRIGGER set_updated_at_pending_pembelian BEFORE UPDATE ON pending_pembelian    FOR EACH ROW EXECUTE FUNCTION update_updated_at_column();
CREATE TRIGGER set_updated_at_purchase_orders  BEFORE UPDATE ON purchase_orders       FOR EACH ROW EXECUTE FUNCTION update_updated_at_column();

-- ============================================================
-- ROW LEVEL SECURITY (RLS)
-- ============================================================
ALTER TABLE profiles ENABLE ROW LEVEL SECURITY;
ALTER TABLE produk ENABLE ROW LEVEL SECURITY;
ALTER TABLE satuan_produk ENABLE ROW LEVEL SECURITY;
ALTER TABLE supplier ENABLE ROW LEVEL SECURITY;
ALTER TABLE transaksi ENABLE ROW LEVEL SECURITY;
ALTER TABLE item_transaksi ENABLE ROW LEVEL SECURITY;
ALTER TABLE hutang_piutang ENABLE ROW LEVEL SECURITY;
ALTER TABLE pembelian ENABLE ROW LEVEL SECURITY;
ALTER TABLE item_pembelian ENABLE ROW LEVEL SECURITY;
ALTER TABLE riwayat_stok ENABLE ROW LEVEL SECURITY;
ALTER TABLE notifikasi ENABLE ROW LEVEL SECURITY;
ALTER TABLE pending_order ENABLE ROW LEVEL SECURITY;
ALTER TABLE pending_order_item ENABLE ROW LEVEL SECURITY;
ALTER TABLE pending_pembelian ENABLE ROW LEVEL SECURITY;
ALTER TABLE pending_pembelian_item ENABLE ROW LEVEL SECURITY;
ALTER TABLE supplier_products ENABLE ROW LEVEL SECURITY;
ALTER TABLE purchase_orders ENABLE ROW LEVEL SECURITY;
ALTER TABLE purchase_order_items ENABLE ROW LEVEL SECURITY;

-- RLS: profiles — user hanya bisa lihat & edit profile sendiri
CREATE POLICY "self_select_profile" ON profiles
  FOR SELECT USING (id = auth.uid());
CREATE POLICY "self_insert_profile" ON profiles
  FOR INSERT WITH CHECK (id = auth.uid());
CREATE POLICY "self_update_profile" ON profiles
  FOR UPDATE USING (id = auth.uid());

-- RLS: semua tabel bisnis — user terdaftar di profiles bisa akses semua
CREATE POLICY "authorized_access" ON produk                FOR ALL USING (EXISTS (SELECT 1 FROM profiles WHERE id = auth.uid()));
CREATE POLICY "authorized_access" ON satuan_produk         FOR ALL USING (EXISTS (SELECT 1 FROM profiles WHERE id = auth.uid()));
CREATE POLICY "authorized_access" ON supplier              FOR ALL USING (EXISTS (SELECT 1 FROM profiles WHERE id = auth.uid()));
CREATE POLICY "authorized_access" ON transaksi             FOR ALL USING (EXISTS (SELECT 1 FROM profiles WHERE id = auth.uid()));
CREATE POLICY "authorized_access" ON item_transaksi        FOR ALL USING (EXISTS (SELECT 1 FROM profiles WHERE id = auth.uid()));
CREATE POLICY "authorized_access" ON hutang_piutang        FOR ALL USING (EXISTS (SELECT 1 FROM profiles WHERE id = auth.uid()));
CREATE POLICY "authorized_access" ON pembelian             FOR ALL USING (EXISTS (SELECT 1 FROM profiles WHERE id = auth.uid()));
CREATE POLICY "authorized_access" ON item_pembelian        FOR ALL USING (EXISTS (SELECT 1 FROM profiles WHERE id = auth.uid()));
CREATE POLICY "authorized_access" ON riwayat_stok          FOR ALL USING (EXISTS (SELECT 1 FROM profiles WHERE id = auth.uid()));
CREATE POLICY "authorized_access" ON notifikasi            FOR ALL USING (EXISTS (SELECT 1 FROM profiles WHERE id = auth.uid()));
CREATE POLICY "authorized_access" ON pending_order         FOR ALL USING (EXISTS (SELECT 1 FROM profiles WHERE id = auth.uid()));
CREATE POLICY "authorized_access" ON pending_order_item    FOR ALL USING (EXISTS (SELECT 1 FROM profiles WHERE id = auth.uid()));
CREATE POLICY "authorized_access" ON pending_pembelian     FOR ALL USING (EXISTS (SELECT 1 FROM profiles WHERE id = auth.uid()));
CREATE POLICY "authorized_access" ON pending_pembelian_item FOR ALL USING (EXISTS (SELECT 1 FROM profiles WHERE id = auth.uid()));
CREATE POLICY "authorized_access" ON supplier_products     FOR ALL USING (EXISTS (SELECT 1 FROM profiles WHERE id = auth.uid()));
CREATE POLICY "authorized_access" ON purchase_orders       FOR ALL USING (EXISTS (SELECT 1 FROM profiles WHERE id = auth.uid()));
CREATE POLICY "authorized_access" ON purchase_order_items  FOR ALL USING (EXISTS (SELECT 1 FROM profiles WHERE id = auth.uid()));
