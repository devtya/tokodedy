<div align="center">
  <img src="https://img.shields.io/badge/Flutter-3.11+-02569B?logo=flutter" alt="Flutter" />
  <img src="https://img.shields.io/badge/version-1.4.1%2B16-blue" alt="Version" />
  <img src="https://img.shields.io/badge/license-MIT-green" alt="License" />
</div>

# hend_kasir

**Aplikasi Kasir Toko Sembako** — Offline-first, multi-platform, dengan sinkronasi cloud Supabase.

## Fitur Utama

- 🛒 **Kasir** — Input barcode/scan, multi-satuan produk, diskon per-item & global, PPN
- 📦 **Manajemen Produk** — CRUD produk, multi-satuan dengan konversi otomatis, stok minimum per-item & global
- 📦 **Pembelian Barang** — Catat pembelian, harga pokok + PPN, diskon global, simpan sebagai pending
- 📄 **Nota Digital** — Preview & share nota via WhatsApp, cetak thermal printer (USB/Bluetooth)
- 💰 **Hutang Piutang** — Catat & kelola hutang pelanggan, status otomatis lunas
- 📊 **Laporan** — Riwayat transaksi lengkap dengan filter tanggal
- ☁️ **Sinkronasi Cloud** — Offline-first dengan Supabase, auto-sync tiap 5 menit, recovery cloud login
- 👥 **Multi-User** — Role-based (owner/admin/kasir), manajemen pengguna, undang kasir via email
- 🏪 **Multi-Toko** — Setiap toko memiliki data terisolasi
- 🎨 **Tema** — Light/Dark/System theme, persist ke SharedPreferences
- 🖨️ **Cetak Thermal** — Dukungan printer Network (HTTP) & Bluetooth (ESC/POS), ukuran font adjustable

## Arsitektur

- **Clean Architecture** — `data/domain/presentation` layers
- **State Management**: flutter_bloc + equatable
- **Database**: Drift (SQLite ORM) — offline-first
- **DI**: get_it
- **Cloud Sync**: Supabase (push/pull otomatis)

## Platform Support

| Platform | Status |
|----------|--------|
| Android | ✅ Aktif |
| Windows | ✅ Aktif (Developer Mode + Visual Studio required) |

## Cara Build

```bash
# Debug dengan Supabase sync
flutter run --dart-define=SUPABASE_URL=... --dart-define=SUPABASE_ANON_KEY=...

# Release APK
flutter build apk --release --dart-define=SUPABASE_URL=... --dart-define=SUPABASE_ANON_KEY=...

# Windows Desktop
flutter build windows --release --dart-define=SUPABASE_URL=... --dart-define=SUPABASE_ANON_KEY=...
```
