# hend_kasir — Improvement Roadmap

> Versi app saat ini: `v1.4.10+24` · Flutter `^3.11.5` · Dart SDK `^3.11.5`  
> Dokumen ini berisi daftar area yang perlu diperbaiki, diurutkan berdasarkan prioritas.

---

## 🔴 Prioritas Tinggi (Security & Stability)

### 1. Hapus Data Sensitif dari Repo Publik

**File terdampak:** `rokok_virgo_supabase.json`

File ini berisi data toko nyata (nama toko, produk, stok, harga) dan tidak seharusnya ada di repo publik. Siapapun bisa mengakses data tersebut.

**Langkah perbaikan:**
```bash
# Hapus dari tracking git
git rm --cached rokok_virgo_supabase.json

# Tambah ke .gitignore
echo "*.json" >> .gitignore   # atau spesifik:
echo "rokok_virgo_supabase.json" >> .gitignore

# Commit
git add .gitignore
git commit -m "chore: remove sensitive store data from repo"
git push
```

> ⚠️ **Catatan:** File ini sudah masuk ke git history. Kalau mau benar-benar hilang dari history lama, perlu `git filter-repo` atau hubungi GitHub support untuk purge. Minimal, hapus sekarang agar tidak bisa diakses dari branch aktif.

---

### 2. Hashing PIN Kasir

**Lokasi perkiraan:** auth lokal / entitas `User` di Drift schema

PIN kasir saat ini kemungkinan disimpan sebagai plaintext di SQLite lokal. Ini berbahaya jika device hilang atau diakses orang lain.

**Perbaikan:**
```dart
// Gunakan package crypto
import 'package:crypto/crypto.dart';
import 'dart:convert';

String hashPin(String pin) {
  final bytes = utf8.encode(pin);
  return sha256.convert(bytes).toString();
}

// Saat simpan PIN:
final hashedPin = hashPin(pinController.text);

// Saat verifikasi:
final isValid = hashPin(inputPin) == storedHashedPin;
```

Tambahkan `crypto: ^3.0.0` ke `pubspec.yaml`.

Selain hashing, tambahkan juga:
- Batas 5x percobaan PIN salah → lockout sementara (misal 30 detik)
- Opsi reset PIN oleh owner melalui panel manajemen user

---

### 3. Bersihkan File Sampah di Root

Lihat dokumen `CLEANUP_GUIDE.md` untuk langkah lengkapnya.

File-file berikut tidak seharusnya ada di root repo dan perlu dihapus atau dipindahkan:

| File | Status | Aksi |
|---|---|---|
| `rokok_virgo_supabase.json` | 🔴 Data sensitif | Hapus + gitignore |
| `build_log.txt` | 🟡 Artefak build | Hapus + gitignore `*.txt` |
| `home_v2.html` | 🟡 Mockup UI | Pindah ke `docs/mockups/` |
| `import_json.dart` | 🟡 Script sementara | Pindah ke `tools/` atau hapus |
| `migrasi.sql` | 🟡 SQL draft | Pindah ke `supabase/migrations/` |
| `rls_fix.sql` | 🟡 SQL draft | Pindah ke `supabase/migrations/` |
| `supabase_setup.sql` | 🟡 SQL setup lama | Pindah ke `supabase/` |
| `supabase_setup_v2.sql` | 🟡 SQL setup aktif | Pindah ke `supabase/` |
| `theme.md` | 🟢 Dokumentasi | Pindah ke `docs/` |

---

## 🟡 Prioritas Menengah (Features & Reliability)

### 4. Unit Testing untuk Logika Bisnis

**Lokasi:** `/test/`

Folder test ada tapi hampir pasti masih kosong (default `widget_test.dart` saja). Aplikasi kasir yang menyentuh uang **wajib** punya test untuk:

```
test/
├── unit/
│   ├── calculation_test.dart     # total, diskon, PPN, kembalian
│   ├── satuan_converter_test.dart # konversi multi-satuan produk
│   ├── hutang_test.dart           # kalkulasi sisa hutang
│   └── sync_conflict_test.dart    # logika conflict resolution
└── widget/
    └── kasir_screen_test.dart    # flow transaksi utama
```

Contoh test kalkulasi:
```dart
// test/unit/calculation_test.dart
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('Kalkulasi Transaksi', () {
    test('Total dengan diskon item + diskon global', () {
      final subtotal = 50000.0;
      final diskonItem = 0.10;    // 10%
      final diskonGlobal = 5000.0;
      final ppn = 0.11;           // 11%

      final afterItemDiscount = subtotal * (1 - diskonItem);  // 45000
      final afterGlobalDiscount = afterItemDiscount - diskonGlobal;  // 40000
      final total = afterGlobalDiscount * (1 + ppn);  // 44400

      expect(total, closeTo(44400.0, 0.01));
    });
  });
}
```

---

### 5. Strategi Conflict Resolution Sync

**Lokasi:** sync service / Supabase push-pull logic

Skenario: kasir A edit stok produk X saat offline, kasir B juga edit stok produk X yang sama saat offline. Saat keduanya sync, siapa yang menang?

**Rekomendasi: Last-Write-Wins dengan `updated_at` timestamp**

```sql
-- Pastikan setiap tabel punya kolom ini:
ALTER TABLE products ADD COLUMN updated_at TIMESTAMPTZ DEFAULT NOW();
ALTER TABLE transactions ADD COLUMN updated_at TIMESTAMPTZ DEFAULT NOW();

-- Trigger otomatis update timestamp:
CREATE OR REPLACE FUNCTION update_updated_at()
RETURNS TRIGGER AS $$
BEGIN
  NEW.updated_at = NOW();
  RETURN NEW;
END;
$$ LANGUAGE plpgsql;
```

Di Flutter, saat push ke Supabase:
```dart
// Pakai upsert dengan preferensi server jika lebih baru
await supabase.from('products').upsert(
  localProduct.toJson(),
  onConflict: 'id',
  // Hanya update jika data lokal lebih baru
);
```

Dokumentasikan strategi ini di README agar jelas behavior-nya untuk semua developer.

---

### 6. Sync yang Lebih Cerdas

**Kondisi saat ini:** auto-sync fixed interval tiap 5 menit

**Perbaikan yang disarankan:**

```dart
// Di sync service, tambahkan listener konektivitas
// connectivity_plus sudah ada di pubspec.yaml ✅

class SyncService {
  StreamSubscription? _connectivitySub;

  void init() {
    // Sync saat koneksi kembali online
    _connectivitySub = Connectivity().onConnectivityChanged.listen((result) {
      if (result != ConnectivityResult.none) {
        triggerSync(); // langsung sync, tidak tunggu 5 menit
      }
    });
  }

  // Tambahkan exponential backoff saat sync gagal
  Future<void> syncWithRetry({int attempt = 0}) async {
    try {
      await performSync();
    } catch (e) {
      if (attempt < 3) {
        final delay = Duration(seconds: pow(2, attempt).toInt()); // 1s, 2s, 4s
        await Future.delayed(delay);
        await syncWithRetry(attempt: attempt + 1);
      }
    }
  }
}
```

Tambahkan juga indikator di UI: "Terakhir sync: 5 menit lalu" alih-alih hanya spinner.

---

### 7. Laporan yang Lebih Lengkap

**Kondisi saat ini:** hanya riwayat transaksi dengan filter tanggal

**Yang dibutuhkan untuk toko sembako:**

| Laporan | Prioritas | Deskripsi |
|---|---|---|
| Laba Rugi | Tinggi | HPP vs harga jual, margin per produk |
| Produk Terlaris | Tinggi | Top N produk per periode |
| Ringkasan Hutang | Tinggi | Hutang per pelanggan, total outstanding |
| Arus Kas Harian | Menengah | Pemasukan vs pengeluaran per hari |
| Stok Menipis | Menengah | Produk di bawah stok minimum |
| Export PDF/Excel | Menengah | Untuk pembukuan manual / akuntansi |

Export PDF bisa menggunakan package `pdf` + `printing` yang sudah populer di Flutter.

---

### 8. Graceful Handling Supabase Auto-Pause

**Konteks:** Supabase free tier akan auto-pause setelah 7 hari tidak aktif.

Saat ini jika Supabase pause, error-nya kemungkinan generic. Perlu:

```dart
// Di sync service, detect error spesifik Supabase pause
Future<void> performSync() async {
  try {
    await supabase.from('products').select();
  } on PostgrestException catch (e) {
    if (e.code == '503' || e.message.contains('paused')) {
      // Tampilkan notifikasi yang user-friendly
      notifyUser(
        'Sinkronasi cloud tidak aktif. '
        'Data tetap aman di perangkat. '
        'Login ke Supabase dashboard untuk mengaktifkan kembali.'
      );
    } else {
      rethrow;
    }
  }
}
```

---

## 🟢 Nice to Have (Polish & Developer Experience)

### 9. CI/CD — Verifikasi Keystore Konsisten

**Lokasi:** `.github/workflows/`

Pastikan workflow build APK menggunakan keystore yang sama setiap kali (bukan debug key). Tambahkan keystore sebagai GitHub Secret:

```yaml
# .github/workflows/build.yml
- name: Setup Release Keystore
  run: |
    echo "${{ secrets.KEYSTORE_BASE64 }}" | base64 -d > android/app/release.keystore
  
- name: Build APK Release
  run: |
    flutter build apk --release \
      --dart-define=SUPABASE_URL=${{ secrets.SUPABASE_URL }} \
      --dart-define=SUPABASE_ANON_KEY=${{ secrets.SUPABASE_ANON_KEY }}
```

Secrets yang perlu ditambahkan di GitHub repo settings:
- `KEYSTORE_BASE64` — keystore file di-encode base64
- `KEY_ALIAS`
- `KEY_PASSWORD`
- `STORE_PASSWORD`
- `SUPABASE_URL`
- `SUPABASE_ANON_KEY`

---

### 10. Printer Thermal — Antrian Cetak

**Kondisi saat ini:** cetak langsung, gagal = hilang

**Perbaikan:** simpan antrian cetak ke SQLite jika printer tidak tersedia:

```dart
// Jika cetak gagal, simpan ke print_queue table di Drift
class PrintQueueEntry {
  final int id;
  final String receiptJson;
  final DateTime createdAt;
  final bool isPrinted;
}

// Background service cek antrian saat printer tersambung
void onPrinterConnected() {
  processPrintQueue(); // cetak semua yang tertunda
}
```

---

### 11. Dokumentasi Arsitektur di README

Tambahkan section di README yang menjelaskan struktur folder `lib/`:

```
lib/
├── core/               # Shared utilities, constants, theme
├── data/               # Repository implementations, data sources
│   ├── local/         # Drift database, DAOs
│   └── remote/        # Supabase sync service
├── domain/             # Entities, repository interfaces, use cases
└── presentation/       # UI, BLoC, screens, widgets
    ├── kasir/
    ├── produk/
    ├── laporan/
    └── settings/
```

Ini sangat membantu saat kembali ke codebase setelah 3+ bulan.

---

## Ringkasan Checklist

```
SEGERA (Security):
[ ] Hapus rokok_virgo_supabase.json dari repo
[ ] Implement PIN hashing (sha256)
[ ] Bersihkan file sampah di root

BULAN INI:
[ ] Unit test untuk kalkulasi bisnis
[ ] Dokumentasikan strategi conflict resolution
[ ] Graceful error saat Supabase auto-pause
[ ] Sync trigger saat koneksi kembali online

NEXT SPRINT:
[ ] Laporan laba rugi & produk terlaris
[ ] Export laporan ke PDF
[ ] CI/CD dengan keystore konsisten

SOMEDAY:
[ ] Print queue / antrian cetak offline
[ ] Dokumentasi arsitektur di README
[ ] Batas percobaan PIN + lockout
```

---

*Dokumen ini dibuat berdasarkan analisis repo `devtya/hend_kasir` — v1.4.10+24*
