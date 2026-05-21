-- ============================================================
-- Migrasi Data: records (JSONB) → Dedicated Tables
-- Jalankan di: Supabase Dashboard → SQL Editor → New Query
-- ============================================================
-- Prasyarat: 15 tabel sudah dibuat (toko, profiles, produk, ...)
-- UUID toko: a0ddbba2-e188-456d-a56c-0c32cef076a7
-- ============================================================

-- Helper function untuk parse date dari berbagai format
CREATE OR REPLACE FUNCTION _parse_date(val TEXT)
RETURNS TIMESTAMPTZ LANGUAGE plpgsql IMMUTABLE AS $$
BEGIN
  IF val IS NULL THEN RETURN NULL; END IF;
  BEGIN RETURN val::timestamptz; EXCEPTION WHEN OTHERS THEN END;
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
  TOKO_UUID    UUID := 'a0ddbba2-e188-456d-a56c-0c32cef076a7';
  fk_produk    UUID;
  fk_transaksi UUID;
  fk_supplier  UUID;
  fk_pembelian UUID;
  fk_po        UUID;
  fk_pp        UUID;
  total        INT := 0;
  skipped      INT := 0;
BEGIN

  -- Cek apakah tabel records ada dan punya data
  IF NOT EXISTS (SELECT 1 FROM information_schema.tables WHERE table_name = 'records') THEN
    RAISE NOTICE 'Tabel records tidak ditemukan. Tidak ada data untuk dimigrasi.';
    RETURN;
  END IF;

  RAISE NOTICE 'Memulai migrasi data dari records...';

  FOR rec IN SELECT * FROM records LOOP
    BEGIN
      inner_data := (rec.data #>> '{}')::jsonb;
    EXCEPTION WHEN OTHERS THEN
      RAISE WARNING 'SKIP record % — data JSON tidak valid: %', rec.uuid, SQLERRM;
      skipped := skipped + 1;
      CONTINUE;
    END;

    IF (inner_data ->> '_deleted')::boolean = TRUE THEN
      skipped := skipped + 1;
      CONTINUE;
    END IF;

    tbl     := inner_data ->> '_table';
    new_id  := COALESCE((inner_data ->> '_uuid')::uuid, gen_random_uuid());

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

  -- ⚠️  Setelah data diverifikasi, hapus tabel lama:
  -- DROP TABLE IF EXISTS records;
  -- DROP TABLE IF EXISTS stores;

END;
$$;

-- ============================================================
-- VERIFIKASI (jalankan query ini secara terpisah)
-- ============================================================
-- SELECT 'produk' AS tabel, COUNT(*) FROM produk WHERE toko_id = 'a0ddbba2-e188-456d-a56c-0c32cef076a7'
-- UNION ALL SELECT 'supplier', COUNT(*) FROM supplier WHERE toko_id = 'a0ddbba2-e188-456d-a56c-0c32cef076a7'
-- UNION ALL SELECT 'transaksi', COUNT(*) FROM transaksi WHERE toko_id = 'a0ddbba2-e188-456d-a56c-0c32cef076a7'
-- UNION ALL SELECT 'hutang_piutang', COUNT(*) FROM hutang_piutang WHERE toko_id = 'a0ddbba2-e188-456d-a56c-0c32cef076a7'
-- UNION ALL SELECT 'pembelian', COUNT(*) FROM pembelian WHERE toko_id = 'a0ddbba2-e188-456d-a56c-0c32cef076a7'
-- UNION ALL SELECT 'notifikasi', COUNT(*) FROM notifikasi WHERE toko_id = 'a0ddbba2-e188-456d-a56c-0c32cef076a7'
-- UNION ALL SELECT 'riwayat_stok', COUNT(*) FROM riwayat_stok WHERE toko_id = 'a0ddbba2-e188-456d-a56c-0c32cef076a7'
-- UNION ALL SELECT 'pending_order', COUNT(*) FROM pending_order WHERE toko_id = 'a0ddbba2-e188-456d-a56c-0c32cef076a7'
-- UNION ALL SELECT 'pending_pembelian', COUNT(*) FROM pending_pembelian WHERE toko_id = 'a0ddbba2-e188-456d-a56c-0c32cef076a7'
-- UNION ALL SELECT 'supplier_products', COUNT(*) FROM supplier_products WHERE toko_id = 'a0ddbba2-e188-456d-a56c-0c32cef076a7'
-- ORDER BY tabel;
