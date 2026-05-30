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

> **Pages**: All page files are under `lib/presentation/pages/`. Desktop Windows platform has been removed — this project now targets Android only.

## Key commands

| Command | When |
|---------|------|
| `flutter analyze` | Lint + typecheck in one step. Run before committing. |
| `dart run build_runner build` | After modifying any Drift table or adding @DriftDatabase decorator. Generates `*.g.dart`. |
| `flutter run --dart-define=SUPABASE_URL=... --dart-define=SUPABASE_ANON_KEY=...` | Debug dengan Supabase sync aktif. |
| `flutter build apk --debug --dart-define=SUPABASE_URL=... --dart-define=SUPABASE_ANON_KEY=...` | **Default** — build debug APK dengan Supabase sync. |
| `flutter build apk --release --dart-define=SUPABASE_URL=... --dart-define=SUPABASE_ANON_KEY=...` | Build release APK (final). |
| `flutter test` | Run all tests. |

## Database (Drift)

- **16 tables**: 15 original + `SyncRecordTable` untuk UUID mapping sync
- Defined in `lib/data/database/tables/`, aggregated in `lib/data/database/app_database.dart`
- **Schema version 10**: v1→v6 original migrations, v6→v7 adds `SyncRecordTable`, v7→v8 adds `SupplierProductsTable`, v8→v9 adds `TokoTable` + `tokoId` columns, v9→v10 adds `isPpnEnabled` + `ppnPercent` to `pending_pembelian_table`
- Connection via `LazyDatabase` → `NativeDatabase` (file: `hend_kasir.db` in app docs dir)

## Supabase Sync & Auth (Arsitektur V2)

- **Auth menggunakan Supabase Auth (Hybrid)**: Kredensial login (email & password) ditangani dan divalidasi penuh oleh Supabase Auth (online). Password tidak disimpan di lokal. Profil pengguna tersimpan di tabel `profiles` Supabase dan akan di-cache secara lokal ke tabel `user` Drift bersamaan dengan *session token* (di `SharedPreferences`). Ini memungkinkan aplikasi tetap bisa dibuka tanpa internet (offline) asalkan sesi lokal masih ada (sistem *Cloud Recovery Login*).
- **Offline-first (V2 Sync)**: Database lokal (Drift) tetap menjadi tumpuan utama operasional harian. Sinkronisasi menggunakan model *direct upsert* per-tabel ke Supabase (tidak ada lagi `SyncRecordTable` atau UUID mapping JSON blob dari V1).
- **Mekanisme Sync**: Data baru/berubah akan di-push (upsert) ke Supabase. Jika *offline*, aksi akan diantrikan ke `pending_sync_queue_table`. Saat `pull()`, data dari device lain diunduh berdasarkan parameter `updated_at` atau `created_at`.
- Konfigurasi Supabase via `--dart-define=SUPABASE_URL=... --dart-define=SUPABASE_ANON_KEY=...`
- File `supabase_setup.sql` / `supabase_setup_v2.sql` untuk setup tabel di project Supabase.
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

## Agent Behavior Rules

- **Ambiguitas**: Jika perintah user ambigu atau kurang jelas, WAJIB tanya apa yang dimaksud. Bisa juga kasih rekomendasi opsi yang memungkinkan.
- **Commit**: WAJIB selalu tanya konfirmasi sebelum melakukan commit. Jangan pernah commit tanpa persetujuan eksplisit.
- **Sebelum ubah kode**: WAJIB konfirmasi ke user dan jelaskan alasan/kenapa kode tersebut perlu diubah sebelum melakukan perubahan. Sertakan juga dampak dari perubahan tersebut.

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

## Printing System (Thermal Printer)

- **Architecture**: HP → HTTP → PC Print Server (Python + FastAPI) → USB Thermal Printer, atau langsung via Bluetooth
- **PC Print Server**: `print_server.py` di root project. Run: `pip install fastapi uvicorn python-escpos pyusb && python print_server.py`
- **Flutter Services**: `PrinterService` abstraction → `NetworkPrinterService` (HTTP) + `BluetoothPrinterService` (BLE via `flutter_blue_plus`)
- **Settings**: `PrinterSettingsPage` accessible from Settings page. Configure printer type (Network/Bluetooth), URL, toko name, paper width (58mm/80mm), ukuran font (kecil/normal/besar)
- **Auto-print**: After cashier transaction success, receipt auto-prints if printer is enabled in settings
- **Dynamic DI**: `PrinterService` diregistrasi ulang via `updatePrinterService()` saat tipe printer berubah. `ReceiptGenerator` baca `fontSize` dari `PrinterSettings`.
- **ESC-POS**: Both network and Bluetooth services generate raw ESC-POS commands; ukuran font dikontrol via ESC/POS print mode byte

## Version Tracking

Gunakan notasi berikut untuk menyebut huruf versi yang ingin dinaikkan:
- **x** — Major (breaking changes, reset y & z ke 0)
- **y** — Minor (fitur baru, reset z ke 0)
- **z** — Patch (bug fix / perbaikan kecil)

Current: **1.4.10**

## Log Konvensi

> **Setiap bug fix dan penambahan fitur WAJIB dicatat di bagian log di bawah ini** (format konsisten) agar menjadi referensi untuk development selanjutnya. Format:
> - Bug: `### Bug: <nama> — <deskripsi singkat>` dengan root cause, fix, files, date
> - Fitur: `### Fitur: <nama>` dengan deskripsi, cara pakai, files, date

## Bug Fixes Log

### Bug: Android Build — Unresolved reference FlutterEngine & MethodChannel
- **Root cause**: File `MainActivity.kt` kehilangan import `FlutterEngine` dan `MethodChannel` yang menyebabkan kompilasi Kotlin gagal saat build APK rilis di GitHub Actions.
- **Fix**: Menambahkan `import io.flutter.embedding.engine.FlutterEngine` dan `import io.flutter.plugin.common.MethodChannel` ke dalam file `MainActivity.kt`.
- **Files**: `android/app/src/main/kotlin/com/example/hend_kasir/MainActivity.kt`
- **Date**: 2026-05-30

### Bug: Infinite Layout Loop — Android freeze saat tap menu Stok
- **Root cause**: `_buildHeader()` menggunakan `MediaQuery.of(context).padding.top` langsung di body Scaffold (Column), dan `_buildBottomBar()` menggunakan `MediaQuery.of(context).padding.bottom`. Saat keyboard muncul, `resizeToAvoidBottomInset` mengubah `MediaQuery` → rebuild seluruh subtree → Column resize → trigger rebuild loop → freeze/ANR.
- **Fix**: Pindahkan header ke `_buildAppBar()` (AppBar widget), wrap bottom bar dengan `SafeArea` + fixed padding, tambah `resizeToAvoidBottomInset: true`.
- **Files**: `lib/presentation/pages/shared/produk_form_page.dart`
- **Date**: 2026-05-27

### Bug: Layout Error — Spacer di unbounded Column di ProdukCard
- **Root cause**: `const Spacer()` di dalam `Column` di `Card` (dalam `ListView.builder`). `ListView` memberi unbounded height constraint (`0..Inf`), `Spacer` butuh bounded height untuk distribusi flex → layout never resolve → infinite `NEEDS-LAYOUT` loop.
- **Fix**: Ganti `const Spacer()` dengan `const SizedBox(height: 8)` agar Column shrink-wrap natural ke kontennya.
- **Files**: `lib/presentation/widgets/produk_card.dart`
- **Date**: 2026-05-27

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

### Bug: Produk — Freeze saat tambah produk
- **Root cause**: Penggunaan `bottomSheet` pada `Scaffold` di `ProdukFormPage` sering menyebabkan infinite layout pass (freeze UI).
- **Fix**: Menghapus argumen `bottomSheet` dari `Scaffold` dan memindahkan `_buildBottomBar()` ke dalam struktur `Column` utama di body Scaffold tepat di bawah `Expanded(SingleChildScrollView)`. Padding bottom disesuaikan dari 120 menjadi 20.
- **Files**: `lib/presentation/pages/produk_form_page.dart`
- **Date**: 2026-05-25

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
- **Files**: `user_table.dart`, `app_database.dart` (v13), `auth_repository.dart`, `auth_repository_impl.dart`, `auth_event.dart`, `auth_bloc.dart`, `register_store_page.dart`, `user_management_page.dart`, `home_page.dart`
- **Date**: 2026-05-21

### Bug: Auth — Logout tidak navigasi ke LoginPage + Nama di AppBar tidak real-time
- **Root cause**: (1) Home page tidak punya listener untuk `Unauthenticated` state — hanya `BlocBuilder` tanpa `BlocListener`, jadi saat logout emit `Unauthenticated`, halaman tetap menampilkan UI kosong. (2) `AuthRepositoryImpl.updateUser()` hanya update DB, tidak update session di `SharedPreferences`, jadi nama baru tidak terbaca sampai login ulang.
- **Fix**: (1) Tambah `BlocListener<AuthBloc, AuthState>` di `HomePage` yang navigasi ke `LoginPage` via `pushAndRemoveUntil` saat `Unauthenticated` state. (2) Update session JSON di `updateUser()` jika user ID cocok dengan session. (3) Dispatch `CheckAuthStatus` dari `UserManagementPage` setelah save agar AppBar langsung update.
- **Files**: `home_page.dart`, `auth_repository_impl.dart`, `user_management_page.dart`
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
- **Files**: `lib/data/services/supabase_sync_service.dart`, `lib/core/di/injection.dart`, `lib/data/repositories/auth_repository_impl.dart`
- **Date**: 2026-05-21

### Bug: User Management — Kebocoran Manajemen Pengguna Lintas Toko
- **Root cause**: `_tableInserters['user']` dan `_tableUpdaters['user']` di `SupabaseSyncService` tidak menyertakan pemetaan kolom `tokoId`, `nama`, dan `email` secara lokal saat sinkronisasi cloud. Akibatnya, Drift secara otomatis mengisinya dengan nilai default `1` (sesuai spesifikasi skema), sehingga semua user dari toko lain bocor ke halaman manajemen pengguna toko ID 1 secara lokal.
- **Fix**: Perbarui parser sinkronisasi `_tableInserters` dan `_tableUpdaters` untuk tabel `user` agar secara eksplisit memetakan kolom `username` (nullable), `password`, `role`, `nama` (nullable), `email` (nullable), dan `tokoId` (`json['tokoId'] ?? json['_toko_id'] ?? 1`).
- **Files**: `lib/data/services/supabase_sync_service.dart`
- **Date**: 2026-05-21

### Bug: User Management — User dari toko lain masih tampil + bisa diubah passwordnya
- **Root cause**: (1) Self-healing logic di `getAllUsers()` meng-inner-join semua `syncRecord` tanpa filter `tokoId`, sehingga user dari toko lain yang punya sync record bisa ter-assign ke toko aktif. (2) `updateUser()` dan `deleteUser()` tidak memvalidasi bahwa `tokoId` user yang dioperasi cocok dengan toko yang sedang login — admin toko lain bisa diubah/dihapus.
- **Fix**: (1) Self-healing di `getAllUsers()` sekarang hanya join sync record yang punya `tokoId == currentTokoId`, dan hanya koreksi user yang punya sync record milik toko saat ini tapi tokoId-nya salah. (2) `updateUser()` sekarang cek `existing.tokoId != currentTokoId` dan throw jika beda. (3) `deleteUser()` idem — fetch user dulu, guard `tokoId`, baru hapus.
- **Files**: `lib/data/repositories/auth_repository_impl.dart`
- **Date**: 2026-05-21

### Fitur: Penamaan APK Rilis Dinamis 'hendkasir-v<version>.apk'
- **Deskripsi**: Mengotomatiskan dan mendinamiskan penamaan file APK saat dirilis dan diunduh. Gradle lokal dikonfigurasi untuk otomatis memberi nama `hendkasir-v<versionName>.apk` saat proses kompilasi rilis, dan `UpdateService` disempurnakan agar secara dinamis menyaring aset rilis di GitHub yang berawalan `hendkasir` dan berakhiran `.apk` (serta fallback `app-release.apk`).
- **Cara pakai**: Jalankan `flutter build apk --release` untuk otomatis menghasilkan file APK dengan nama khusus di folder lokal. Unggah berkas APK tersebut ke dashboard rilis GitHub Anda, dan aplikasi akan secara otomatis mendeteksi, mengunduh, serta memperbaruinya dengan andal.
- **Files**: `android/app/build.gradle.kts`, `lib/core/services/update_service.dart`, `lib/presentation/pages/settings_page.dart`
- **Date**: 2026-05-21

### Fitur: Sinkronisasi Cloud Manual di Pengaturan
- **Deskripsi**: Menambahkan menu "Sinkronisasi Cloud" interaktif di halaman Pengaturan untuk memicu sinkronisasi dua arah secara manual (push & pull). Hal ini memungkinkan pengguna mengunggah seluruh data lokal dari HP ke cloud Supabase secara instan agar bisa diakses oleh perangkat baru (recovery).
- **Cara pakai**: Masuk ke Pengaturan → pilih "Sinkronisasi Cloud" → tunggu hingga proses selesai. Status keberhasilan atau kesalahan ditampilkan lewat SnackBar.
- **Files**: `lib/presentation/pages/settings_page.dart`
- **Date**: 2026-05-21



### Fitur: Halaman Terpisah Undang Kasir
- **Deskripsi**: Fungsi invite kasir dipindah dari dialog di `UserManagementPage` ke halaman terpisah (`InviteKasirPage`) dengan form validasi lengkap (email format, required). FAB di user management sekarang navigasi ke halaman baru.
- **Cara pakai**: Buka Manajemen Pengguna → tap FAB (+) → isi email & nama (opsional) → "Undang Kasir".
- **Files**: `lib/presentation/pages/invite_kasir_page.dart`, `lib/presentation/pages/user_management_page.dart`
- **Date**: 2026-05-21

### Fitur: Stok Minimum Per Item & Global
- **Deskripsi**: Menambahkan pengaturan Stok Minimum baik secara global untuk satu toko (lewat tombol khusus di AppBar Daftar Produk) maupun spesifik per item (lewat form Produk). Jika stok suatu item mencapai angka ini atau lebih rendah, akan muncul indikator merah di daftar produk.
- **Cara pakai**: Di halaman Daftar Produk, tap ikon kotak (stok) di AppBar untuk atur Stok Minimum Global. Saat tambah/edit barang, bisa set nilai Stok Minimum spesifik atau dikosongkan agar ikut global.
- **Files**: `produk_form_page.dart`, `produk_page.dart`, `produk_card.dart`, `toko_service.dart`
- **Date**: 2026-05-24

### Fitur: RBAC Kasir — Harga Pokok & Margin Tersembunyi
- **Deskripsi**: Halaman kasir sekarang membaca role dari `AuthBloc`. Jika pengguna adalah kasir (`role == 'kasir'`), `hargaPokok` yang dikirim ke `AddToCart` di-set ke 0, sehingga margin (`hargaJual - hargaPokok`) tidak tersimpan di state manapun.
- **Cara pakai**: Login sebagai kasir → buka halaman Kasir → tambah produk → `hargaPokok` diset 0 secara otomatis.
- **Files**: `lib/presentation/pages/cashier_page.dart`
- **Date**: 2026-05-21

### Cleanup: Hapus sync_helper.dart
- **Deskripsi**: File `sync_helper.dart` sudah tidak ada (stub kosong, tidak dipakai). Referensi di AGENTS.md dihapus.
- **Files**: `AGENTS.md`
- **Date**: 2026-05-21

### Bug: Pending Pembelian — Blank screen saat tap + auto-delete saat back
- **Root cause**: (1) `_openPending` di `pending_pembelian_page.dart` pakai `pushReplacement` sehingga user tidak bisa kembali. (2) `_loadPending` di `pembelian_form_page.dart` langsung `deletePending()` setelah load tanpa loading indicator. (3) Akibatnya layar tampil kosong (abu-abu) saat data masih loading, dan jika user back pending sudah terhapus.
- **Fix**: (1) Ganti `pushReplacement` jadi `push` + reload list saat kembali. (2) Tambah `_isLoadingPending` + `CircularProgressIndicator`. (3) Simpan `_loadedPendingId` dan hanya delete saat form sukses disimpan (di BlocListener) atau saat explicit cancel (kasir path).
- **Files**: `lib/presentation/pages/pending_pembelian_page.dart`, `lib/presentation/pages/pembelian_form_page.dart`
- **Date**: 2026-05-22

### Fitur: Diskon Global + PPN di Harga Modal (Pembelian Form)
- **Deskripsi**: (1) Tambah global discount di bottom panel (samping PPN) dengan SegmentedButton (Tidak/%/Rp) + input field. Diskon global diaplikasikan setelah diskon per-item, sebelum PPN. (2) Jika PPN aktif, harga beli satuan di cart list tampil dengan strikethrough abu-abu (harga sebelum PPN) dan di bawahnya muncul harga nett setelah PPN. (3) Field diskon tersimpan di DB via migrasi schema 1→2 (tambah `diskonTipe`, `diskonPersen`, `diskonNominal` ke `PendingPembelianTable`).
- **Cara pakai**: Buka Pembelian Baru → di bottom panel, atur Diskon (Tdk/%/Rp) → aktifkan PPN jika perlu → harga item di cart otomatis tampilkan harga nett PPN.
- **Files**: `lib/presentation/pages/pembelian_form_page.dart`, `lib/domain/entities/pending_pembelian.dart`, `lib/data/database/tables/pending_pembelian_table.dart`, `lib/data/database/app_database.dart`, `lib/data/repositories/pending_pembelian_repository_impl.dart`
- **Date**: 2026-05-22

### Fitur: Profil Dashboard — Popup Menu (Settings, Manajemen Pengguna, Catatan)
- **Deskripsi**: Logo profil/CircleAvatar di halaman dashboard sekarang bisa diklik dan menampilkan popup menu berisi: Pengaturan, Manajemen Pengguna (admin only), dan Catatan & Peringatan (NotifikasiPage).
- **Cara pakai**: Tap logo profil di dashboard → pilih menu.
- **Files**: `lib/presentation/pages/home_page.dart`
- **Date**: 2026-05-22

### Fitur: Loading Indicator di Tombol Simpan (Anti Double-Input)
- **Deskripsi**: Tambah loading spinner di tombol Simpan pada ProdukFormPage, PembelianFormPage, dan CashierPage untuk mencegah double input akibat delay save (local DB + cloud sync). Tombol disable + spinner selama proses berlangsung.
- **Cara pakai**: Setelah tap Simpan/Bayar, tombol menampilkan spinner dan tidak bisa diklik lagi sampai proses selesai.
- **Files**: `lib/presentation/pages/produk_form_page.dart`, `lib/presentation/pages/pembelian_form_page.dart`, `lib/presentation/pages/cashier_page.dart`
- **Date**: 2026-05-22

### Bug: Periksa Pembaruan — Tidak pernah mendeteksi update dari CI
- **Root cause**: Filter asset name di `UpdateService.checkForUpdate()` menggunakan `startsWith('hendkasir')` (tanpa underscore), tapi CI workflow menghasilkan file `hend_kasir-v<version>.apk` (dengan underscore + build number). Filter tidak pernah match.
- **Fix**: Ubah filter jadi `startsWith('hend')` agar mencakup `hendkasir*` dan `hend_kasir*`.
- **Files**: `lib/core/services/update_service.dart`
- **Date**: 2026-05-22

### Fitur: Aksi Cepat Kustom + Hapus Profil + Ganti Judul
- **Deskripsi**: (1) Hapus logo profil/CircleAvatar dari AppBar mobile. (2) Ganti judul "POS Terminal" jadi "hend_kasir". (3) Tambah tombol "+" di header Aksi Cepat + card "TAMBAH" di akhir scroll untuk menambah menu dari Lainnya (Pembelian, Supplier, Hutang) ke baris Aksi Cepat. (4) Manajemen Pengguna pindah ke bottom sheet Lainnya.
- **Cara pakai**: Tap tombol "+" atau kartu TAMBAH di Aksi Cepat → pilih menu → muncul di baris.
- **Files**: `lib/presentation/pages/home_page.dart`
- **Date**: 2026-05-22

### Bug: Role owner tidak terbaca setelah buat toko baru (akses tambah produk hilang)
- **Root cause**: Setelah `registerStore()` berhasil, `AuthBloc` emit `StoreRegistered` (bukan `Authenticated`). `produk_page.dart` hanya mengecek `authState is Authenticated && authState.user.isOwner`, sehingga saat state adalah `StoreRegistered`, `isAdmin` selalu `false` — FAB tambah produk tidak muncul. Logout → Login mengubah state ke `Authenticated` sehingga role terbaca benar.
- **Fix**: (1) Di `auth_bloc.dart`, emit `Authenticated(user)` segera setelah `StoreRegistered(user)` agar state akhir selalu `Authenticated`. (2) Di `produk_page.dart`, `isAdmin` juga handle `StoreRegistered` state sebagai fallback.
- **Files**: `lib/presentation/blocs/auth/auth_bloc.dart`, `lib/presentation/pages/produk_page.dart`
- **Date**: 2026-05-22

### Bug: Pembelian — Harga nett (dengan PPN/diskon global) tidak tersimpan ke database
- **Root cause**: Saat melakukan _submit_ pada form pembelian, `ItemPembelianData` yang dikirim ke Bloc masih menggunakan `hargaBeliSatuan` awal (belum ditambah distribusi beban PPN dan dikurangi distribusi diskon global). Akibatnya harga pokok produk di database (`ProdukTable.hargaBeli`) tidak mencerminkan harga riil HPP.
- **Fix**: Di `_submit` sebelum memanggil `AddPembelianEvent` atau `UpdatePembelianEvent`, hitung alokasi proporsional diskon global & PPN ke setiap item untuk mendapatkan `nettHargaBeliSatuan` dan `nettSubtotal`. Item dengan nilai nett inilah yang dikirim ke Bloc dan diteruskan hingga update stok/HPP.
- **Files**: `lib/presentation/pages/pembelian_form_page.dart`
- **Date**: 2026-05-22

### Bug: Pembelian — Validasi harga beli tidak memasukkan PPN/diskon global
- **Root cause**: Dialog validasi `_PriceValidationDialog` menampilkan dan meneruskan `item.hargaBeliSatuan` dari cart, bukan `nettHargaBeliSatuan` yang sudah dikalkulasi dengan PPN dan diskon global. Begitu juga data yang diteruskan ke `_pendingSaveItems` untuk `SupplierProductsTable`.
- **Fix**: Menggunakan `itemsData[i].hargaBeliSatuan` yang mengandung nilai nett untuk dikirim ke list `changedItems` yang memicu dialog validasi. Serta memperbarui `_pendingSaveItems` untuk memakai nilai harga nett ketika disimpan agar sinkron dengan `ProdukTable`.
- **Files**: `lib/presentation/pages/pembelian_form_page.dart`
- **Date**: 2026-05-23

### Bug: Logic Pembelian — Pembelian dengan satuan konversi menggunakan harga satuan dasar
- **Root cause**: Di `CariProdukDialog`, callback `onAddToCart` selalu menerima `produk.hargaBeli` (harga dasar) sebagai argumen `hargaBeli`, meskipun pengguna memilih satuan konversi (seperti pak).
- **Fix**: Mengubah `CariProdukDialog._pilihProduk` agar menghitung `finalHargaBeli` (dan `finalHargaJual`) dengan benar berdasarkan satuan yang dipilih, menggunakan harga spesifik satuan jika ada, atau mengalikan harga dasar dengan rasio konversi.
- **Files**: `lib/presentation/widgets/cari_produk_dialog.dart`
- **Date**: 2026-05-25

### Fitur: Buka Laci Otomatis Saat Cetak Nota (Bluetooth/USB)
- **Deskripsi**: Kasir kini tidak perlu membuka laci uang secara manual. Aplikasi secara otomatis mengirim perintah ESC/POS buka laci ke printer Bluetooth/USB sebelum memotong struk transaksi.
- **Cara pakai**: Lakukan transaksi dan cetak nota. Laci uang yang terhubung dengan laci RJ11 di printer (yang dikonfigurasi via Bluetooth/USB) akan terbuka otomatis.
- **Files**: `lib/data/services/bluetooth_printer_service.dart`
- **Date**: 2026-05-25

### Fitur: Update Theme
- **Deskripsi**: Update palet warna, dark theme, light theme sesuai design system baru.
- **Cara pakai**: Theme otomatis mengikuti sistem.
- **Files**: `lib/core/theme/app_theme.dart`
- **Date**: 2026-05-27

### Fitur: Auto-Konvert Harga Beli Multi-Satuan dengan Listener
- **Deskripsi**: Setiap perubahan nilai konversi pada multi-satuan akan otomatis mengubah harga beli satuan dasar secara real-time.
- **Cara pakai**: Edit nilai konversi satuan di form produk → harga beli satuan dasar otomatis menyesuaikan.
- **Files**: `lib/presentation/pages/produk_form_page.dart`
- **Date**: 2026-05-27

### Refactor: Android-only — Final Cleanup Desktop/Mobile Split
- **Deskripsi**: Hapus semua kode desktop (home_page_desktop.dart, cashier_desktop_view.dart, pembelian_desktop_view.dart) dan kode mobile yang di-orphan (home_page_mobile.dart). Integrasi `CashierDesktopView` langsung ke `cashier_page.dart`, `PembelianDesktopView` ke `pembelian_form_page.dart`. Home page mobile (`HomeMobilePage`) dipindah ke `shared/home_page.dart` sebagai satu-satunya halaman utama. Hapus folder `desktop/` dan `mobile/`. Project sekarang murni Android-only.
- **Files**: `cashier_page.dart`, `pembelian_form_page.dart`, `home_page.dart`, `desktop/*` (dihapus), `mobile/*` (dihapus)
- **Date**: 2026-05-30

### Bug: Pembelian — Satuan konversi tidak tersimpan saat transaksi pembelian
- **Root cause**: Saat melakukan transaksi pembelian dengan satuan konversi (seperti "pak"), datanya hilang karena tabel database lokal (`item_pembelian_table` dan `pending_pembelian_item_table`) serta sinkronisasi Supabase tidak memiliki kolom `satuan_id` dan `konversi`.
- **Fix**: Menambahkan kolom `satuan_id` dan `konversi` pada database lokal via migrasi Drift (v17) dan menyesuaikan `SupabaseSyncService`. `PembelianRepositoryImpl` juga diperbarui untuk mengambil nama spesifik satuan konversi dari `satuan_produk` saat memuat riwayat pembelian.
- **Files**: `app_database.dart`, `item_pembelian_table.dart`, `pending_pembelian_item_table.dart`, `pembelian_repository_impl.dart`, `pending_pembelian_repository_impl.dart`, `supabase_sync_service.dart`, `supabase_setup_v2.sql`
- **Date**: 2026-05-27

### Bug: Sync Supabase — Kolom stokMinimum tidak tersinkronisasi dua arah
- **Root cause**: `ProdukTable` dan `TokoTable` di Drift memiliki kolom `stok_minimum` dan `stok_minimum_global`, namun tabel `produk` dan `toko` di database jarak jauh Supabase belum memiliki kolom tersebut, menyebabkan sinkronisasi gagal menyimpan nilai stok minimum ke cloud.
- **Fix**: Menambahkan definisi `stok_minimum_global` (INTEGER NOT NULL DEFAULT 0) di tabel `toko` dan `stok_minimum` (INTEGER) di tabel `produk` pada skrip setup Supabase (`supabase_setup_v2.sql`). Ditambahkan juga baris migrasi `ALTER TABLE` agar tabel yang sudah ada dapat langsung diperbarui.
- **Files**: `supabase_setup_v2.sql`
- **Date**: 2026-05-28

### Fitur: Digital Nota untuk Pembelian (Supplier sebagai Nama Toko)
- **Deskripsi**: Tombol Share pada detail pembelian sekarang menggunakan `ShareReceiptPage` (digital nota visual PNG) seperti di kasir, bukan teks biasa. Nama toko di nota menggunakan nama supplier sebagai header. `DigitalReceiptWidget` ditambahkan parameter `statusTitle` untuk judul yang berbeda. Detail pembayaran (metode, tunai, kembalian) disembunyikan jika tidak relevan.
- **Cara pakai**: Buka Pembelian Barang → tap item → "Share" → preview digital nota dengan nama supplier → "Bagikan via WA" atau "Cetak Thermal".
- **Files**: `digital_receipt_widget.dart`, `pembelian_page.dart`
- **Date**: 2026-05-30