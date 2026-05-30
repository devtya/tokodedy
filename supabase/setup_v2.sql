-- ============================================================
-- HendKasir v2 — Supabase Setup SQL
-- Jalankan di: Supabase Dashboard → SQL Editor → New Query
-- PENTING: Hapus tabel lama (records, stores) setelah migrasi data
-- ============================================================

-- EKSTENSI
CREATE EXTENSION IF NOT EXISTS "uuid-ossp";

-- ============================================================
-- 1. TOKO
-- ============================================================
CREATE TABLE IF NOT EXISTS toko (
  id         UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
  nama       TEXT NOT NULL,
  alamat     TEXT,
  telepon    TEXT,
  owner_id   UUID REFERENCES auth.users(id) ON DELETE SET NULL,
  stok_minimum_global INTEGER NOT NULL DEFAULT 0,
  created_at TIMESTAMPTZ DEFAULT NOW()
);

-- ============================================================
-- 2. PROFILES (user per toko — linked ke Supabase Auth)
-- ============================================================
CREATE TABLE IF NOT EXISTS profiles (
  id         UUID PRIMARY KEY REFERENCES auth.users(id) ON DELETE CASCADE,
  toko_id    UUID NOT NULL REFERENCES toko(id) ON DELETE CASCADE,
  nama       TEXT,
  role       TEXT NOT NULL DEFAULT 'kasir' CHECK (role IN ('owner', 'kasir')),
  created_at TIMESTAMPTZ DEFAULT NOW()
);

-- ============================================================
-- 3. PRODUK
-- ============================================================
CREATE TABLE IF NOT EXISTS produk (
  id          UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
  toko_id     UUID NOT NULL REFERENCES toko(id) ON DELETE CASCADE,
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
-- 4. SATUAN PRODUK (multi-satuan)
-- ============================================================
CREATE TABLE IF NOT EXISTS satuan_produk (
  id         UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
  toko_id    UUID NOT NULL REFERENCES toko(id) ON DELETE CASCADE,
  produk_id  UUID NOT NULL REFERENCES produk(id) ON DELETE CASCADE,
  nama       TEXT NOT NULL,
  konversi   NUMERIC(15,4) NOT NULL DEFAULT 1,
  harga_beli NUMERIC(15,2) NOT NULL DEFAULT 0,
  harga_jual NUMERIC(15,2) NOT NULL DEFAULT 0,
  updated_at TIMESTAMPTZ DEFAULT NOW()
);

-- ============================================================
-- 5. SUPPLIER
-- ============================================================
CREATE TABLE IF NOT EXISTS supplier (
  id         UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
  toko_id    UUID NOT NULL REFERENCES toko(id) ON DELETE CASCADE,
  nama       TEXT NOT NULL,
  telepon    TEXT,
  alamat     TEXT,
  updated_at TIMESTAMPTZ DEFAULT NOW(),
  created_at TIMESTAMPTZ DEFAULT NOW()
);

-- ============================================================
-- 6. TRANSAKSI (penjualan kasir)
-- ============================================================
CREATE TABLE IF NOT EXISTS transaksi (
  id           UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
  toko_id      UUID NOT NULL REFERENCES toko(id) ON DELETE CASCADE,
  kasir_id     UUID REFERENCES profiles(id) ON DELETE SET NULL,
  total_harga  NUMERIC(15,2) NOT NULL DEFAULT 0,
  jumlah_bayar NUMERIC(15,2) NOT NULL DEFAULT 0,
  kembalian    NUMERIC(15,2) NOT NULL DEFAULT 0,
  status       TEXT NOT NULL DEFAULT 'lunas' CHECK (status IN ('lunas','hutang')),
  updated_at   TIMESTAMPTZ DEFAULT NOW(),
  created_at   TIMESTAMPTZ DEFAULT NOW()
);

-- ============================================================
-- 7. ITEM TRANSAKSI
-- ============================================================
CREATE TABLE IF NOT EXISTS item_transaksi (
  id           UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
  toko_id      UUID NOT NULL REFERENCES toko(id) ON DELETE CASCADE,
  transaksi_id UUID NOT NULL REFERENCES transaksi(id) ON DELETE CASCADE,
  produk_id    UUID NOT NULL REFERENCES produk(id) ON DELETE RESTRICT,
  jumlah       INTEGER NOT NULL DEFAULT 1,
  harga_satuan NUMERIC(15,2) NOT NULL DEFAULT 0,
  subtotal     NUMERIC(15,2) NOT NULL DEFAULT 0
);

-- ============================================================
-- 8. HUTANG PIUTANG
-- ============================================================
CREATE TABLE IF NOT EXISTS hutang_piutang (
  id                  UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
  toko_id             UUID NOT NULL REFERENCES toko(id) ON DELETE CASCADE,
  transaksi_id        UUID REFERENCES transaksi(id) ON DELETE SET NULL,
  nama_pelanggan      TEXT NOT NULL,
  jumlah              NUMERIC(15,2) NOT NULL DEFAULT 0,
  status              TEXT NOT NULL DEFAULT 'belum_lunas' CHECK (status IN ('belum_lunas','lunas')),
  tanggal_jatuh_tempo TIMESTAMPTZ,
  updated_at          TIMESTAMPTZ DEFAULT NOW(),
  created_at          TIMESTAMPTZ DEFAULT NOW()
);

-- ============================================================
-- 9. PEMBELIAN (dari supplier)
-- ============================================================
CREATE TABLE IF NOT EXISTS pembelian (
  id            UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
  toko_id       UUID NOT NULL REFERENCES toko(id) ON DELETE CASCADE,
  supplier_id   UUID REFERENCES supplier(id) ON DELETE SET NULL,
  nama_supplier TEXT,
  total_harga   NUMERIC(15,2) NOT NULL DEFAULT 0,
  updated_at    TIMESTAMPTZ DEFAULT NOW(),
  created_at    TIMESTAMPTZ DEFAULT NOW()
);

-- ============================================================
-- 10. ITEM PEMBELIAN
-- ============================================================
CREATE TABLE IF NOT EXISTS item_pembelian (
  id                UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
  toko_id           UUID NOT NULL REFERENCES toko(id) ON DELETE CASCADE,
  pembelian_id      UUID NOT NULL REFERENCES pembelian(id) ON DELETE CASCADE,
  produk_id         UUID NOT NULL REFERENCES produk(id) ON DELETE RESTRICT,
  jumlah            INTEGER NOT NULL DEFAULT 1,
  harga_beli_satuan NUMERIC(15,2) NOT NULL DEFAULT 0,
  subtotal          NUMERIC(15,2) NOT NULL DEFAULT 0,
  satuan_id         UUID REFERENCES satuan_produk(id) ON DELETE SET NULL,
  konversi          NUMERIC(15,4) NOT NULL DEFAULT 1
);

-- ============================================================
-- 11. RIWAYAT STOK
-- ============================================================
CREATE TABLE IF NOT EXISTS riwayat_stok (
  id         UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
  toko_id    UUID NOT NULL REFERENCES toko(id) ON DELETE CASCADE,
  produk_id  UUID NOT NULL REFERENCES produk(id) ON DELETE CASCADE,
  tipe       TEXT NOT NULL,
  jumlah     INTEGER NOT NULL DEFAULT 0,
  keterangan TEXT,
  created_at TIMESTAMPTZ DEFAULT NOW()
);

-- ============================================================
-- 12. NOTIFIKASI
-- ============================================================
CREATE TABLE IF NOT EXISTS notifikasi (
  id         UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
  toko_id    UUID NOT NULL REFERENCES toko(id) ON DELETE CASCADE,
  judul      TEXT NOT NULL,
  pesan      TEXT NOT NULL,
  tipe       TEXT NOT NULL DEFAULT 'INFO',
  is_read    BOOLEAN NOT NULL DEFAULT FALSE,
  created_at TIMESTAMPTZ DEFAULT NOW()
);

-- ============================================================
-- 13. PENDING ORDER
-- ============================================================
CREATE TABLE IF NOT EXISTS pending_order (
  id             UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
  toko_id        UUID NOT NULL REFERENCES toko(id) ON DELETE CASCADE,
  nama_pelanggan TEXT NOT NULL,
  catatan        TEXT,
  created_at     TIMESTAMPTZ DEFAULT NOW()
);

CREATE TABLE IF NOT EXISTS pending_order_item (
  id               UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
  toko_id          UUID NOT NULL REFERENCES toko(id) ON DELETE CASCADE,
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
-- 14. PENDING PEMBELIAN
-- ============================================================
CREATE TABLE IF NOT EXISTS pending_pembelian (
  id             UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
  toko_id        UUID NOT NULL REFERENCES toko(id) ON DELETE CASCADE,
  supplier_id    UUID REFERENCES supplier(id) ON DELETE SET NULL,
  nama_supplier  TEXT,
  is_ppn_enabled BOOLEAN NOT NULL DEFAULT FALSE,
  ppn_percent    NUMERIC(5,2) NOT NULL DEFAULT 11.0,
  created_at     TIMESTAMPTZ DEFAULT NOW()
);

CREATE TABLE IF NOT EXISTS pending_pembelian_item (
  id                   UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
  toko_id              UUID NOT NULL REFERENCES toko(id) ON DELETE CASCADE,
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
-- 15. SUPPLIER PRODUCTS
-- ============================================================
CREATE TABLE IF NOT EXISTS supplier_products (
  id          UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
  toko_id     UUID NOT NULL REFERENCES toko(id) ON DELETE CASCADE,
  supplier_id UUID NOT NULL REFERENCES supplier(id) ON DELETE CASCADE,
  produk_id   UUID NOT NULL REFERENCES produk(id) ON DELETE CASCADE,
  harga       NUMERIC(15,2) NOT NULL DEFAULT 0,
  updated_at  TIMESTAMPTZ DEFAULT NOW(),
  UNIQUE(supplier_id, produk_id)
);

-- ============================================================
-- ROW LEVEL SECURITY (RLS)
-- ============================================================
ALTER TABLE toko ENABLE ROW LEVEL SECURITY;
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

-- Helper: ambil toko_id dari user aktif
CREATE OR REPLACE FUNCTION get_my_toko_id()
RETURNS UUID LANGUAGE SQL STABLE SECURITY DEFINER AS $$
  SELECT toko_id FROM profiles WHERE id = auth.uid()
$$;

-- RLS: toko
-- Allow registration (anon/authenticated) to create new toko
DROP POLICY IF EXISTS "register_insert_toko" ON toko;
CREATE POLICY "register_insert_toko" ON toko
  FOR INSERT WITH CHECK (true);
-- Owner-only management after registration
CREATE POLICY "owner_manage_toko" ON toko
  FOR ALL USING (owner_id = auth.uid());

-- RLS: profiles — baca semua yg setoko, write owner saja
CREATE POLICY "read_profiles_in_toko" ON profiles
  FOR SELECT USING (toko_id = get_my_toko_id());
-- Allow registration flow (anon/authenticated) to create own profile
DROP POLICY IF EXISTS "register_insert_profiles" ON profiles;
CREATE POLICY "register_insert_profiles" ON profiles
  FOR INSERT WITH CHECK (true);
-- Allow user to insert own profile (needed during registration before profile exists)
-- Without this, owner_write_profiles fails because get_my_toko_id() reads profiles table
CREATE POLICY "self_insert_profile" ON profiles
  FOR INSERT WITH CHECK (id = auth.uid());
CREATE POLICY "owner_write_profiles" ON profiles
  FOR INSERT WITH CHECK (toko_id = get_my_toko_id());
CREATE POLICY "owner_update_profiles" ON profiles
  FOR UPDATE USING (toko_id = get_my_toko_id());
CREATE POLICY "owner_delete_profiles" ON profiles
  FOR DELETE USING (toko_id = get_my_toko_id());
-- user bisa update profile sendiri
CREATE POLICY "self_update_profile" ON profiles
  FOR UPDATE USING (id = auth.uid());

-- RLS: semua tabel bisnis — toko_id match
CREATE POLICY "toko_access" ON produk          FOR ALL USING (toko_id = get_my_toko_id()) WITH CHECK (toko_id = get_my_toko_id());
CREATE POLICY "toko_access" ON satuan_produk   FOR ALL USING (toko_id = get_my_toko_id()) WITH CHECK (toko_id = get_my_toko_id());
CREATE POLICY "toko_access" ON supplier        FOR ALL USING (toko_id = get_my_toko_id()) WITH CHECK (toko_id = get_my_toko_id());
CREATE POLICY "toko_access" ON transaksi       FOR ALL USING (toko_id = get_my_toko_id()) WITH CHECK (toko_id = get_my_toko_id());
CREATE POLICY "toko_access" ON item_transaksi  FOR ALL USING (toko_id = get_my_toko_id()) WITH CHECK (toko_id = get_my_toko_id());
CREATE POLICY "toko_access" ON hutang_piutang  FOR ALL USING (toko_id = get_my_toko_id()) WITH CHECK (toko_id = get_my_toko_id());
CREATE POLICY "toko_access" ON pembelian       FOR ALL USING (toko_id = get_my_toko_id()) WITH CHECK (toko_id = get_my_toko_id());
CREATE POLICY "toko_access" ON item_pembelian  FOR ALL USING (toko_id = get_my_toko_id()) WITH CHECK (toko_id = get_my_toko_id());
CREATE POLICY "toko_access" ON riwayat_stok    FOR ALL USING (toko_id = get_my_toko_id()) WITH CHECK (toko_id = get_my_toko_id());
CREATE POLICY "toko_access" ON notifikasi      FOR ALL USING (toko_id = get_my_toko_id()) WITH CHECK (toko_id = get_my_toko_id());
CREATE POLICY "toko_access" ON pending_order          FOR ALL USING (toko_id = get_my_toko_id()) WITH CHECK (toko_id = get_my_toko_id());
CREATE POLICY "toko_access" ON pending_order_item     FOR ALL USING (toko_id = get_my_toko_id()) WITH CHECK (toko_id = get_my_toko_id());
CREATE POLICY "toko_access" ON pending_pembelian      FOR ALL USING (toko_id = get_my_toko_id()) WITH CHECK (toko_id = get_my_toko_id());
CREATE POLICY "toko_access" ON pending_pembelian_item FOR ALL USING (toko_id = get_my_toko_id()) WITH CHECK (toko_id = get_my_toko_id());
CREATE POLICY "toko_access" ON supplier_products      FOR ALL USING (toko_id = get_my_toko_id()) WITH CHECK (toko_id = get_my_toko_id());

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

CREATE TRIGGER set_updated_at_produk         BEFORE UPDATE ON produk         FOR EACH ROW EXECUTE FUNCTION update_updated_at_column();
CREATE TRIGGER set_updated_at_satuan_produk  BEFORE UPDATE ON satuan_produk  FOR EACH ROW EXECUTE FUNCTION update_updated_at_column();
CREATE TRIGGER set_updated_at_supplier       BEFORE UPDATE ON supplier       FOR EACH ROW EXECUTE FUNCTION update_updated_at_column();
CREATE TRIGGER set_updated_at_transaksi      BEFORE UPDATE ON transaksi      FOR EACH ROW EXECUTE FUNCTION update_updated_at_column();
CREATE TRIGGER set_updated_at_hutang_piutang BEFORE UPDATE ON hutang_piutang FOR EACH ROW EXECUTE FUNCTION update_updated_at_column();
CREATE TRIGGER set_updated_at_pembelian      BEFORE UPDATE ON pembelian      FOR EACH ROW EXECUTE FUNCTION update_updated_at_column();
CREATE TRIGGER set_updated_at_supplier_products BEFORE UPDATE ON supplier_products FOR EACH ROW EXECUTE FUNCTION update_updated_at_column();
CREATE TRIGGER set_updated_at_pending_order      BEFORE UPDATE ON pending_order      FOR EACH ROW EXECUTE FUNCTION update_updated_at_column();
CREATE TRIGGER set_updated_at_pending_pembelian   BEFORE UPDATE ON pending_pembelian  FOR EACH ROW EXECUTE FUNCTION update_updated_at_column();
CREATE TRIGGER set_updated_at_toko                BEFORE UPDATE ON toko               FOR EACH ROW EXECUTE FUNCTION update_updated_at_column();

-- Pastikan tabel yang belum punya updated_at punya kolom tsb (safe untuk existing DB)
ALTER TABLE pending_order      ADD COLUMN IF NOT EXISTS updated_at TIMESTAMPTZ DEFAULT NOW();
ALTER TABLE pending_pembelian  ADD COLUMN IF NOT EXISTS updated_at TIMESTAMPTZ DEFAULT NOW();
ALTER TABLE toko               ADD COLUMN IF NOT EXISTS updated_at TIMESTAMPTZ DEFAULT NOW();

-- ============================================================
-- MIGRASI DATA LAMA: records (JSONB) → dedicated tables
-- ============================================================
-- PENTING SEBELUM JALANKAN:
--   1. Pastikan TOKO_UUID di baris 358 sudah UUID toko yang benar.
--      UUID ini sudah diisi saat file ini disimpan.
--   2. Pastikan tabel tujuan sudah dibuat (jalankan bagian 1-14 dulu).
--   3. User/profiles TIDAK bisa dimigrasi langsung karena terikat
--      ke auth.users. Gunakan import manual jika diperlukan.
-- ============================================================

-- Helper function untuk parse date dari berbagai format
CREATE OR REPLACE FUNCTION _parse_date(val TEXT)
RETURNS TIMESTAMPTZ LANGUAGE plpgsql IMMUTABLE AS $$
BEGIN
  IF val IS NULL THEN RETURN NULL; END IF;
  -- ISO8601
  BEGIN RETURN val::timestamptz; EXCEPTION WHEN OTHERS THEN END;
  -- Epoch milliseconds
  BEGIN RETURN to_timestamp(val::bigint / 1000.0); EXCEPTION WHEN OTHERS THEN END;
  RETURN NULL;
END;
$$;

DO $$
DECLARE
  rec          RECORD;
  inner_data   JSONB;
  tbl          TEXT;
  new_id       UUID;
  TOKO_UUID    UUID := 'a0ddbba2-e188-456d-a56c-0c32cef076a7'; -- UUID toko
  fk_produk    UUID;
  fk_transaksi UUID;
  fk_supplier  UUID;
  fk_pembelian UUID;
  fk_po        UUID; -- pending_order
  fk_pp        UUID; -- pending_pembelian
  total        INT := 0;
  skipped      INT := 0;
BEGIN

  -- Cek apakah toko UUID valid
  IF TOKO_UUID IS NULL OR TOKO_UUID = '00000000-0000-0000-0000-000000000000' THEN
    RAISE EXCEPTION 'ERROR: TOKO_UUID tidak valid. Periksa baris 358.';
  END IF;

  -- Cek apakah tabel records ada dan punya data
  IF NOT EXISTS (SELECT 1 FROM information_schema.tables WHERE table_name = 'records') THEN
    RAISE NOTICE 'Tabel records tidak ditemukan. Tidak ada data untuk dimigrasi.';
    RETURN;
  END IF;

  RAISE NOTICE 'Memulai migrasi data dari records...';

  FOR rec IN SELECT * FROM records LOOP
    -- Decode inner JSON string → JSONB object
    BEGIN
      inner_data := (rec.data #>> '{}')::jsonb;
    EXCEPTION WHEN OTHERS THEN
      RAISE WARNING 'SKIP record % — data JSON tidak valid: %', rec.uuid, SQLERRM;
      skipped := skipped + 1;
      CONTINUE;
    END;

    -- Skip deleted records
    IF (inner_data ->> '_deleted')::boolean = TRUE THEN
      skipped := skipped + 1;
      CONTINUE;
    END IF;

    tbl     := inner_data ->> '_table';
    new_id  := COALESCE((inner_data ->> '_uuid')::uuid, gen_random_uuid());

    -- Resolve FKs dari metadata _<field>_uuid
    fk_produk    := (inner_data ->> '_produkId_uuid')::uuid;
    fk_transaksi := (inner_data ->> '_transaksiId_uuid')::uuid;
    fk_supplier  := (inner_data ->> '_supplierId_uuid')::uuid;
    fk_pembelian := (inner_data ->> '_pembelianId_uuid')::uuid;
    fk_po        := (inner_data ->> '_pendingOrderId_uuid')::uuid;
    fk_pp        := (inner_data ->> '_pendingPembelianId_uuid')::uuid;

    CASE tbl
      WHEN 'produk' THEN
        BEGIN
          INSERT INTO produk (id, toko_id, nama, barcode, harga_beli, harga_jual, stok, kategori, satuan, created_at)
          VALUES (
            new_id, TOKO_UUID,
            COALESCE(inner_data ->> 'nama', ''),
            inner_data ->> 'barcode',
            COALESCE((inner_data ->> 'hargaBeli')::numeric, 0),
            COALESCE((inner_data ->> 'hargaJual')::numeric, 0),
            COALESCE((inner_data ->> 'stok')::integer, 0),
            inner_data ->> 'kategori',
            COALESCE(inner_data ->> 'satuan', 'pcs'),
            COALESCE(_parse_date(inner_data ->> 'createdAt'), rec.created_at)
          )
          ON CONFLICT (id) DO NOTHING;
          total := total + 1;
        EXCEPTION WHEN OTHERS THEN
          RAISE WARNING 'SKIP produk % — %', new_id, SQLERRM;
          skipped := skipped + 1;
        END;

      WHEN 'satuan_produk' THEN
        BEGIN
          INSERT INTO satuan_produk (id, toko_id, produk_id, nama, konversi, harga_beli, harga_jual)
          VALUES (
            new_id, TOKO_UUID,
            fk_produk,
            inner_data ->> 'nama',
            COALESCE((inner_data ->> 'konversi')::numeric, 1),
            COALESCE((inner_data ->> 'hargaBeli')::numeric, 0),
            COALESCE((inner_data ->> 'hargaJual')::numeric, 0)
          )
          ON CONFLICT (id) DO NOTHING;
          total := total + 1;
        EXCEPTION WHEN OTHERS THEN
          RAISE WARNING 'SKIP satuan_produk % — %', new_id, SQLERRM;
          skipped := skipped + 1;
        END;

      WHEN 'supplier' THEN
        BEGIN
          INSERT INTO supplier (id, toko_id, nama, telepon, alamat, created_at)
          VALUES (
            new_id, TOKO_UUID,
            COALESCE(inner_data ->> 'nama', ''),
            inner_data ->> 'telepon',
            inner_data ->> 'alamat',
            COALESCE(_parse_date(inner_data ->> 'createdAt'), rec.created_at)
          )
          ON CONFLICT (id) DO NOTHING;
          total := total + 1;
        EXCEPTION WHEN OTHERS THEN
          RAISE WARNING 'SKIP supplier % — %', new_id, SQLERRM;
          skipped := skipped + 1;
        END;

      WHEN 'transaksi' THEN
        BEGIN
          INSERT INTO transaksi (id, toko_id, total_harga, jumlah_bayar, kembalian, status, created_at)
          VALUES (
            new_id, TOKO_UUID,
            COALESCE((inner_data ->> 'totalHarga')::numeric, 0),
            COALESCE((inner_data ->> 'jumlahBayar')::numeric, 0),
            COALESCE((inner_data ->> 'kembalian')::numeric, 0),
            COALESCE(inner_data ->> 'status', 'lunas'),
            COALESCE(_parse_date(inner_data ->> 'createdAt'), rec.created_at)
          )
          ON CONFLICT (id) DO NOTHING;
          total := total + 1;
        EXCEPTION WHEN OTHERS THEN
          RAISE WARNING 'SKIP transaksi % — %', new_id, SQLERRM;
          skipped := skipped + 1;
        END;

      WHEN 'item_transaksi' THEN
        BEGIN
          INSERT INTO item_transaksi (id, toko_id, transaksi_id, produk_id, jumlah, harga_satuan, subtotal)
          VALUES (
            new_id, TOKO_UUID,
            fk_transaksi, fk_produk,
            COALESCE((inner_data ->> 'jumlah')::integer, 1),
            COALESCE((inner_data ->> 'hargaSatuan')::numeric, 0),
            COALESCE((inner_data ->> 'subtotal')::numeric, 0)
          )
          ON CONFLICT (id) DO NOTHING;
          total := total + 1;
        EXCEPTION WHEN OTHERS THEN
          RAISE WARNING 'SKIP item_transaksi % — %', new_id, SQLERRM;
          skipped := skipped + 1;
        END;

      WHEN 'hutang_piutang' THEN
        BEGIN
          INSERT INTO hutang_piutang (id, toko_id, transaksi_id, nama_pelanggan, jumlah, status, tanggal_jatuh_tempo, created_at)
          VALUES (
            new_id, TOKO_UUID,
            fk_transaksi,
            COALESCE(inner_data ->> 'namaPelanggan', ''),
            COALESCE((inner_data ->> 'jumlah')::numeric, 0),
            COALESCE(inner_data ->> 'status', 'belum_lunas'),
            _parse_date(inner_data ->> 'tanggalJatuhTempo'),
            COALESCE(_parse_date(inner_data ->> 'createdAt'), rec.created_at)
          )
          ON CONFLICT (id) DO NOTHING;
          total := total + 1;
        EXCEPTION WHEN OTHERS THEN
          RAISE WARNING 'SKIP hutang_piutang % — %', new_id, SQLERRM;
          skipped := skipped + 1;
        END;

      WHEN 'riwayat_stok' THEN
        BEGIN
          INSERT INTO riwayat_stok (id, toko_id, produk_id, tipe, jumlah, keterangan, created_at)
          VALUES (
            new_id, TOKO_UUID,
            fk_produk,
            COALESCE(inner_data ->> 'tipe', ''),
            COALESCE((inner_data ->> 'jumlah')::integer, 0),
            inner_data ->> 'keterangan',
            COALESCE(_parse_date(inner_data ->> 'createdAt'), rec.created_at)
          )
          ON CONFLICT (id) DO NOTHING;
          total := total + 1;
        EXCEPTION WHEN OTHERS THEN
          RAISE WARNING 'SKIP riwayat_stok % — %', new_id, SQLERRM;
          skipped := skipped + 1;
        END;

      WHEN 'pembelian' THEN
        BEGIN
          INSERT INTO pembelian (id, toko_id, supplier_id, nama_supplier, total_harga, created_at)
          VALUES (
            new_id, TOKO_UUID,
            fk_supplier,
            inner_data ->> 'namaSupplier',
            COALESCE((inner_data ->> 'totalHarga')::numeric, 0),
            COALESCE(_parse_date(inner_data ->> 'createdAt'), rec.created_at)
          )
          ON CONFLICT (id) DO NOTHING;
          total := total + 1;
        EXCEPTION WHEN OTHERS THEN
          RAISE WARNING 'SKIP pembelian % — %', new_id, SQLERRM;
          skipped := skipped + 1;
        END;

      WHEN 'item_pembelian' THEN
        BEGIN
          INSERT INTO item_pembelian (id, toko_id, pembelian_id, produk_id, jumlah, harga_beli_satuan, subtotal)
          VALUES (
            new_id, TOKO_UUID,
            fk_pembelian,
            fk_produk,
            COALESCE((inner_data ->> 'jumlah')::integer, 1),
            COALESCE((inner_data ->> 'hargaBeliSatuan')::numeric, 0),
            COALESCE((inner_data ->> 'subtotal')::numeric, 0)
          )
          ON CONFLICT (id) DO NOTHING;
          total := total + 1;
        EXCEPTION WHEN OTHERS THEN
          RAISE WARNING 'SKIP item_pembelian % — %', new_id, SQLERRM;
          skipped := skipped + 1;
        END;

      WHEN 'pending_order' THEN
        BEGIN
          INSERT INTO pending_order (id, toko_id, nama_pelanggan, catatan, created_at)
          VALUES (
            new_id, TOKO_UUID,
            COALESCE(inner_data ->> 'namaPelanggan', ''),
            inner_data ->> 'catatan',
            COALESCE(_parse_date(inner_data ->> 'createdAt'), rec.created_at)
          )
          ON CONFLICT (id) DO NOTHING;
          total := total + 1;
        EXCEPTION WHEN OTHERS THEN
          RAISE WARNING 'SKIP pending_order % — %', new_id, SQLERRM;
          skipped := skipped + 1;
        END;

      WHEN 'pending_order_item' THEN
        BEGIN
          INSERT INTO pending_order_item (id, toko_id, pending_order_id, produk_id, nama_produk, harga_jual, jumlah, diskon_tipe, diskon_value, subtotal)
          VALUES (
            new_id, TOKO_UUID,
            fk_po,
            fk_produk,
            COALESCE(inner_data ->> 'namaProduk', ''),
            COALESCE((inner_data ->> 'hargaJual')::numeric, 0),
            COALESCE((inner_data ->> 'jumlah')::integer, 1),
            COALESCE((inner_data ->> 'diskonTipe')::integer, 0),
            COALESCE((inner_data ->> 'diskonValue')::numeric, 0),
            COALESCE((inner_data ->> 'subtotal')::numeric, 0)
          )
          ON CONFLICT (id) DO NOTHING;
          total := total + 1;
        EXCEPTION WHEN OTHERS THEN
          RAISE WARNING 'SKIP pending_order_item % — %', new_id, SQLERRM;
          skipped := skipped + 1;
        END;

      WHEN 'pending_pembelian' THEN
        BEGIN
          INSERT INTO pending_pembelian (id, toko_id, supplier_id, nama_supplier, is_ppn_enabled, ppn_percent, created_at)
          VALUES (
            new_id, TOKO_UUID,
            fk_supplier,
            inner_data ->> 'namaSupplier',
            COALESCE((inner_data ->> 'isPpnEnabled')::boolean, FALSE),
            COALESCE((inner_data ->> 'ppnPercent')::numeric, 11.0),
            COALESCE(_parse_date(inner_data ->> 'createdAt'), rec.created_at)
          )
          ON CONFLICT (id) DO NOTHING;
          total := total + 1;
        EXCEPTION WHEN OTHERS THEN
          RAISE WARNING 'SKIP pending_pembelian % — %', new_id, SQLERRM;
          skipped := skipped + 1;
        END;

      WHEN 'pending_pembelian_item' THEN
        BEGIN
          INSERT INTO pending_pembelian_item (id, toko_id, pending_pembelian_id, produk_id, nama_produk, jumlah, harga_beli_satuan, harga_beli_lama, diskon_tipe, diskon_value)
          VALUES (
            new_id, TOKO_UUID,
            fk_pp,
            fk_produk,
            COALESCE(inner_data ->> 'namaProduk', ''),
            COALESCE((inner_data ->> 'jumlah')::integer, 1),
            COALESCE((inner_data ->> 'hargaBeliSatuan')::numeric, 0),
            COALESCE((inner_data ->> 'hargaBeliLama')::numeric, 0),
            COALESCE((inner_data ->> 'diskonTipe')::integer, 0),
            COALESCE((inner_data ->> 'diskonValue')::numeric, 0)
          )
          ON CONFLICT (id) DO NOTHING;
          total := total + 1;
        EXCEPTION WHEN OTHERS THEN
          RAISE WARNING 'SKIP pending_pembelian_item % — %', new_id, SQLERRM;
          skipped := skipped + 1;
        END;

      WHEN 'notifikasi' THEN
        BEGIN
          INSERT INTO notifikasi (id, toko_id, judul, pesan, tipe, is_read, created_at)
          VALUES (
            new_id, TOKO_UUID,
            COALESCE(inner_data ->> 'judul', ''),
            COALESCE(inner_data ->> 'pesan', ''),
            COALESCE(inner_data ->> 'tipe', 'INFO'),
            COALESCE((inner_data ->> 'isRead')::boolean, FALSE),
            COALESCE(_parse_date(inner_data ->> 'createdAt'), rec.created_at)
          )
          ON CONFLICT (id) DO NOTHING;
          total := total + 1;
        EXCEPTION WHEN OTHERS THEN
          RAISE WARNING 'SKIP notifikasi % — %', new_id, SQLERRM;
          skipped := skipped + 1;
        END;

      -- ============================================================
      -- USER/PROFILES — SKIP (terikat auth.users)
      -- ============================================================
      WHEN 'user' THEN
        RAISE NOTICE 'SKIP user record % — migrasi user harus manual via Supabase Auth', new_id;
        skipped := skipped + 1;

      ELSE
        RAISE WARNING 'SKIP record % — tabel tidak dikenal: %', rec.uuid, tbl;
        skipped := skipped + 1;
    END CASE;
  END LOOP;

  RAISE NOTICE '==========================================';
  RAISE NOTICE 'Migrasi selesai!';
  RAISE NOTICE '  Berhasil: % record(s)', total;
  RAISE NOTICE '  Dilewati: % record(s)', skipped;
  RAISE NOTICE '==========================================';

  -- ⚠️ Hapus tabel lama SETELAH data diverifikasi:
  -- DROP TABLE IF EXISTS records;
  -- DROP TABLE IF EXISTS stores;

END;
$$;

-- ============================================================
-- VERIFIKASI: Cek jumlah record yang termigrasi
-- ============================================================
-- Jalankan setelah migrasi untuk memverifikasi:
-- SELECT 'produk' AS tabel, COUNT(*) FROM produk WHERE toko_id = 'a0ddbba2-e188-456d-a56c-0c32cef076a7'
-- UNION ALL SELECT 'supplier', COUNT(*) FROM supplier WHERE toko_id = 'a0ddbba2-e188-456d-a56c-0c32cef076a7'
-- UNION ALL SELECT 'transaksi', COUNT(*) FROM transaksi WHERE toko_id = 'a0ddbba2-e188-456d-a56c-0c32cef076a7'
-- UNION ALL SELECT 'hutang_piutang', COUNT(*) FROM hutang_piutang WHERE toko_id = 'a0ddbba2-e188-456d-a56c-0c32cef076a7'
-- UNION ALL SELECT 'pembelian', COUNT(*) FROM pembelian WHERE toko_id = 'a0ddbba2-e188-456d-a56c-0c32cef076a7'
-- UNION ALL SELECT 'notifikasi', COUNT(*) FROM notifikasi WHERE toko_id = 'a0ddbba2-e188-456d-a56c-0c32cef076a7'
-- UNION ALL SELECT 'riwayat_stok', COUNT(*) FROM riwayat_stok WHERE toko_id = 'a0ddbba2-e188-456d-a56c-0c32cef076a7'
-- UNION ALL SELECT 'pending_order', COUNT(*) FROM pending_order WHERE toko_id = 'a0ddbba2-e188-456d-a56c-0c32cef076a7'
-- UNION ALL SELECT 'pending_pembelian', COUNT(*) FROM pending_pembelian WHERE toko_id = 'a0ddbba2-e188-456d-a56c-0c32cef076a7'
-- ORDER BY tabel;

-- ============================================================
-- MIGRATION: Add satuan_id and konversi to pembelian items
-- ============================================================
ALTER TABLE item_pembelian ADD COLUMN IF NOT EXISTS satuan_id UUID REFERENCES satuan_produk(id) ON DELETE SET NULL;
ALTER TABLE item_pembelian ADD COLUMN IF NOT EXISTS konversi NUMERIC(15,4) NOT NULL DEFAULT 1;

ALTER TABLE pending_pembelian_item ADD COLUMN IF NOT EXISTS satuan_id UUID REFERENCES satuan_produk(id) ON DELETE SET NULL;
ALTER TABLE pending_pembelian_item ADD COLUMN IF NOT EXISTS konversi NUMERIC(15,4) NOT NULL DEFAULT 1;

-- ============================================================
-- MIGRATION: Add stok_minimum_global and stok_minimum
-- ============================================================
ALTER TABLE toko ADD COLUMN IF NOT EXISTS stok_minimum_global INTEGER NOT NULL DEFAULT 0;
ALTER TABLE produk ADD COLUMN IF NOT EXISTS stok_minimum INTEGER;

-- Reload PostgREST schema cache agar kolom baru langsung dikenali
NOTIFY pgrst, 'reload schema';

