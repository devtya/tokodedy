# Rencana Desain — Kasir Desktop Toko Dedy

Tanggal: 2026-07-28 · Status: disetujui (Bagian 1 & 2) · Cakupan: **layar Kasir dulu**

Dokumen ini menggantikan semua catatan desktop lama. Design system (warna, tipografi,
spacing) tetap mengikuti [DESIGN.md](../../../DESIGN.md) — dokumen ini hanya menambah
layout & interaksi khusus desktop.

## Konteks & keputusan hardware

- **Perangkat:** Windows, satu monitor lebar di meja kasir. Flutter Windows app.
- **Printer:** thermal ESC/POS via **USB** (bukan Bluetooth BLE — di Windows kurang stabil).
  Transport berbeda dari versi Android, tapi payload ESC/POS sama.
- **Scanner:** barcode USB *keyboard-wedge* — mengetik barcode lalu Enter. **Tidak** perlu
  dialog kamera; cukup satu field yang selalu fokus menangkap ketikan cepat + Enter.
- **Laci kas:** tersambung ke printer (RJ11). Terbuka via perintah kick ESC/POS
  `0x1B 0x70 0x00 0x19 0xFA` yang **sudah ada** di
  [bluetooth_printer_service.dart:337](../../../lib/data/services/bluetooth_printer_service.dart#L337)
  dan ikut terkirim tiap cetak struk. "Buka laci otomatis saat bayar" = efek samping cetak.
- **Input dominan:** scan barcode. Grid produk hanya cadangan untuk barang tanpa barcode.

## Bagian 1 — Layout inti: 2-panel "counter POS"

Satu layar penuh, tanpa pindah page saat transaksi (beda dari mobile yang buka CartPage
terpisah). Panel keranjang kanan **selalu terlihat**.

```
┌─────────────────────────────────────────────────────────────┐
│  Toko Dedy · Kasir        [Shift: Dedy]   [🖨 siap] [laci]   │  header tipis
├───────────────────────────────┬─────────────────────────────┤
│  [ 🔍 Scan / ketik barcode… ]  │   KERANJANG                 │
│   ↑ selalu fokus, tangkap Enter│  ┌───────────────────────┐  │
│                                │  │ Indomie Goreng   x2   │  │
│  [chips kategori]              │  │ @3.000        6.000 ✎ │  │
│  Grid produk (cadangan)        │  ├───────────────────────┤  │
│  ┌─────┐ ┌─────┐ ┌─────┐       │  │ Aqua 600ml      x1    │  │
│  │prod │ │prod │ │prod │       │  │ @4.000        4.000 ✎ │  │
│  └─────┘ └─────┘ └─────┘       │  └───────────────────────┘  │
│  ┌─────┐ ┌─────┐ ┌─────┐       │  Subtotal        10.000     │
│  │prod │ │prod │ │prod │       │  Diskon               0     │
│  └─────┘ └─────┘ └─────┘       │  ───────────────────────    │
│                                │  TOTAL          10.000      │  angka terbesar
│                                │  [ F9  BAYAR (Rp 10.000) ]  │  tombol besar hijau
└───────────────────────────────┴─────────────────────────────┘
   Kiri ~60% (input & pilih)          Kanan ~40% (keranjang, sticky)
```

- Total = elemen terbesar di layar (angka legibel = tujuan design system).
- Grid kiri: kartu produk padat, tap = tambah ke keranjang qty 1. Chips kategori di atas.
- **Ditolak:** meniru layout mobile (list + bottom bar + halaman keranjang terpisah) —
  buang ruang & bikin kasir bolak-balik pindah layar.

## Bagian 2 — Alur scan→bayar→laci & keyboard-first

**Alur transaksi:**

1. Scan → barcode + Enter ke field selalu-fokus → produk ketemu → masuk keranjang
   (satuan dasar, qty 1) → field auto-fokus lagi.
2. Scan barang sama lagi → qty baris itu +1 (bukan baris baru). Ubah qty/satuan/diskon
   lewat ✎ di baris keranjang.
3. Barcode tak ketemu → flash/bunyi merah + pesan, keranjang tak berubah.
4. **F9 / Bayar** → modal bayar: keypad angka + tombol cepat (Uang Pas · 20rb · 50rb ·
   100rb), kembalian live. Enter = konfirmasi.
5. Konfirmasi → simpan transaksi → **cetak struk** (kick laci ikut terkirim → laci
   terbuka) → flash hijau "Lunas, kembali Rp X" → transaksi baru otomatis siap.

**Laci tanpa cetak:** tombol **Buka Laci** di header mengirim perintah kick saja (koreksi
uang / printer mati). Mencegah kasir mencolek laci paksa.

**Keyboard shortcut:**

| Tombol | Aksi |
|--------|------|
| ketik langsung | masuk ke field barcode (selalu fokus) |
| **F9** / Enter di field kosong | Buka Bayar |
| **F2** | Fokus pencarian produk (grid) |
| **F4** | Simpan pending |
| **↑ / ↓** | Pilih baris keranjang |
| **+ / −** | Tambah/kurang qty baris terpilih |
| **Del** | Hapus baris terpilih |
| **Esc** | Tutup modal / batal |

**Status hardware di header:** status printer (`siap`/`putus`) + tombol Buka Laci.
Printer putus saat bayar → transaksi **tetap tersimpan**, muncul peringatan "struk gagal
cetak, laci tidak terbuka" + tombol cetak-ulang.

## Catatan implementasi (untuk fase plan berikutnya)

- Butuh abstraksi printer lintas-platform: Android=Bluetooth (existing), Windows=USB/ESC-POS.
  Payload `_buildEscPos` bisa dipakai ulang; hanya lapisan transport yang beda.
- Scanner keyboard-wedge = tidak perlu paket kamera di desktop; cukup `RawKeyboardListener` /
  autofocus `TextField` + deteksi Enter dan input cepat.
- Layar Kasir desktop = widget baru (`cashier_desktop_page.dart` atau responsif via
  `LayoutBuilder`), bukan mengubah `cashier_page.dart` mobile.
- Reuse: `CashierBloc`, `BuatTransaksi`, `ReceiptData`, `PrinterSettings` sudah ada.
