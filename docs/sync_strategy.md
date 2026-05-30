# Sync Strategy — Last-Write-Wins (LWW)

## Architecture

```
┌─────────────────────┐         ┌─────────────────────┐
│   Device A (Drift)  │         │   Device B (Drift)  │
│       (offline)     │         │       (offline)     │
└────────┬────────────┘         └────────┬────────────┘
         │ upsert()                       │ upsert()
         ▼                                ▼
┌─────────────────────────────────────────────┐
│            Supabase (Source of Truth)        │
│   • Triggers auto-update updated_at=NOW()   │
│   • RLS per-toko_id                         │
│   • LWW via upsert(onConflict: 'id')        │
└─────────────────────────────────────────────┘
         │ pull(updated_at > lastSync)
         ▼
┌─────────────────────┐
│   Device A (Drift)  │
│  insertOnConflictUpdate
└─────────────────────┘
```

## Conflict Resolution

### Strategy: Last-Write-Wins (LWW) via `updated_at`

When two devices modify the same record offline, the **last one to sync** wins. The entire row is replaced — there is no field-level merge.

### How it works

1. **Write**: Every `upsert()` to Supabase injects `updated_at` (client timestamp).
2. **Server trigger**: `BEFORE UPDATE` trigger on every table overwrites `updated_at = NOW()` — ensures the server timestamp is the authoritative one.
3. **Read (pull)**: `SELECT ... WHERE updated_at >= lastSync` — only fetches changes since last pull.
4. **Local apply**: `insertOnConflictUpdate()` — Drift replaces the entire row, no merge logic.

### Tables with `updated_at` trigger

| Table | Has Trigger |
|-------|-------------|
| `produk` | ✅ |
| `satuan_produk` | ✅ |
| `supplier` | ✅ |
| `supplier_products` | ✅ |
| `transaksi` | ✅ |
| `hutang_piutang` | ✅ |
| `pembelian` | ✅ |
| `pending_order` | ✅ |
| `pending_pembelian` | ✅ |
| `toko` | ✅ |

### Append-only tables (no conflict possible)

These tables are never updated after creation. Pull uses `created_at` instead of `updated_at`:

- `item_transaksi`
- `item_pembelian`
- `riwayat_stok`
- `notifikasi`
- `pending_order_item`
- `pending_pembelian_item`

## Offline Queue

When offline, operations are queued to `pending_sync_queue_table`:

- **Upsert**: Stored as JSON payload, retried on `flushQueue()`.
- **Delete**: Stored with record ID, retried on `flushQueue()`.
- **Retry**: On `flushQueue()`, each item is attempted once. Failures stay in queue for the next cycle.

## Initial Sync (Cloud Recovery)

On a fresh install / new device:

1. `performInitialSync()` downloads **all** rows for the toko from Supabase.
2. Data is written to Drift via `insertOnConflictUpdate()`.
3. Flag `initial_sync_done_v2` is set to `true`.
4. Subsequent syncs use incremental `pull()`.

## Edge Cases

| Scenario | Behavior |
|----------|----------|
| Device A edits offline, Device B edits offline | Last to sync wins (full row replace) |
| Device A edits `nama`, Device B edits `harga` | Last sync wins — one field overwrites the other |
| Device A creates record, Device B creates same ID | Second upsert overwrites (use UUIDs to avoid) |
| Record deleted on Device A while offline | Delete queued. If B edited it while offline, sync order determines outcome |
| Supabase auto-paused | `upsert()` fails silently, queued for retry. User sees "Cloud tidak aktif" notification |
