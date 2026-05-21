# AGENTS.md — hend_kasir

## Stack

- **Framework**: Flutter (Dart SDK ^3.11.5)
- **State Management**: flutter_bloc ^9.1 + equatable ^2.0
- **Database**: drift ^2.25 + sqlite3_flutter_libs (SQLite ORM)
- **DI**: get_it ^8.0
- **Barcode**: mobile_scanner ^6.0
- **Linting**: flutter_lints ^6.0

## Project structure (Clean Architecture)

```
lib/
  core/          theme, constants, DI (get_it), errors
  data/          database/ (Drift tables + AppDatabase), models/, repositories/
  domain/        entities/, repositories/ (abstract interfaces), usecases/
  presentation/  blocs/, pages/, widgets/
```

## Key commands

| Command | When |
|---------|------|
| `flutter analyze` | Lint + typecheck in one step. Run before committing. |
| `dart run build_runner build` | After modifying any Drift table or adding @DriftDatabase decorator. Generates `*.g.dart`. |
| `flutter run --dart-define=SUPABASE_URL=... --dart-define=SUPABASE_ANON_KEY=...` | Debug dengan Supabase sync aktif. |
| `flutter build apk --debug --dart-define=SUPABASE_URL=... --dart-define=SUPABASE_ANON_KEY=...` | **Default** — build debug APK dengan Supabase sync. |
| `flutter build apk --release --dart-define=SUPABASE_URL=... --dart-define=SUPABASE_ANON_KEY=...` | Build release APK (final). |
| `flutter build windows --debug --dart-define=SUPABASE_URL=... --dart-define=SUPABASE_ANON_KEY=...` | Build Windows desktop debug. Requires **Visual Studio** (Desktop C++ workload) + **Developer Mode** enabled. |
| `flutter build windows --release --dart-define=SUPABASE_URL=... --dart-define=SUPABASE_ANON_KEY=...` | Build Windows desktop release. |
| `flutter run -d windows --dart-define=SUPABASE_URL=... --dart-define=SUPABASE_ANON_KEY=...` | Run di Windows desktop. |
| `flutter test` | Run all tests. |

## Database (Drift)

- **16 tables**: 15 original + `SyncRecordTable` untuk UUID mapping sync
- Defined in `lib/data/database/tables/`, aggregated in `lib/data/database/app_database.dart`
- **Schema version 10**: v1→v6 original migrations, v6→v7 adds `SyncRecordTable`, v7→v8 adds `SupplierProductsTable`, v8→v9 adds `TokoTable` + `tokoId` columns, v9→v10 adds `isPpnEnabled` + `ppnPercent` to `pending_pembelian_table`
- Connection via `LazyDatabase` → `NativeDatabase` (file: `hend_kasir.db` in app docs dir)

## Supabase Sync

- **Offline-first**: Drift tetap primary, Supabase sebagai cloud sync
- **Auto-sync** via `SyncBloc` tiap 5 menit + saat app foreground
- `SyncRecordTable` di Drift mapping `(tableEntity, localId) ↔ uuid` untuk resolusi antar device
- `SupabaseSyncService.push()`: upload data yang berubah ke Supabase `records` table
- `SupabaseSyncService.pull()`: download data dari device lain, resolve FK via UUID
- **Auth tetap lokal** — tidak menggunakan Supabase Auth
- Konfigurasi Supabase via `--dart-define=SUPABASE_URL=... --dart-define=SUPABASE_ANON_KEY=...`
- File `supabase_setup.sql` untuk setup tabel di Supabase project
- Defined in `lib/data/database/tables/`, aggregated in `lib/data/database/app_database.dart`
- **Never override `primaryKey`** when using `autoIncrement()` — Drift handles it automatically
- Connection via `LazyDatabase` → `NativeDatabase` (file: `hend_kasir.db` in app docs dir)
- Schema version bump → update `schemaVersion` getter + add migration logic

## DI

- Central `sl` (GetIt instance) in `lib/core/di/injection.dart`
- `initDependencies()` called once at app startup in `main()` before `runApp`
- Register repos/usecases as `sl.registerLazySingleton<T>(() => ...)`
- Register BLoCs as `sl.registerFactory()` (new instance per page), repos/usecases as `sl.registerLazySingleton()`

## Conventions

- **Entities** extend `Equatable` with `copyWith()`
- **Repository interfaces** in `domain/repositories/`, implementations in `data/repositories/`
- **Theme**: System theme (`ThemeMode.system`) default, light & dark themes defined in `AppTheme` — `lib/core/theme/app_theme.dart`. Gunakan `ThemeCubit` untuk toggle (light/dark/system), persist ke `SharedPreferences`.
- **ProdukFormPage**: Multi-satuan dengan auto-konversi harga pokok. Saat harga pokok satuan konversi diisi, harga pokok satuan dasar otomatis dihitung ulang (`hargaPokok / konversi`).
- Drift generates data classes with same names as domain entities (e.g., `Produk`). Disambiguate in repo impl with import alias: `import '.../entities/produk.dart' as domain`
- **BLoCs** use `Bloc<Event, State>`, events defined in `*_event.dart`, states in `*_state.dart`
- Register BLoCs as `sl.registerFactory()` (new instance per page), repos/usecases as `sl.registerLazySingleton()`
- **ThemeCubit** registered as `registerLazySingleton` di `injection.dart`
- No git repo initialized yet — `git init` required if committing
- No `opencode.json` or other agent config files exist

## Pembelian Pages Layout Rules (LOCKED — DO NOT CHANGE)

### PembelianPage (`pembelian_page.dart`)
- **NO FloatingActionButton** — all actions must be in AppBar
- **AppBar actions** (right to left):
  1. Pending button (`Icons.pending_actions`) with red badge notification showing count of pending items
  2. Add button (`Icons.add`) to create new purchase
- Pending count loaded via `_loadPendingCount()` using `PendingPembelianRepository.getAllPending()`
- Badge shows count (or "9+" if > 9), hidden when count is 0

### PembelianFormPage (`pembelian_form_page.dart`)
- **AppBar actions**: Pending button (`Icons.pending_actions`) to view pending list
- **Bottom panel** (`_buildBottomPanel`): Contains subtotal, discount, PPN toggle+input, total final, and submit button
- **NO floating action buttons** — submit button is always at the bottom of the form

## ⛔ Status: Project Windows Discontinued

Project Windows **DISCONTINUE** sampai ada instruksi lanjut. Fokus development sekarang **hanya di Android**.

## Windows Platform

- **Barcode input**: `mobile_scanner` tidak support Windows. Gunakan `showBarcodeScannerDialog(context)` di `lib/presentation/widgets/barcode_scanner_widget.dart`. Di Windows nampilin `TextField` manual (kompatibel USB keyboard-wedge scanner), di Android pakai kamera `MobileScanner`.
- **Theme**: System theme otomatis aktif di Windows. Bisa diganti manual lewat Settings page.
- **Build prerequisites**: Visual Studio (Desktop C++ workload) + Windows Developer Mode (Settings → Privacy & Security → For Developers).

## Printing System (Thermal Printer)

- **Architecture**: HP → HTTP → PC Print Server (Python + FastAPI) → USB Thermal Printer, atau langsung via Bluetooth
- **PC Print Server**: `print_server.py` di root project. Run: `pip install fastapi uvicorn python-escpos pyusb && python print_server.py`
- **Flutter Services**: `PrinterService` abstraction → `NetworkPrinterService` (HTTP) + `BluetoothPrinterService` (BLE via `flutter_blue_plus`)
- **Settings**: `PrinterSettingsPage` accessible from Settings page. Configure printer type (Network/Bluetooth), URL, toko name, paper width (58mm/80mm), ukuran font (kecil/normal/besar)
- **Auto-print**: After cashier transaction success, receipt auto-prints if printer is enabled in settings
- **Dynamic DI**: `PrinterService` diregistrasi ulang via `updatePrinterService()` saat tipe printer berubah. `ReceiptGenerator` baca `fontSize` dari `PrinterSettings`.
- **ESC-POS**: Both network and Bluetooth services generate raw ESC-POS commands; ukuran font dikontrol via ESC/POS print mode byte

## Log Konvensi

> **Setiap bug fix dan penambahan fitur WAJIB dicatat di bagian log di bawah ini** (format konsisten) agar menjadi referensi untuk development selanjutnya. Format:
> - Bug: `### Bug: <nama> — <deskripsi singkat>` dengan root cause, fix, files, date
> - Fitur: `### Fitur: <nama>` dengan deskripsi, cara pakai, files, date

## Bug Fixes Log

### Bug: User Management — Admin dari toko lain terlihat
- **Root cause**: `getAllUsers()` di `AuthRepositoryImpl` tidak filter by `tokoId`. `addUser()` hardcoded `tokoId: 1`.
- **Fix**: `getAllUsers()` sekarang filter by `_tokoService.tokoId`. `addUser()` pakai `tokoId` dari `TokoService`.
- **Files**: `lib/domain/entities/user.dart` (tambah field `tokoId`), `lib/data/repositories/auth_repository_impl.dart`
- **Date**: 2026-05-20

### Bug: Pembelian — Total berubah saat save karena rounding
- **Root cause**: Harga satuan dibulatkan via `toStringAsFixed(0)` saat user input total, lalu subtotal dihitung ulang dari harga × qty.
- **Fix**: Tambah field `totalHarga` di `_ItemPembelian` sebagai source of truth. `subtotal` getter return `totalHarga` langsung. Dialog edit simpan total dari user input.
- **Files**: `pembelian_form_page.dart`, `pembelian_event.dart`, `pembelian_bloc.dart`, `buat_transaksi.dart`
- **Date**: 2026-05-20

### Bug: Pembelian — Simpan ke Pending tidak berfungsi (tidak ada aksi + kembali ke form)
- **Root cause**: `_submit()` dan `_onWillPop()` di `pembelian_form_page.dart` tidak punya try-catch untuk path kasir (simpan pending). Jika `addPending()`, `addItem()`, atau `addNotifikasi()` throw exception, error tidak tertangkap dan halaman langsung pop tanpa feedback. Selain itu `_selectedSupplier!.nama` (force unwrap) bisa crash jika supplier null.
- **Fix**: Wrap seluruh block kasir (simpan pending) di `_submit()` dan `_onWillPop()` dengan try-catch. Ganti `_selectedSupplier!.nama` jadi `_selectedSupplier?.nama ?? "Supplier tidak diketahui"`. Tampilkan SnackBar error jika gagal. `_onWillPop()` return `false` (pop dibatalkan) jika gagal.
- **Files**: `lib/presentation/pages/pembelian_form_page.dart`
- **Date**: 2026-05-20

### Bug: Cashier — Nominal bayar kosong atau kurang menyebabkan halaman stuck (spinner)
- **Root cause**: (1) `CashierError` state tidak di-handle di builder → menampilkan spinner terus-menerus. (2) Tidak ada transisi `CashierError` → `CashierReady` di bloc. (3) Tidak ada validasi di UI sebelum dispatch `BayarCashier`.
- **Fix**: (1) `CashierError` sekarang menyimpan `cart` dan `jumlahBayar` dari state sebelumnya. (2) Builder handle `CashierError` dengan `_resolveCashierData()` yang mengkonversi ke `CashierReady` untuk render UI cart tetap terlihat. (3) Tambah event `ClearError` untuk recovery. (4) Tombol Bayar sekarang validasi `jumlahBayar <= 0` dan `jumlahBayar < total` sebelum dispatch, dengan SnackBar error.
- **Files**: `lib/presentation/blocs/cashier/cashier_bloc.dart`, `lib/presentation/blocs/cashier/cashier_state.dart`, `lib/presentation/blocs/cashier/cashier_event.dart`, `lib/presentation/pages/cashier_page.dart`
- **Date**: 2026-05-20

### Bug: Database — pending_pembelian_table tidak punya kolom is_ppn_enabled / ppn_percent
- **Root cause**: Schema version di kode sudah 10 (tercatat di AGENTS.md) tapi migration v9→v10 untuk menambah `isPpnEnabled` + `ppnPercent` ke `pending_pembelian_table` belum diimplementasikan di `app_database.dart`. Akibatnya INSERT ke tabel pending gagal dengan `SqliteException: table has no column named is_ppn_enabled`.
- **Fix**: Implementasi migration `from < 10` di `onUpgrade` dengan `m.addColumn(pendingPembelianTable, pendingPembelianTable.isPpnEnabled)` dan `m.addColumn(pendingPembelianTable, pendingPembelianTable.ppnPercent)`, serta bump `schemaVersion` dari 9 ke 10.
- **Files**: `lib/data/database/app_database.dart`
- **Date**: 2026-05-20

### Bug: Hutang — List item tidak bisa diklik untuk lihat item transaksi
- **Root cause**: `ListTile` di `hutang_page.dart` tidak punya `onTap` handler.
- **Fix**: Tambah `onTap` pada ListTile yang navigasi ke `TransaksiDetailPage` jika `h.transaksiId != null`. Import `TransaksiBloc` dari DI untuk provider.
- **Files**: `lib/presentation/pages/hutang_page.dart`
- **Date**: 2026-05-20

### Bug: Hutang — Status transaksi tidak berubah jadi 'lunas' saat hutang ditandai lunas
- **Root cause**: `HutangPiutangRepositoryImpl.updateStatus()` hanya update `hutang_piutang.status` tanpa mengupdate `transaksi.status` terkait yang masih `'hutang'`.
- **Fix**: Di `updateStatus()`, setelah update hutang, cari `transaksiId` dari record hutang. Jika ada dan status baru `'lunas'`, update juga `transaksiTable.status` jadi `'lunas'`.
- **Files**: `lib/data/repositories/hutang_piutang_repository_impl.dart`
- **Date**: 2026-05-20

## Features Log

### Fitur: Printer Bluetooth — Selektor tipe printer di Settings
- **Deskripsi**: `BluetoothPrinterService` sudah ada dan lengkap (scan, connect, disconnect, testPrint, printReceipt via ESC/POS) tapi sebelumnya tidak bisa dipilih di UI. Sekarang ada radio button Network/Bluetooth di `PrinterSettingsPage`.
- **Cara pakai**: Buka Settings → Pengaturan Printer → pilih "Bluetooth" → tap "Cari Printer Bluetooth" → pilih printer dari daftar → "Hubungkan". Status koneksi ditampilkan.
- **Files**: `lib/presentation/pages/printer_settings_page.dart`, `lib/core/di/injection.dart` (tambah `updatePrinterService()`)
- **Date**: 2026-05-20

### Fitur: Ukuran Font Print — Kecil / Normal / Besar
- **Deskripsi**: Tambah setting `fontSize` di `PrinterSettings` yang mempengaruhi output ESC/POS. Untuk Bluetooth, mode byte `0x1B, 0x21` dikontrol (condensed/normal/double). Untuk Network, field `font_size` dikirim via JSON ke `print_server.py` yang menggunakan `python-escpos` `set(condensed=...)`.
- **Cara pakai**: Buka Settings → Pengaturan Printer → pilih ukuran font (Kecil/Normal/Besar) → Simpan. Mempengaruhi print nota setelah transaksi.
- **Files**: `lib/data/services/printer_settings.dart`, `lib/data/models/receipt_data.dart`, `lib/data/services/receipt_generator.dart`, `lib/data/services/bluetooth_printer_service.dart`, `print_server.py`, `lib/presentation/pages/printer_settings_page.dart`
- **Date**: 2026-05-20

### Bug: Bluetooth — Permission Error saat Scan Printer
- **Root cause**: Android 12+ membutuhkan `BLUETOOTH_SCAN` + `BLUETOOTH_CONNECT` runtime permissions, tapi hanya dideklarasikan di manifest tanpa request runtime. Juga tidak ada permission untuk Android <12 (`ACCESS_FINE_LOCATION`).
- **Fix**: (1) Tambah semua permission Bluetooth di `AndroidManifest.xml` (API 31+ dan fallback). (2) Tambah `_requestBluetoothPermissions()` di `printer_settings_page.dart` yang request `bluetoothScan`+`bluetoothConnect` (API 31+) atau `location` (<31) sebelum `startScan`. (3) Jika ditolak, tampilkan pesan error user-friendly, bukan throw exception.
- **Files**: `android/app/src/main/AndroidManifest.xml`, `lib/presentation/pages/printer_settings_page.dart`, `pubspec.yaml` (tambah `device_info_plus`)
- **Date**: 2026-05-20

### Bug: UI — Label Radio Button Terpotong Vertikal di Printer Settings
- **Root cause**: Layout radio button "Tipe Printer" dan "Ukuran Font" pakai `Row` dengan `Expanded` + `RadioListTile`, sehingga teks subtitle yang panjang terpotong vertikal.
- **Fix**: Ganti layout dari `Row` ke `Column` dengan `RadioListTile` penuh (atas-bawah) untuk kedua section. Lebar penuh sehingga teks tidak terpotong.
- **Files**: `lib/presentation/pages/printer_settings_page.dart`
- **Date**: 2026-05-20

### Fitur: Konfirmasi Bayar + Cetak Dialog di Kasir
- **Deskripsi**: Sebelum proses bayar, muncul dialog konfirmasi yang menampilkan total, jumlah dibayar, dan kembalian. Setelah transaksi sukses, muncul dialog pilihan "Cetak Nota" atau "Tidak" — menggantikan auto-print sebelumnya.
- **Cara pakai**: Tap "Bayar" → dialog konfirmasi (Total, Dibayar, Kembali) → "Bayar" → transaksi sukses → dialog "Cetak Nota?" → Ya/Tidak.
- **Files**: `lib/presentation/pages/cashier_page.dart`
- **Date**: 2026-05-20

### Fitur: Auth — Email sebagai login utama, username auto-generate
- **Deskripsi**: Ubah flow registrasi: `username` dihapus dari form, diganti `email` sebagai login utama. Username auto-generate dari `email.split('@')[0]` + random suffix jika sudah terpakai. Login tetap dual-mode (username lama masih bisa dipakai). User tanpa email akan mendapat dialog prompt "Lengkapi Email" di home page. Schema v12→v13 untuk drop UNIQUE index username + nullable.
- **Cara pakai**: Registrasi → input email (required). User lama login via username seperti biasa. Home page tampilkan dialog isi email jika belum punya.
- **Files**: `user_table.dart`, `app_database.dart` (v13), `auth_repository.dart`, `auth_repository_impl.dart`, `auth_event.dart`, `auth_bloc.dart`, `register_store_page.dart`, `user_management_page.dart`, `home_page_desktop.dart`, `home_page_mobile.dart`
- **Date**: 2026-05-21

### Bug: Auth — Logout tidak navigasi ke LoginPage + Nama di AppBar tidak real-time
- **Root cause**: (1) Home page tidak punya listener untuk `Unauthenticated` state — hanya `BlocBuilder` tanpa `BlocListener`, jadi saat logout emit `Unauthenticated`, halaman tetap menampilkan UI kosong. (2) `AuthRepositoryImpl.updateUser()` hanya update DB, tidak update session di `SharedPreferences`, jadi nama baru tidak terbaca sampai login ulang.
- **Fix**: (1) Tambah `BlocListener<AuthBloc, AuthState>` di `HomeDesktopPage` dan `HomeMobileView` yang navigasi ke `LoginPage` via `pushAndRemoveUntil` saat `Unauthenticated` state. (2) Update session JSON di `updateUser()` jika user ID cocok dengan session. (3) Dispatch `CheckAuthStatus` dari `UserManagementPage` setelah save agar AppBar langsung update.
- **Files**: `home_page_desktop.dart`, `home_page_mobile.dart`, `auth_repository_impl.dart`, `user_management_page.dart`
- **Date**: 2026-05-20

### Bug: Bluetooth — Printer terpasang di sistem tidak terdeteksi aplikasi
- **Root cause**: (1) `scanPrinters()` memfilter nama dengan keyword 'printer'/'pos'/'thermal' — banyak printer (XP-58III, MTP-3, dll) tidak termasuk. (2) `flutter_blue_plus` hanya scan BLE, printer Classic Bluetooth (SPP) tidak pernah muncul.
- **Fix**: (1) Hapus filter nama di `scanPrinters()` — tampilkan semua device BLE. (2) Tambah `getBondedDevices()` via MethodChannel ke `BluetoothAdapter.getBondedDevices()` untuk ambil semua device terpasang (Classic + BLE). (3) Settings page gabung hasil BLE scan + bonded devices dengan label "Printer BLE ditemukan" dan "Terpasang di sistem".
- **Files**: `lib/data/services/bluetooth_printer_service.dart`, `lib/presentation/pages/printer_settings_page.dart`, `android/.../MainActivity.kt`
- **Date**: 2026-05-20

### Bug: Cashier — Gagal cetak nota setelah koneksi Bluetooth
- **Root cause**: `updatePrinterService()` hanya dipanggil saat "Simpan Pengaturan" di settings, bukan saat koneksi Bluetooth berhasil. Akibatnya DI masih menyimpan `NetworkPrinterService`, sementara printer yang terhubung adalah Bluetooth.
- **Fix**: Tambah `updatePrinterService()` + `_settings.enabled = true` di `_connectBluetooth()` dan `_connectBondedDevice()` setiap kali koneksi berhasil, bukan hanya saat simpan settings.
- **Files**: `lib/presentation/pages/printer_settings_page.dart`
- **Date**: 2026-05-20

### Fitur: Cetak Nota Pembelian
- **Deskripsi**: Tambah tombol "Cetak" di bottom sheet detail pembelian. Format nota: nama toko, info supplier, daftar item (nama, jumlah, harga), dan total. Gunakan `PrinterService` + `ReceiptData` yang sudah ada.
- **Cara pakai**: Buka Pembelian Barang → tap item → detail bottom sheet → "Cetak" → cetak ke printer yang sudah dikonfigurasi.
- **Files**: `lib/presentation/pages/pembelian_page.dart`
- **Date**: 2026-05-20

### Fitur: Sinkronisasi Multi-Toko Supabase & Pemulihan Cloud
- **Deskripsi**: Penyelarasan tokoId secara dinamis di level SQLite (Drift), sinkronisasi (Supabase), dan layer Dependency Injection (GetIt). Serta sistem login pemulihan cloud (*cloud recovery login*) otomatis untuk mengunduh seluruh data toko pasca install ulang aplikasi.
- **Cara pakai**: (1) Daftarkan toko baru, seluruh data login dan barang otomatis sinkron ke Supabase remote di bawah `toko_id` milik toko tersebut. (2) Di perangkat baru/setelah install ulang, login dengan kredensial toko baru tersebut. Kredensial & info toko akan ditarik dari Supabase, database Drift di-seeding secara otomatis, dan dipicu initial sync untuk mengunduh seluruh data toko.
- **Files**: `lib/data/services/sync_helper.dart`, `lib/data/services/supabase_sync_service.dart`, `lib/core/di/injection.dart`, `lib/data/repositories/auth_repository_impl.dart`
- **Date**: 2026-05-21
