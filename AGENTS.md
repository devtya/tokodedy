# AGENTS.md — tokodedy

## Project Overview

- **What it is**: **tokodedy** is a single-store Android **POS / cashier app** for a *toko sembako* (grocery/convenience store). It handles sales (kasir), inventory (produk & stok), purchasing (pembelian & purchase orders), debts (hutang/piutang), online orders, reports, and thermal-printer receipts. It works **offline-first** and syncs to Supabase when online.
- **Origin**: Forked from `hend_kasir` (a multi-store app) and refactored into a **single-store** app. Any remaining multi-store / `tokoId` concepts in old notes are obsolete — see Development Guidelines.
- **Tech stack**: Flutter (Dart SDK `^3.11.5`), Drift (SQLite ORM), Supabase (`supabase_flutter`), flutter_bloc + equatable, get_it + injectable (DI), slang (i18n), Firebase Cloud Messaging, Workmanager (background sync).
- **Platform target**: **Android (primary)**. Windows desktop support is planned as **Phase 2** — same codebase via Flutter multiplatform, intended to replace the separate `TokodedyPC` project.
- **Current version**: `1.0.3+4` (from `pubspec.yaml`).

## Related Projects

- **tokodedypc** (`d:\PROJECT\TOKO DEDY\tokodedypc`): Existing Windows Desktop fork. Slated to be superseded by Phase 2 of this project.
- **DedyStore** (`d:\PROJECT\TOKO DEDY\dedystore`): Next.js online storefront for buyers, sharing the same Supabase backend (source of the `online_orders` flow).

## Architecture

- **Pattern**: Clean Architecture — `lib/data/` (Drift tables, models, repository impls, services), `lib/domain/` (entities, repository interfaces, usecases), `lib/presentation/` (blocs, pages, widgets).
- **State management**: `flutter_bloc` (`Bloc<Event, State>`; events in `*_event.dart`, states in `*_state.dart`). `ThemeCubit` for theming.
- **Database**: Drift (SQLite) — **offline-first, local source of truth**. Connection via `LazyDatabase` → `NativeDatabase` (file `tokodedy.db` in app documents dir).
- **Backend**: Supabase — sync target, RLS-based tenant/auth isolation, and Realtime for incoming online orders.
- **DI**: `get_it` + `injectable`. Central `sl` (GetIt) in `lib/core/di/injection.dart`; `initDependencies()` called once in `main()` before `runApp`. BLoCs registered as `factory`, repos/usecases as `lazySingleton`.

```
lib/
  core/          config.dart, constants/, di/, errors/, services/, theme/, utils/
  data/          database/ (tables + AppDatabase), models/, repositories/, services/
  domain/        entities/, repositories/ (interfaces), usecases/
  presentation/  blocs/, pages/shared/, widgets/
  i18n/          slang localization (strings.i18n.json → strings.g.dart)
```

## Database Schema

- **Current `schemaVersion`**: **7** (`lib/data/database/app_database.dart`).
- **Registered tables**: **27** (in `@DriftDatabase(tables: [...])`).

| Table | Stores |
|-------|--------|
| `UserTable` | Local user profile cache (id = Supabase Auth UUID, nama, role) |
| `ProdukTable` | Products (nama, barcode, harga beli/jual, stok, stok minimum, kategori, satuan, image, isArchived) |
| `SatuanProdukTable` | Multi-unit definitions per product (nama, konversi, harga beli/jual); unique (produk_id, nama) |
| `RiwayatPerubahanProdukTable` | Audit log of product field changes |
| `SupplierTable` | Suppliers (nama, telepon, alamat) |
| `SupplierProductsTable` | Supplier↔product price mapping |
| `TransaksiTable` | Sales transactions header (total, bayar, kembalian, status) |
| `ItemTransaksiTable` | Sales line items (produk, jumlah, harga satuan, subtotal) |
| `HutangPiutangTable` | Debts/receivables tied to transactions |
| `RiwayatStokTable` | Stock movement history (tipe, jumlah, keterangan) |
| `PembelianTable` | Purchase (goods-in) header |
| `ItemPembelianTable` | Purchase line items (incl. satuanId, konversi) |
| `PurchaseOrderTable` | Purchase orders to suppliers (status, total, notes) |
| `PurchaseOrderItemTable` | PO line items (qtyPesan, qtyTerima, satuanId, konversi) |
| `PendingOrderTable` | Draft/held customer orders header |
| `PendingOrderItemTable` | Draft order line items (incl. diskon) |
| `PendingPembelianTable` | Held/draft purchases header (PPN, diskon) |
| `PendingPembelianItemTable` | Held purchase line items (harga lama/baru, satuanId, konversi) |
| `NotifikasiTable` | In-app notifications (judul, pesan, tipe, isRead) |
| `PendingSyncQueueTable` | Offline sync outbox (targetTable, operation, recordId, payload) |
| `RiwayatHargaTable` | Price-change history for products |
| `LocalAuthTable` | Local PIN/biometric auth (pinHash, pinLength, pinSalt, failedAttempts, lockoutUntil) |
| `OnlineCustomerTable` | Online-store customers |
| `OnlineOrderTable` | Online orders header (status, total, pengiriman) |
| `OnlineOrderItemTable` | Online order line items (satuanId, konversi, isUnavailable) |
| `KasHarianTable` | Daily cash balance (tanggal, modalAwal, saldoAkhir, isClosed) |
| `PengeluaranOperasionalTable` | Operational expenses linked to kas_harian (deskripsi, jumlah, kategori) |

> Note: `sync_record_table.dart` exists in `tables/` but is **NOT registered** in `@DriftDatabase` — it is dead V1 leftover and should not be relied on.

**Migration history** (`onUpgrade` in `app_database.dart`):
- **v1**: baseline (DB reset from V1/hend_kasir era).
- **v2**: add `produk.isArchived`; create `riwayat_perubahan_produk_table`.
- **v3**: add `namaProduk` to `item_pembelian`, `item_transaksi`, `online_order_item` (denormalized snapshot).
- **v4**: create unique index `idx_satuan_produk_unique (produk_id, nama)`.
- **v5**: add `local_auth.pinLength`.
- **v6**: add `local_auth.pinSalt` (PBKDF2 salt).
- **v7**: create `kas_harian_table` and `pengeluaran_operasional_table`.

> **Rule**: any Drift table change (add/remove/alter column) requires running code generation (`dart run build_runner build -d`), bumping `schemaVersion`, and adding an `onUpgrade` migration step (e.g. `m.addColumn(...)`) to avoid `SqliteException` on app update.

## Sync Architecture

Implemented in `lib/data/services/supabase_sync_service.dart` (direct per-table upsert; no JSON blobs / sync_record mapping).

- **Write path**: write to Drift first, then `upsert(table, data)` / `delete(table, id)`. If online with a valid session → direct Supabase upsert/delete. Otherwise (offline or invalid session) → enqueue into `pending_sync_queue_table`.
- **pending_sync_queue**: each row holds `targetTable`, `operation` (`upsert`/`delete`), `recordId`, and JSON `payload`. `flushQueue()` replays entries when online; a `_retryCount` (max **5**) is tracked (stripped from payload before upsert), after which the item is dropped.
- **pull()**: pulls changes since a `last_sync_v2` cursor (SharedPreferences). Tables in `_pullOrder` are filtered by `updated_at >= last_sync`; append-only tables (`_appendOnlyTables` — includes `riwayat_harga`) by `created_at >= last_sync`. The cursor advances only per successfully-pulled table (not globally), preventing silent data-loss. `performInitialSync()` does a full download for fresh installs. `online_order_items` is back-filled via its parent `online_orders` pull.
- **Timestamps**: `upsert()` writes `updated_at`/`created_at` as `DateTime.now().toUtc().toIso8601String()`; `last_sync` is stored/compared in UTC.
- **Session/JWT handling**: `_ensureValidSession()` — if no in-memory session, tries to recover from `FlutterSecureStorage` backup; if the session expires within 5 minutes, calls `refreshSession()`; on unrecoverable failure it enqueues the write and inserts a deduped (24h) `SYNC_ERROR` notification prompting re-login.
- **Realtime**: subscribes to `online_orders` INSERT (`initRealtimeListeners()`); on a new pending/shipped order it pulls order + customer + items (with retry) and inserts a local `ORDER` notification. A periodic fallback poll (`startPeriodicOrderPolling`) and `pullOnlineOrdersForce()` also exist.
- **Workmanager**: registers `syncSupabaseTask` every **15 minutes** (network-connected constraint) → runs `pullOnlineOrdersForce()` + `flushQueue()`.

## Authentication & Security

- **Login flow**: Supabase **email/password** (online). Password is never stored locally; the profile is cached to `UserTable` and the session token backed up in `FlutterSecureStorage` for offline reopen (*cloud recovery login*).
- **PIN flow**: after login, a local **PIN gate** (`_PinGate` in `main.dart`) requires a PIN (setup if unset, verify otherwise). Optional biometric unlock via `local_auth`.
- **PIN hash method**: **PBKDF2 + per-user random salt** (`LocalAuthRepositoryImpl._hashPin` via `compute()` isolate). Lockout: 5 failed attempts → 30-second lockout (`failedAttempts` / `lockoutUntil`).
- **RBAC**: roles `owner` and `kasir`. Owner has full access (user management, cost/margin visibility, product/purchase management). Kasir is restricted — e.g. cashier flow forces `hargaPokok = 0` so margins aren't exposed. Tenant/data isolation is enforced by **Supabase RLS**, not by client-side filtering.

## Key Features

- **Kasir / Transaksi** (`cashier_page.dart`, `transaksi_*`): sales with multi-unit, discounts, cash/change, receipt print/confirm dialog. Stok UI disable for kasir (can't add products with 0 stock).
- **Produk** (`produk_page.dart`, `produk_form_page.dart`): products with multi-satuan, auto HPP conversion, min-stock, barcode scan, price-change validation.
- **Stok** (`stok_page.dart`, `riwayat_stok`): stock levels and movement history.
- **Pembelian** (`pembelian_form_page.dart`, pending): goods-in with PPN, global discount, per-unit cost update, pending drafts. PriceValidationDialog with 3 choices (update harga jual / skip / batal), atomik dalam 1 transaksi.
- **Purchase Order** (`purchase_order_*`): PO create/receive; supports multiple concurrent POs from the same supplier — always key by `poId`. Auto PO from stok minimum (icon magic wand).
- **Online Order** (`online_order_page.dart`): orders from DedyStore via Supabase Realtime + notifications.
- **Hutang/Piutang** (`hutang_*`): debt tracking linked to transactions.
- **Laporan** (`laporan_page.dart`): sales/finance reports (fl_chart) with tabs Ringkasan, Arus Kas, Hutang, Detail, Margin. Margin tab shows % and total profit per product.
- **Notifikasi** (`notifikasi_page.dart`): in-app alerts (orders, sync errors, reorder alert for low stock).
- **Settings** (`settings_page.dart`): cloud sync, printer, cleanup utilities, PIN settings.
- **Printer** (`printer_settings_page.dart`, `bluetooth_printer_service.dart`): Bluetooth-only ESC/POS thermal receipts, cash-drawer kick. Network printer removed.
- **Stok Opname** (`stok_opname_page.dart`): stock correction (stok fisik vs sistem), tipe 'koreksi' di riwayat_stok.
- **Kas Harian** (`kas_harian_page.dart`): daily cash management — modal awal, pengeluaran operasional, saldo akhir.
- **Update Service** (`update_service.dart`): in-app APK update check via GitHub releases (`devtya/tokodedy`).

## Known Issues & Tech Debt

Carried-over fixes from the old log have been pruned once verified fixed. Remaining/known items:

### Sync
- **20 empty `catch (_) {}` blocks** swallow Supabase read/pull errors with no logging or user feedback → failures invisible in production.
- **Realtime resubscribe may create duplicate channels** — on subscription error it resets `_isRealtimeInitialized` and re-inits without tearing down the old channel → possible duplicate notifications.

### Correctness / consistency
- **Mixed `DateTime.now()` (local) vs UTC** across ~66 call sites — locally created rows (e.g. notifikasi `createdAt`) use local time while pulled rows are UTC, risking off-by-offset (WIB +7) errors in date-range queries and "last N days" filters.
- Docs/version drift historically: keep this file, `schemaVersion`, and `pubspec.yaml` version in sync going forward.

### Access control
- **RBAC pembelian**: kasir currently can input pembelian (pembelian_form_page) — only admin/owner should. Needs role-based gating.

## Development Guidelines

- **Offline-first**: always write to Drift first, then push/enqueue to Supabase. Never block the UI on a network write.
- **Single-store**: **do not filter by `toko_id` in Dart** — this is a single-store app; tenant isolation is handled by **Supabase RLS**. There is no `TokoService`/`tokoId` in the current schema.
- **Timestamps**: use `DateTime.now().toUtc()` consistently for anything stored or synced.
- **Error handling**: never use empty `catch (_) {}` — at minimum log the error (and prefer surfacing sync failures to the user / a sync log).
- **Debug output**: wrap `debugPrint` in `kDebugMode` (avoid shipping verbose auth/sync logs).
- **Database changes**: run `dart run build_runner build -d`, bump `schemaVersion`, add an `onUpgrade` migration.
- **i18n**: no hardcoded UI strings — register text in `lib/i18n/strings.i18n.json` and run `dart run slang`.
- **Purchase Orders**: multiple active POs from the same supplier can coexist — always identify by `poId`, never by `supplierId` alone.
- **Phase 2 (Windows) awareness**: when adding features, prefer cross-platform plugins over Android-only ones where a viable alternative exists (e.g. printing, file access), to ease the desktop port.
- **Theme-aware colors**: never hardcode `Colors.white`, `Colors.black`, `Colors.grey.shade*`, `Colors.green.shade*`, `Colors.red.shade*`, etc. Use `Theme.of(context).colorScheme.*` (e.g. `surface`, `onSurface`, `primary`, `error`, `outline`, `surfaceContainerHighest`) or `AppTheme.*` constants (e.g. `AppTheme.primary`, `AppTheme.warning`). For box shadows, `Colors.black.withValues(alpha: ...)` is acceptable. Prefer `.withValues(alpha:)` over `.withOpacity()`.
- **Printer**: Bluetooth-only. Network printer has been removed. No fallback to HTTP/network print server.

## Roadmap

- **Phase 1 (current)**: Stabilize the Android app — fix the critical sync bugs (cursor advance on error, error visibility, payload retry leak, online_order_items back-fill), harden PIN security, and standardize UTC timestamps.
- **Phase 2 (future)**: Extend to **Windows desktop** using Flutter multiplatform, replacing `TokodedyPC`. Single codebase with platform-adaptive UI where needed.

#### Kasir Input Design (Windows)
Karena Windows pakai keyboard fisik + barcode scanner USB/Serial,
input kasir menggunakan format berikut:

**Format input field scan:**
- `[barcode]` → qty: 1 (default)
- `[qty]*[barcode]` → qty sesuai angka sebelum `*`
- Contoh: `5901234123457` → qty 1
- Contoh: `5*5901234123457` → qty 5
- Contoh: `12*5901234123457` → qty 12
- Jika qty = 0 atau tidak valid → fallback ke qty 1

**Parse logic:**
```dart
void parseKasirInput(String input) {
  if (input.contains('*')) {
    final parts = input.split('*');
    final qty = int.tryParse(parts[0]) ?? 1;
    final barcode = parts[1].trim();
    addToCart(barcode, qty: qty > 0 ? qty : 1);
  } else {
    addToCart(input.trim(), qty: 1);
  }
}
```

**Alasan desain:**
- Barcode bisa berawalan angka apapun → tidak bisa pakai prefix angka saja
- `*` tidak mungkin ada dalam barcode standar (EAN-13, Code128, QR)
- Pattern ini umum di aplikasi kasir desktop (iREAP, dll)

**Printer Windows:**
- Pakai USB/kabel langsung (bukan Bluetooth/Network)
- Tidak perlu discovery device

## Environment Setup

1. Copy `.env.example` to `.env`:
   cp .env.example .env

2. Fill in your values in `.env`

3. Run the app:
   run.bat          ← Windows (development)
   build_apk.bat    ← Windows (build release APK)
   
   Or manually:
   flutter run --dart-define-from-file=.env
   flutter build apk --release --dart-define-from-file=.env

## Environment Variables
| Variable | Required | Description |
|---|---|---|
| GEMINI_API_KEY | Yes (AI features) | From aistudio.google.com |
| SUPABASE_URL | No | Supabase project URL |
| SUPABASE_ANON_KEY | No | Supabase anon key |

## Key Commands

| Command | When |
|---------|------|
| `flutter analyze` | Lint + typecheck. Run before committing. |
| `dart run build_runner build -d` | After any Drift table / injectable change. Regenerates `*.g.dart` / `injection.config.dart`. |
| `dart run slang` | After editing `strings.i18n.json`. |
| `flutter run --dart-define=GEMINI_API_KEY=your_key` | Debug run with Supabase sync and AI Assistant (config in `lib/core/config.dart`). |
| `flutter build apk --release --dart-define=GEMINI_API_KEY=your_key` | Release APK. |
| `flutter test` | Run tests. |
| `npx -y -p @google/design.md designmd lint DESIGN.md` | Validate the design system after editing `DESIGN.md` or `app_theme.dart`. Note: the `designmd` bin is required — `npx @google/design.md` exits 0 without running on Windows. |

## Agent Behavior Rules

- **UI work**: read `DESIGN.md` before changing any widget's colors, typography, spacing, or radii. It documents the design system defined in `lib/core/theme/app_theme.dart`. Never hardcode a hex value that isn't a token there.
- **Ambiguity**: if a request is unclear (e.g. "fix this error"), ask where (which page/menu) and what the error is before changing code.
- **Before changing code**: confirm with the user and explain why the change is needed and its impact.
- **Commits**: always ask for explicit confirmation before committing. Never commit without approval.
