# Aplikasi Kasir - Tech Debt & Improvements To-Do List

Dokumen ini berisi daftar peningkatan arsitektur dan kualitas kode (tech debt) yang direkomendasikan untuk aplikasi kasir ini, disusun berdasarkan tingkat prioritas. Silakan centang `[x]` jika tugas sudah selesai diimplementasikan.

## 🔴 High Priority (Kritis untuk Stabilitas)

- [x] **Implementasi Database Transaction (Drift)**
  - **Metode**: Menginjeksikan `AppDatabase` ke `BuatTransaksi` dan `BuatPembelian`, lalu membungkus seluruh pemanggilan _repository_ menggunakan `await db.transaction(() async { ... })`. Karena Drift v2+ menggunakan Dart Zones, pemanggilan _repository_ di dalam blok tersebut akan otomatis tergabung ke dalam _transaction context_ yang sama.
  - [x] Refactor usecase `BuatTransaksi` agar memanipulasi stok, item_transaksi, transaksi, dan notifikasi dalam satu blok `db.transaction(() async { ... })`.
  - [x] Refactor usecase `BuatPembelian` dengan blok transaksi untuk menjamin konsistensi data.
  - [x] Pastikan tidak ada partial-insert (data masuk setengah) ketika aplikasi ditutup paksa atau terjadi error.

- [x] **Functional Error Handling (fpdart / dartz)**
  - **Metode**: Menambahkan package `fpdart` dan kelas dasar `Failure` di `core/errors/failure.dart`. Menggunakan pendekatan `FutureEitherExtension` (`.toEither()`) pada level BLoC agar tidak merusak 200+ komponen antarmuka yang mengandalkan return `Future<T>` secara langsung. 
  - [x] Tambahkan package `fpdart` atau `dartz`.
  - [x] Buat extension `FutureEitherExtension` di `lib/core/utils/future_extension.dart`.
  - [x] Ganti `try-catch` tradisional di berbagai BLoC penting dengan pemanggilan `.toEither().fold(...)` agar error selalu ter-handle dengan aman.

## 🟡 Medium Priority (Skalabilitas & Maintainability)

- [x] **Dependency Injection Generator (injectable)**
  - [x] Tambahkan package `injectable` dan `injectable_generator`.
  - [x] Beri anotasi `@lazySingleton` atau `@injectable` pada semua BLoC, Repository, dan Usecase.
  - [x] Jalankan build_runner untuk men-generate file `injection.config.dart`.
  - [x] Bersihkan file `lib/core/di/injection.dart` dari registrasi manual yang repetitif.

- [x] **State & Event Management (freezed)**
  - [x] Tambahkan package `freezed` dan `freezed_annotation`.
  - [x] Refactor state di BLoC (misalnya `ProdukState`) menjadi union classes menggunakan `freezed` (`@freezed class ProdukState with _$ProdukState`).
  - [x] Ganti implementasi `equatable` pada entities (opsional, tapi disarankan) dan states.
  - [x] Gunakan fungsi `.maybeWhen()` atau `.map()` di `BlocBuilder` pada layer UI untuk menjamin semua kemungkinan state (loading, error, success) telah ditangani.

## 🟢 Low Priority (UX & Background Tasks)

- [x] **Background Sync untuk Supabase (workmanager)**
  - [x] Tambahkan package `workmanager`.
  - [x] Konfigurasi headless task untuk melakukan _push_ antrean `pending_sync_queue_table` ke Supabase di latar belakang (misalnya setiap 15-30 menit) walau aplikasi tidak sedang dibuka.
  - [x] Pastikan *conflict resolution* (Last Write Wins) bekerja sempurna di background.

- [x] **Localization & Hardcoded Strings Extraction (i18n)**
  - [x] Instal package `slang` atau `flutter_localizations`.
  - [x] Pindahkan seluruh teks UI yang _hardcoded_ (seperti peringatan PIN, label tombol) ke dalam file `strings_id.json` atau `app_id.arb`.
  - [x] Bersihkan pesan error _hardcoded_ dari BLoC, biarkan BLoC mengembalikan Enum atau Code, dan UI yang menerjemahkannya.
  
---
_Catatan: Beri tanda centang `[x]` pada kotak jika Anda telah menyelesaikan dan melakukan push ke Git untuk masing-masing perbaikan._
