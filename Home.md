# Home Screen — Design Specification

Halaman utama (dashboard) aplikasi **hend_kasir**. Menampilkan ringkasan omzet harian, aksi cepat, peringatan stok menipis, dan transaksi terakhir.

---

## Struktur Layout

```
┌─────────────────────────────┐
│ Status Bar                  │
│ AppBar (hendkasir + notif)  │
│ Greeting + Store Badge      │
│ Omzet Card                  │
│ Aksi Cepat (horizontal)     │
│ Stok Menipis                │
│ Transaksi Terakhir          │
│ Bottom Navigation + FAB     │
└─────────────────────────────┘
```

---

## Spacing & Shape

| Token        | Value  | Dipakai pada                        |
|--------------|--------|-------------------------------------|
| margin       | 16px   | Padding horizontal konten           |
| gutter       | 8px    | Gap antar item list                 |
| radius-lg    | 20px   | Omzet card, card list               |
| radius-md    | 12px   | Aksi cepat icon, icon list, notif   |
| radius-full  | 9999px | Store badge, stok badge             |

---

## Komponen

### 1. AppBar
- Background: **transparent**, elevation: **0**, scrolledUnderElevation: **0**
- Kiri: label `hend_kasir` — font weight 700, tanpa underline
- Kanan: tombol notifikasi (icon bell) dengan dot indikator hijau

### 2. Greeting
- Judul: `Halo, {nama}! 👋` — font size 24px, weight 700
- Store badge: pill shape, dot animasi pulse + nama toko

### 3. Omzet Card
- Background: gradient hijau gelap
- Label uppercase: `OMZET HARI INI` + icon trend-up
- Nilai utama: font size 36px, weight 700, letter-spacing -0.02em
- 2 stat inner card: `Transaksi` dan `Item Terjual`
- Border radius: **20px**
- Border: 1px outline-variant

### 4. Aksi Cepat
- Horizontal scroll, 4 item default: Kasir · Laporan · Produk · Beli
- Icon container: 58×58px, radius **12px**, border 1px
- Label: uppercase, 11px, weight 500

| Item    | Warna Icon |
|---------|------------|
| Kasir   | Primary (hijau) |
| Laporan | Amber `#f59e0b` |
| Produk  | Blue |
| Beli    | Purple |

### 5. Stok Menipis
- Card list radius **20px**, border 1px
- Icon container merah (error tint)
- Badge: pill merah, `Sisa N`
- Row alternating: odd row pakai surface-low (dark) / surface (light)

### 6. Transaksi Terakhir
- Card list radius **20px**, border 1px
- Separator antar item: 1px border-bottom
- Icon container: primary tint
- Amount: primary color, weight 700

### 7. Bottom Navigation
- 4 item + 1 FAB di tengah
- FAB: 56×56px circle, background primary, glow shadow
- Active item: primary color icon + label

---

## 🌙 Dark Theme

Berdasarkan **High-Efficiency POS Design System**.

### Color Tokens

| Token                    | Hex       | Dipakai pada                          |
|--------------------------|-----------|---------------------------------------|
| `background`             | `#131314` | Latar utama                          |
| `surface-container`      | `#1f2020` | Card list, aksi cepat icon           |
| `surface-container-low`  | `#1b1c1c` | Bottom nav, row alternating          |
| `surface-container-lowest`| `#0d0e0e`| Stat inner card, omzet card ujung    |
| `surface-container-high` | `#292a2a` | Hover state                          |
| `outline-variant`        | `#3d4a3e` | Semua border 1px                     |
| `outline`                | `#869486` | Icon inactive, label inactive        |
| `on-surface`             | `#e4e2e2` | Teks utama                           |
| `on-surface-variant`     | `#bbcbbb` | Teks sekunder, label                 |
| `primary`                | `#54e98a` | Aksen utama, FAB, active state       |
| `on-primary`             | `#003919` | Icon dalam FAB                       |
| `primary-container`      | `#2ecc71` | Gradient omzet card                  |
| `error`                  | `#ffb4ab` | Badge stok menipis                   |
| `error-container`        | `#93000a` | Background error tint                |

### Primary Tint
```
rgba(84, 233, 138, 0.10)  → icon background, store badge
rgba(84, 233, 138, 0.18)  → aksi cepat active/focus state
```

### Omzet Card Gradient (Dark)
```
135deg → #1a4d2e → #0f3320 → #0d0e0e
```

### Typography
- Font family: **Roboto Flex**
- Display (omzet amount): 36px / weight 700 / letter-spacing -0.02em
- Headline: 24px / weight 700
- Title: 15px / weight 600
- Label uppercase: 12px / weight 500 / letter-spacing 0.05em
- Body: 13px / weight 400–500

---

## ☀️ Light Theme

Berdasarkan **Flutter ColorScheme.light** dari `app_theme.dart`.

### Color Tokens

| Token                | Hex / Value              | Dipakai pada                        |
|----------------------|--------------------------|-------------------------------------|
| `lightBackground`    | `#F7F9F7`                | Latar utama                        |
| `lightSurface`       | `#FFFFFF`                | Card, bottom nav                   |
| `lightBorder`        | `#E5EAE5`                | Border semua card & input (1.5px)  |
| `lightDivider`       | `#EEEEEE`                | Separator antar item dalam card    |
| `lightText`          | `#1A1A1A`                | Teks utama                         |
| `lightGrey`          | `#9E9E9E`                | Teks sekunder, label, icon inactive|
| `primary`            | `#22c55e`                | Aksen utama, FAB, active state     |
| `primaryContainer`   | `#D5F5E3`                | Badge store, icon tint background  |
| `error`              | `#ef4444`                | Badge stok menipis                 |

### Primary Tint
```
rgba(34, 197, 94, 0.10)  → icon background, store badge
rgba(34, 197, 94, 0.18)  → aksi cepat hover
```

### Omzet Card Gradient (Light)
```
135deg → #22c55e → #16a34a → #14532d
```

### Typography
- Font family: **Plus Jakarta Sans**
- Display (omzet amount): 32px / weight 800 / letter-spacing -1px
- Headline: 22px / weight 800
- Title: 15px / weight 800
- Label uppercase: 12px / weight 700 / letter-spacing 0.06em
- Body: 13px / weight 500–700

### Card Theme (light)
```
elevation: 0
border-radius: 14px (list card)
border: 1.5px solid lightBorder
```

> Note: Light theme pakai border **1.5px** vs dark theme **1px**,
> dan border-radius list card **14px** vs dark **20px**
> agar terasa lebih clean & solid di atas background putih.

---

## Perbedaan Dark vs Light

| Aspek              | Dark                    | Light                   |
|--------------------|-------------------------|-------------------------|
| Font               | Roboto Flex             | Plus Jakarta Sans       |
| Primary            | `#54e98a`               | `#22c55e`               |
| Border width       | 1px                     | 1.5px                   |
| Card radius (list) | 20px                    | 14px                    |
| Row alternating    | ✅ surface-low           | ❌ tidak                |
| Badge shape        | pill (rounded-full)     | rounded (8px)           |
| Omzet gradient     | gelap → hitam           | hijau terang → tua      |
| Error color        | `#ffb4ab` (soft)        | `#ef4444` (vivid)       |
