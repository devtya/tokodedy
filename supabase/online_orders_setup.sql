-- ============================================================
-- Tokodedy & DedyStore — Online Orders Setup SQL
-- ============================================================

-- ============================================================
-- 1. ADD IMAGE_URL TO PRODUK
-- ============================================================
ALTER TABLE produk ADD COLUMN IF NOT EXISTS image_url TEXT;

-- Reload schema agar PostgREST langsung mengenali kolom baru
NOTIFY pgrst, 'reload schema';

-- ============================================================
-- 2. ONLINE CUSTOMERS
-- Profil pelanggan DedyStore. ID-nya adalah ID dari auth.users
-- ============================================================
CREATE TABLE IF NOT EXISTS online_customers (
  id         UUID PRIMARY KEY REFERENCES auth.users(id) ON DELETE CASCADE,
  nama       TEXT NOT NULL,
  telepon    TEXT,
  alamat     TEXT,
  created_at TIMESTAMPTZ DEFAULT NOW(),
  updated_at TIMESTAMPTZ DEFAULT NOW()
);

-- Auto-update trigger
CREATE TRIGGER set_updated_at_online_customers BEFORE UPDATE ON online_customers FOR EACH ROW EXECUTE FUNCTION update_updated_at_column();

-- RLS online_customers
ALTER TABLE online_customers ENABLE ROW LEVEL SECURITY;
-- Pelanggan (DedyStore) hanya bisa melihat dan mengedit data miliknya sendiri.
CREATE POLICY "customer_self_access" ON online_customers
  FOR ALL USING (id = auth.uid()) WITH CHECK (id = auth.uid());
-- Kasir (Tokodedy) bisa melihat profil semua customer, tapi tidak bisa edit (readonly)
CREATE POLICY "kasir_read_customers" ON online_customers
  FOR SELECT USING (
    EXISTS (
      SELECT 1 FROM profiles WHERE profiles.id = auth.uid()
    )
  );

-- ============================================================
-- 3. ONLINE ORDERS
-- ============================================================
CREATE TABLE IF NOT EXISTS online_orders (
  id               UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
  customer_id      UUID NOT NULL REFERENCES online_customers(id) ON DELETE RESTRICT,
  status           TEXT NOT NULL DEFAULT 'pending' CHECK (status IN ('pending', 'processing', 'shipped', 'completed', 'cancelled')),
  total_harga      NUMERIC(15,2) NOT NULL DEFAULT 0,
  metode_pengiriman TEXT NOT NULL DEFAULT 'pickup' CHECK (metode_pengiriman IN ('pickup', 'delivery')),
  alamat_pengiriman TEXT,
  catatan          TEXT,
  created_at       TIMESTAMPTZ DEFAULT NOW(),
  updated_at       TIMESTAMPTZ DEFAULT NOW()
);

CREATE TRIGGER set_updated_at_online_orders BEFORE UPDATE ON online_orders FOR EACH ROW EXECUTE FUNCTION update_updated_at_column();

-- RLS online_orders
ALTER TABLE online_orders ENABLE ROW LEVEL SECURITY;
-- Pelanggan (DedyStore) dapat membaca orderannya dan membuat order baru
CREATE POLICY "customer_read_orders" ON online_orders
  FOR SELECT USING (customer_id = auth.uid());
CREATE POLICY "customer_insert_orders" ON online_orders
  FOR INSERT WITH CHECK (customer_id = auth.uid());
-- Pelanggan dapat update orderannya jika masih pending (misal batal pesanan)
CREATE POLICY "customer_update_orders" ON online_orders
  FOR UPDATE USING (customer_id = auth.uid() AND status = 'pending');

-- Kasir (Tokodedy) dapat melihat dan mengupdate semua orderan
CREATE POLICY "kasir_access_orders" ON online_orders
  FOR ALL USING (EXISTS (SELECT 1 FROM profiles WHERE id = auth.uid()));

-- ============================================================
-- 4. ONLINE ORDER ITEMS
-- ============================================================
CREATE TABLE IF NOT EXISTS online_order_items (
  id               UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
  online_order_id  UUID NOT NULL REFERENCES online_orders(id) ON DELETE CASCADE,
  produk_id        UUID NOT NULL REFERENCES produk(id) ON DELETE RESTRICT,
  nama_produk      TEXT NOT NULL,
  harga_satuan     NUMERIC(15,2) NOT NULL DEFAULT 0,
  jumlah           INTEGER NOT NULL DEFAULT 1,
  subtotal         NUMERIC(15,2) NOT NULL DEFAULT 0,
  satuan_id        UUID REFERENCES satuan_produk(id) ON DELETE SET NULL,
  konversi         NUMERIC(15,4) NOT NULL DEFAULT 1
);

-- RLS online_order_items
ALTER TABLE online_order_items ENABLE ROW LEVEL SECURITY;
-- Pelanggan (DedyStore) dapat membaca dan menambah order item
CREATE POLICY "customer_read_order_items" ON online_order_items
  FOR SELECT USING (
    EXISTS (
      SELECT 1 FROM online_orders WHERE online_orders.id = online_order_id AND online_orders.customer_id = auth.uid()
    )
  );
CREATE POLICY "customer_insert_order_items" ON online_order_items
  FOR INSERT WITH CHECK (
    EXISTS (
      SELECT 1 FROM online_orders WHERE online_orders.id = online_order_id AND online_orders.customer_id = auth.uid()
    )
  );
-- Pelanggan dapat mengedit/menghapus item selama order masih pending
CREATE POLICY "customer_update_order_items" ON online_order_items
  FOR ALL USING (
    EXISTS (
      SELECT 1 FROM online_orders WHERE online_orders.id = online_order_id AND online_orders.customer_id = auth.uid() AND online_orders.status = 'pending'
    )
  );

-- Kasir (Tokodedy) dapat mengakses semua item order
CREATE POLICY "kasir_access_order_items" ON online_order_items
  FOR ALL USING (EXISTS (SELECT 1 FROM profiles WHERE id = auth.uid()));

-- ============================================================
-- 5. ENABLE REALTIME
-- ============================================================
-- Aktifkan Realtime untuk tabel online_orders agar notifikasi langsung masuk ke kasir
DO $$
BEGIN
  IF NOT EXISTS (
    SELECT 1 FROM pg_publication_tables 
    WHERE pubname = 'supabase_realtime' AND tablename = 'online_orders'
  ) THEN
    ALTER PUBLICATION supabase_realtime ADD TABLE online_orders;
  END IF;
END $$;

NOTIFY pgrst, 'reload schema';
