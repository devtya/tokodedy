# Panduan Pengembangan HendStore (Toko Online Terintegrasi HendKasir)

Dokumen ini berisi panduan dan struktur data bagi agent/developer yang akan mengembangkan **HendStore** (platform toko online untuk pembeli) agar dapat terhubung dan bersinkronisasi secara langsung dengan sistem Point of Sales **HendKasir**.

## 1. Konsep Utama
- **Satu Database Utama**: HendStore akan menggunakan project Supabase yang sama dengan HendKasir.
- **Role Pemisahan**: 
  - HendKasir sebagai Dashboard/Admin (Manajemen produk, stok, harga, dan proses pesanan online).
  - HendStore sebagai Etalase (Katalog produk, keranjang belanja, checkout, opsi pengiriman).
- **Metode Pembelian**: Pembeli dapat berbelanja dari rumah dan memilih metode penerimaan barang: 
  1. Diantar oleh kurir (`delivery`).
  2. Ambil sendiri di toko (`pickup`).

## 2. Tabel Supabase (Existing) yang Akan Dibaca oleh HendStore
HendStore hanya memiliki hak akses **BACA (READ/SELECT)** terhadap tabel-tabel berikut yang dikelola oleh HendKasir:

1. **`toko`**
   - Mendapatkan informasi toko (nama, alamat, telepon).
2. **`produk`**
   - Menampilkan katalog produk.
   - Kolom penting: `id`, `toko_id`, `nama`, `harga_jual`, `stok`, `kategori`, `satuan`.
   - *Catatan/Rencana Tambahan*: HendKasir perlu menambahkan fitur/kolom `image_url` pada tabel ini agar foto produk bisa ditampilkan di HendStore.
3. **`satuan_produk`**
   - Menampilkan opsi satuan lain (jika produk dijual dengan multi-satuan seperti dus, pack, dsb).

## 3. Tabel Supabase Baru yang Diperlukan (Untuk HendStore)
Untuk mengelola pesanan dari pembeli, diperlukan struktur tabel baru (atau penyesuaian pada tabel pending) di Supabase. Agent yang membangun HendStore perlu merancang dan menerapkan (migration) tabel-tabel ini:

1. **`online_customers`** (Opsional jika tidak menggunakan tabel `auth.users` secara langsung)
   - `id` (UUID, Primary Key, linked to `auth.users`)
   - `nama` (Text)
   - `nomor_telepon` (Text)
   - `alamat_lengkap` (Text)
   - `titik_koordinat` (Text/JSON - opsional untuk kurir)

2. **`online_orders`**
   - `id` (UUID, Primary Key)
   - `toko_id` (UUID, Foreign Key ke `toko`)
   - `customer_id` (UUID, Foreign Key ke `online_customers` / `auth.users`)
   - `metode_pengiriman` (Text: `kurir` atau `pickup`)
   - `alamat_pengiriman` (Text, null jika pickup)
   - `biaya_pengiriman` (Numeric, 0 jika pickup)
   - `total_harga` (Numeric)
   - `status_pesanan` (Text: `menunggu_konfirmasi`, `diproses`, `siap_diambil`, `sedang_dikirim`, `selesai`, `dibatalkan`)
   - `created_at` & `updated_at` (Timestamp)

3. **`online_order_items`**
   - `id` (UUID, Primary Key)
   - `online_order_id` (UUID, Foreign Key ke `online_orders`)
   - `produk_id` (UUID, Foreign Key ke `produk`)
   - `nama_produk` (Text, snapshot nama)
   - `harga_satuan` (Numeric, snapshot harga saat beli)
   - `jumlah` (Integer)
   - `subtotal` (Numeric)

## 4. Alur Sinkronisasi & Interaksi
1. **Pemesanan (HendStore)**: Pembeli login, memilih barang, memilih metode pengiriman (`kurir` / `pickup`), dan melakukan checkout. Sistem HendStore melakukan `INSERT` ke tabel `online_orders` dan `online_order_items`.
2. **Penerimaan Pesanan (HendKasir)**: HendKasir akan melakukan *listen* (Supabase Realtime) atau membaca data baru pada tabel `online_orders` dimana `status_pesanan` = `menunggu_konfirmasi`.
3. **Proses Kasir (HendKasir)**: Admin/Kasir di toko menyetujui pesanan, mengubah `status_pesanan` menjadi `diproses`. Stok produk akan dikurangi (via HendKasir).
4. **Penyelesaian (HendKasir)**: Setelah pesanan diserahkan ke kurir atau diambil pembeli, Kasir merubah status menjadi `selesai`.

## 5. Keamanan & RLS (Row Level Security)
- **Tabel Produk & Toko**: HendStore membutuhkan *Public Read Access* (Anon) untuk pengunjung yang belum login, atau akses baca untuk *Authenticated Users* (Pembeli).
- **Tabel Online Orders**: 
  - Pembeli (HendStore) hanya boleh melakukan `INSERT` dan `SELECT` untuk pesanan miliknya sendiri.
  - Kasir/Owner (HendKasir) dapat melakukan `SELECT` dan `UPDATE` untuk pesanan yang masuk ke toko miliknya.

## Panduan untuk Agents
Jika Anda agent yang ditugaskan membuat HendStore:
1. Baca file ini terlebih dahulu.
2. Setup koneksi Supabase Anda dengan URL dan Anon Key yang sama dengan HendKasir.
3. Buat UI Katalog berdasarkan tabel `produk`.
4. Buat alur Checkout yang mengarah pada pengisian data di tabel `online_orders` sesuai skema di atas.
