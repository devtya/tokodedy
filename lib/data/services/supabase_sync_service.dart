import 'dart:convert';
import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:drift/drift.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:uuid/uuid.dart';

import '../database/app_database.dart';

import 'package:injectable/injectable.dart';

/// Sync service baru — direct upsert per-tabel ke Supabase.
/// Tidak ada lagi blob JSON atau sync_record_table.
/// Strategi:
///   - Write: tulis ke Drift lokal dulu, lalu upsert ke Supabase.
///     Jika offline → antri di pending_sync_queue_table.
///   - Read: pull dari Supabase berdasarkan updated_at > lastSync.
///   - Conflict: last-write-wins via updated_at.
@lazySingleton
class SupabaseSyncService {
  final AppDatabase _db;
  final SupabaseClient _supabase;
  final SharedPreferences _prefs;
  final _uuid = const Uuid();

  final _onlineOrderEventController = StreamController<void>.broadcast();
  Stream<void> get onOnlineOrderReceived => _onlineOrderEventController.stream;

  /// Trigger notifikasi ke listeners bahwa ada order online baru
  void notifyOnlineOrderReceived() => _onlineOrderEventController.add(null);

  /// Periodic polling timer untuk auto-refresh online orders (fallback)
  Timer? _orderPollingTimer;

  /// Mulai periodic polling online orders setiap [interval].
  /// Berguna sebagai fallback jika Realtime subscription gagal.
  void startPeriodicOrderPolling({Duration interval = const Duration(seconds: 30)}) {
    _orderPollingTimer?.cancel();
    _orderPollingTimer = Timer.periodic(interval, (_) async {
      try {
        await pullOnlineOrdersForce();
        notifyOnlineOrderReceived();
        if (kDebugMode) debugPrint('[Polling] Online orders refreshed');
      } catch (e) {
        if (kDebugMode) debugPrint('[Polling] Gagal refresh online orders: $e');
      }
    });
  }

  /// Hentikan periodic polling
  void stopPeriodicOrderPolling() {
    _orderPollingTimer?.cancel();
    _orderPollingTimer = null;
  }

  static const _lastSyncKey = 'last_sync_v2';

  SupabaseSyncService({
    required AppDatabase db,
    required SupabaseClient supabase,
    required SharedPreferences prefs,
  })  : _db = db,
        _supabase = supabase,
        _prefs = prefs;

  // ─────────────────────────────────────────────────
  // PUBLIC API
  // ─────────────────────────────────────────────────

  /// Generate UUID baru untuk record yang akan dibuat
  String generateId() => _uuid.v4();

  /// Cek apakah ada koneksi internet
  Future<bool> get isOnline async {
    final result = await Connectivity().checkConnectivity();
    return !result.contains(ConnectivityResult.none) && result.isNotEmpty;
  }

  /// Pastikan session Supabase valid, refresh jika perlu
  Future<bool> _ensureValidSession() async {
    try {
      final session = _supabase.auth.currentSession;

      if (session == null) {
        if (kDebugMode) debugPrint('[Sync] currentSession null — mencoba recover dari backup...');
        try {
          const storage = FlutterSecureStorage();
          final stored = await storage.read(key: 'supabase_session_backup');
          if (stored != null && stored.isNotEmpty) {
            final recovered = await _supabase.auth.recoverSession(stored);
            if (recovered.session != null) {
              if (kDebugMode) debugPrint('[Sync] Session BERHASIL di-recover dari backup');
              return true;
            }
          } else {
            if (kDebugMode) debugPrint('[Sync] Tidak ada backup session');
          }
        } catch (recoverError) {
          if (kDebugMode) debugPrint('[Sync] recoverSession gagal: $recoverError');
        }

        if (kDebugMode) debugPrint('[Sync] No Supabase session — akan antri');
        await _insertSessionExpiredNotification();
        return false;
      }

      // Cek apakah session expired atau mendekati expired (dalam 5 menit)
      final expiresAt = session.expiresAt;
      if (expiresAt != null) {
        final expiry = DateTime.fromMillisecondsSinceEpoch(expiresAt * 1000);
        final fiveMinFromNow = DateTime.now().add(const Duration(minutes: 5));
        if (expiry.isBefore(fiveMinFromNow)) {
          if (kDebugMode) debugPrint('[Sync] Session mendekati expired, mencoba refresh...');
          final refreshed = await _supabase.auth.refreshSession();
          if (refreshed.session != null) {
            if (kDebugMode) debugPrint('[Sync] Session berhasil di-refresh');
            return true;
          }
          if (kDebugMode) debugPrint('[Sync] Gagal refresh session');
          return false;
        }
      }
      return true;
    } catch (e) {
      if (kDebugMode) debugPrint('[Sync] Session check error: $e');
      return false;
    }
  }

  /// Buat notifikasi lokal jika session expired dan tidak bisa di-recover
  Future<void> _insertSessionExpiredNotification() async {
    try {
      // Hindari spam — cek apakah notifikasi serupa sudah ada dalam 24 jam
      final existing = await (_db.select(_db.notifikasiTable)
        ..where((t) => t.tipe.equals('SYNC_ERROR'))
        ..where((t) => t.createdAt.isBiggerThanValue(
          DateTime.now().subtract(const Duration(hours: 24))))
      ).get();

      if (existing.isNotEmpty) return;

      await _db.into(_db.notifikasiTable).insert(NotifikasiTableCompanion.insert(
        id: _uuid.v4(),
        judul: 'Sinkronisasi Cloud Terputus',
        pesan: 'Session Supabase telah berakhir. Buka Pengaturan → Sinkronisasi Cloud → '
            'login ulang dengan email & password untuk mengaktifkan sync kembali.',
        tipe: const Value('SYNC_ERROR'),
        createdAt: Value(DateTime.now().toUtc()),
      ));
    } catch (e) {
      if (kDebugMode) debugPrint('[SyncService] insertSessionExpiredNotification error: $e');
    }
  }

  /// Push: upsert record ke Supabase atau antri jika offline
  Future<void> upsert(String tableName, Map<String, dynamic> data) async {
    // Inject timestamp agar proses pull() di device lain bisa mendeteksi perubahan
    final now = DateTime.now().toUtc().toIso8601String();
    if (_pullOrder.contains(tableName)) {
      data['updated_at'] = now;
    } else if (_appendOnlyTables.contains(tableName)) {
      data['created_at'] ??= now;
    }

    if (await isOnline) {
      final sessionValid = await _ensureValidSession();
      if (!sessionValid) {
        if (kDebugMode) debugPrint('[Sync] Session invalid, enqueuing upsert: $tableName ${data['id']}');
        await _enqueue(tableName, 'upsert', data['id'] as String, data);
        return;
      }

      try {
        await _supabase.from(tableName).upsert(data, onConflict: 'id');
        if (kDebugMode) debugPrint('Supabase sync upsert success: $tableName ${data['id']}');
        return;
      } catch (e) {
        if (kDebugMode) debugPrint('Supabase sync upsert failed for $tableName ${data['id']}: $e');
        // Jika gagal, antri
      }
    }
    // Offline → antri
    if (kDebugMode) debugPrint('Supabase offline, enqueuing upsert: $tableName ${data['id']}');
    await _enqueue(tableName, 'upsert', data['id'] as String, data);
  }

  /// Delete: hapus record dari Supabase atau antri jika offline
  Future<void> delete(String tableName, String id) async {
    if (await isOnline) {
      final sessionValid = await _ensureValidSession();
      if (!sessionValid) {
        if (kDebugMode) debugPrint('[Sync] Session invalid, enqueuing delete: $tableName $id');
        await _enqueue(tableName, 'delete', id, {'id': id});
        return;
      }

      try {
        await _supabase.from(tableName).delete().eq('id', id);
        if (kDebugMode) debugPrint('Supabase sync delete success: $tableName $id');
        return;
      } catch (e) {
        if (kDebugMode) debugPrint('Supabase sync delete failed for $tableName $id: $e');
        // Jika gagal, antri
      }
    }
    // Offline → antri
    if (kDebugMode) debugPrint('Supabase offline, enqueuing delete: $tableName $id');
    await _enqueue(tableName, 'delete', id, {'id': id});
  }

  /// Pull: download perubahan dari Supabase sejak lastSync
  Future<List<String>> pull({
    void Function(String table, int count)? onTablePulled,
    bool force = false,
  }) async {
    final raw = _prefs.getString(_lastSyncKey) ?? '1970-01-01T00:00:00Z';
    final lastSync = (!raw.contains('Z') && !raw.contains('+'))
        ? '1970-01-01T00:00:00Z'
        : raw;
    final pulledTables = <String>[];

    bool allSuccess = true;

    for (final table in _pullOrder) {
      try {
        dynamic query = _supabase.from(table).select();
        if (force) {
          query = query.order('created_at');
        } else {
          query = query.gte('updated_at', lastSync).order('updated_at');
        }
        final rows = await query;

        if ((rows as List).isEmpty) continue;

        await _applyPulledRows(table, rows.cast<Map<String, dynamic>>());
        pulledTables.add(table);
        onTablePulled?.call(table, rows.length);
      } catch (e, stack) {
        if (kDebugMode) debugPrint('[SyncService] pull error on $table: $e\n$stack');
        allSuccess = false;
      }
    }

    // Pull tabel tanpa updated_at (append-only)
    for (final table in _appendOnlyTables) {
      try {
        dynamic query = _supabase.from(table).select();
        if (force) {
          query = query.order('created_at');
        } else {
          query = query.gte('created_at', lastSync).order('created_at');
        }
        final rows = await query;

        if ((rows as List).isEmpty) continue;
        await _applyPulledRows(table, rows.cast<Map<String, dynamic>>());
        pulledTables.add(table);
        onTablePulled?.call(table, rows.length);
      } catch (e, stack) {
        if (kDebugMode) debugPrint('[SyncService] pull error on $table: $e\n$stack');
        allSuccess = false;
      }
    }

    // Back-fill online_order_items — skipped by main loop because the table
    // has no created_at/updated_at column for date-range filtering.
    try {
      final recentOrders = await _supabase
          .from('online_orders')
          .select('id')
          .gte('updated_at', lastSync);
      final orderIds = (recentOrders as List)
          .map((o) => (o as Map<String, dynamic>)['id'] as String)
          .toList();
      for (var i = 0; i < orderIds.length; i += 100) {
        final chunk = orderIds.skip(i).take(100).toList();
        final items = await _supabase
            .from('online_order_items')
            .select()
            .inFilter('online_order_id', chunk);
        if ((items as List).isNotEmpty) {
          await _applyPulledRows('online_order_items', items.cast<Map<String, dynamic>>());
        }
      }
    } catch (e, stack) {
      if (kDebugMode) debugPrint('[SyncService] pull error on online_order_items backfill: $e\n$stack');
      allSuccess = false;
    }

    if (allSuccess) {
      await _prefs.setString(_lastSyncKey, DateTime.now().toUtc().toIso8601String());
    } else {
      if (kDebugMode) debugPrint('[SyncService] pull() completed with errors — last_sync NOT advanced');
    }
    return pulledTables;
  }

  bool _isRealtimeInitialized = false;
  RealtimeChannel? _realtimeChannel;

  /// Initialize realtime listener for Supabase
  void initRealtimeListeners() {
    if (_isRealtimeInitialized) return;
    _isRealtimeInitialized = true;

    if (kDebugMode) debugPrint('[Realtime] Initiating subscription...');

    _realtimeChannel = _supabase
        .channel('public:online_orders')
        .onPostgresChanges(
            event: PostgresChangeEvent.insert,
            schema: 'public',
            table: 'online_orders',
            callback: (payload) async {
              final newRecord = payload.newRecord;
              if (kDebugMode) debugPrint('[Realtime] INSERT detected: ${newRecord['id']} status=${newRecord['status']}');
              if (newRecord['status'] == 'pending' || newRecord['status'] == 'shipped') {
                final orderId = newRecord['id'] as String;
                final customerId = newRecord['customer_id'] as String;
                final totalHarga = newRecord['total_harga'];

                // Jeda awal: beri waktu agar app pelanggan selesai insert semua item ke Supabase
                // Dikurangi dari 1 menit menjadi 3 detik agar kasir cepat menerima notifikasi
                await Future.delayed(const Duration(seconds: 3));

                // Pull data order & customer dulu
                await pull();

                // Retry loop: pastikan items sudah masuk ke Supabase sebelum notify kasir
                // Max 10 percobaan × 10 detik = ~100 detik total worst case
                List<Map<String, dynamic>> fetchedItems = [];
                const maxRetries = 10;
                const retryDelay = Duration(seconds: 10);

                for (int attempt = 1; attempt <= maxRetries; attempt++) {
                  try {
                    final result = await _supabase
                        .from('online_order_items')
                        .select()
                        .eq('online_order_id', orderId);
                    fetchedItems = (result as List).cast<Map<String, dynamic>>();
                    if (kDebugMode) debugPrint('[Realtime] Items retry $attempt: ${fetchedItems.length} items');
                  } catch (e) {
                    if (kDebugMode) debugPrint('[Realtime] Items retry error: $e');
                  }

                  if (fetchedItems.isNotEmpty) break;

                  if (attempt < maxRetries) {
                    await Future.delayed(retryDelay);
                  }
                }

                if (fetchedItems.isNotEmpty) {
                  await _applyPulledRows('online_order_items', fetchedItems);
                }

                try {
                  final customers = await _supabase
                      .from('online_customers')
                      .select()
                      .eq('id', customerId);
                  if ((customers as List).isNotEmpty) {
                    await _applyPulledRows('online_customers', customers.cast<Map<String, dynamic>>());
                  }
                } catch (e) {
                  if (kDebugMode) debugPrint('[Realtime] customer fetch error: $e');
                }

                final judul = 'Pesanan Online Baru';
                final pesan = 'Ada pesanan online baru (${fetchedItems.length} item, Total: Rp $totalHarga).';
                await _db.into(_db.notifikasiTable).insert(NotifikasiTableCompanion.insert(
                  id: _uuid.v4(),
                  judul: judul,
                  pesan: pesan,
                  tipe: const Value('ORDER'),
                  createdAt: Value(DateTime.now().toUtc()),
                ));

                _onlineOrderEventController.add(null);
              }
            })
        .subscribe((status, error) {
          if (error != null) {
            if (kDebugMode) debugPrint('[Realtime] Subscription error: $error');
            // Tear down old channel before resubscribe to avoid duplicates
            if (_realtimeChannel != null) {
              try {
                _supabase.removeChannel(_realtimeChannel!);
              } catch (e) {
                if (kDebugMode) debugPrint('[Realtime] removeChannel error: $e');
              }
            }
            // Auto-retry setelah 10 detik
            _isRealtimeInitialized = false;
            Future.delayed(const Duration(seconds: 10), () {
              initRealtimeListeners();
            });
          } else {
            if (kDebugMode) debugPrint('[Realtime] Subscription status: $status');
          }
        });
  }

  /// Force pull khusus untuk online_orders, online_customers, dan online_order_items
  /// dengan filter agar tidak terlalu berat saat direfresh
  Future<void> pullOnlineOrdersForce() async {
    try {
      // 1. Tarik orders yang masih aktif ATAU baru diupdate dalam 14 hari terakhir
      // Ini memastikan kasir tetap bisa melihat orderan 'completed' baru-baru ini untuk keperluan komplain,
      // sekaligus menghindari tarikan ribuan data history lama.
      final fourteenDaysAgo = DateTime.now().subtract(const Duration(days: 14)).toUtc().toIso8601String();
      final orders = await _supabase
          .from('online_orders')
          .select()
          .or('status.in.("pending","processing","ready"),updated_at.gte.$fourteenDaysAgo');
          
      if ((orders as List).isEmpty) return;
      final orderList = orders.cast<Map<String, dynamic>>();

      // 2. Tarik customers untuk order tersebut
      final customerIds = orderList.map((e) => e['customer_id'] as String).toSet().toList();
      if (customerIds.isNotEmpty) {
        for (var i = 0; i < customerIds.length; i += 100) {
          final chunk = customerIds.skip(i).take(100).toList();
          final customers = await _supabase
              .from('online_customers')
              .select()
              .inFilter('id', chunk);
          if ((customers as List).isNotEmpty) {
            await _applyPulledRows('online_customers', customers.cast<Map<String, dynamic>>());
          }
        }
      }

      // 3. Simpan orders ke lokal
      await _applyPulledRows('online_orders', orderList);

      // 4. Tarik order items untuk order tersebut
      // Kita fetch berdasarkan order_id karena online_order_items tidak memiliki created_at
      final orderIds = orderList.map((e) => e['id'] as String).toSet().toList();
      if (orderIds.isNotEmpty) {
        for (var i = 0; i < orderIds.length; i += 100) {
          final chunk = orderIds.skip(i).take(100).toList();
          final items = await _supabase
              .from('online_order_items')
              .select()
              .inFilter('online_order_id', chunk);
          if ((items as List).isNotEmpty) {
            await _applyPulledRows('online_order_items', items.cast<Map<String, dynamic>>());
          }
        }
      }
    } catch (e) {
      if (kDebugMode) debugPrint('[SyncService] pullOnlineOrdersForce error: $e');
    }
  }

  /// Full sync: download semua data toko dari Supabase (untuk install baru)
  Future<void> performInitialSync({
    required void Function(int fetched, int total) onProgress,
  }) async {
    const allTables = [
      ...(_pullOrder),
      ...(_appendOnlyTables),
    ];

    int total = allTables.length;
    int done = 0;
    onProgress(0, total);

    for (final table in allTables) {
      try {
        final rows = await _supabase
            .from(table)
            .select()
            .order('created_at');

        if ((rows as List).isNotEmpty) {
          await _applyPulledRows(table, rows.cast<Map<String, dynamic>>());
        }
      } catch (e) {
        if (kDebugMode) debugPrint('[SyncService] initialSync table $table error: $e');
      }

      done++;
      onProgress(done, total);
    }

    // Pull profiles
    try {
      final profiles = await _supabase
          .from('profiles')
          .select();
      for (final p in profiles as List) {
        await _db.into(_db.userTable).insertOnConflictUpdate(UserTableCompanion(
          id: Value(p['id'] as String),
          nama: Value(p['nama'] as String?),
          role: Value(p['role'] as String? ?? 'kasir'),
        ));
      }
    } catch (e) {
      if (kDebugMode) debugPrint('[SyncService] initialSync profiles error: $e');
    }

    await _prefs.setString(_lastSyncKey, DateTime.now().toUtc().toIso8601String());
    await _prefs.setBool('initial_sync_done_v2', true);
  }

  Future<bool> get isInitialSyncDone async {
    return _prefs.getBool('initial_sync_done_v2') == true;
  }

  /// Batas maksimal retry per item sebelum dihapus dari queue
  static const int _maxRetryPerItem = 5;

  /// Jumlah item yang masih antri
  Future<int> pendingQueueCount() async {
    return _db.select(_db.pendingSyncQueueTable).get().then((q) => q.length);
  }

  /// Flush antrian operasi yang belum berhasil di-sync
  Future<int> flushQueue() async {
    if (!(await isOnline)) return 0;

    final sessionValid = await _ensureValidSession();
    if (!sessionValid) return 0;

    final queue = await _db.select(_db.pendingSyncQueueTable).get();
    int flushed = 0;

    for (final item in queue) {
      try {
        final payload = jsonDecode(item.payload) as Map<String, dynamic>;
        if (item.operation == 'upsert') {
          final cleanPayload = Map<String, dynamic>.from(payload)..remove('_retryCount');
          await _supabase.from(item.targetTable).upsert(cleanPayload, onConflict: 'id');
        } else if (item.operation == 'delete') {
          await _supabase.from(item.targetTable).delete().eq('id', item.recordId);
        }
        // Hapus dari queue setelah berhasil
        await (_db.delete(_db.pendingSyncQueueTable)
          ..where((t) => t.id.equals(item.id)))
            .go();
        flushed++;
      } catch (e) {
        if (kDebugMode) debugPrint('[SyncService] flushQueue item ${item.id} (${item.targetTable}/${item.recordId}) error: $e');
        // Hitung retry via payload JSON
        try {
          final payload = jsonDecode(item.payload) as Map<String, dynamic>;
          int retryCount = payload['_retryCount'] as int? ?? 0;
          retryCount++;

          if (retryCount >= _maxRetryPerItem) {
            // Hapus dari queue — sudah terlalu sering gagal
            await (_db.delete(_db.pendingSyncQueueTable)
              ..where((t) => t.id.equals(item.id)))
                .go();
            if (kDebugMode) debugPrint('[Sync] Queue item ${item.id} (${item.targetTable}/${item.recordId}) '
                'dihapus setelah $retryCount× gagal');
          } else {
            // Update retry count di payload
            payload['_retryCount'] = retryCount;
            await (_db.update(_db.pendingSyncQueueTable)
              ..where((t) => t.id.equals(item.id)))
                .write(PendingSyncQueueTableCompanion(
                  payload: Value(jsonEncode(payload)),
                ));
          }
        } catch (innerE) {
          if (kDebugMode) debugPrint('[SyncService] flushQueue retry update error for ${item.id}: $innerE');
        }
      }
    }

    return flushed;
  }

  /// Push semua produk lokal ke Supabase secara paksa (berguna untuk migrasi schema atau force sync)
  Future<int> forcePushSemuaProduk() async {
    final rows = await _db.select(_db.produkTable).get();
    int enqueuedOrPushed = 0;

    for (final r in rows) {
      await upsert('produk', {
        'id': r.id,
        'nama': r.nama,
        'barcode': r.barcode,
        'harga_beli': r.hargaBeli,
        'harga_jual': r.hargaJual,
        'stok': r.stok,
        'stok_minimum': r.stokMinimum,
        'kategori': r.kategori,
        'satuan': r.satuan,
        'image_url': r.imageUrl,
        'is_archived': r.isArchived,
      });
      enqueuedOrPushed++;
    }
    return enqueuedOrPushed;
  }

  // ─────────────────────────────────────────────────
  // PRIVATE HELPERS
  // ─────────────────────────────────────────────────

  Future<void> _enqueue(
    String tableName,
    String operation,
    String recordId,
    Map<String, dynamic> payload,
  ) async {
    await _db.into(_db.pendingSyncQueueTable).insert(
      PendingSyncQueueTableCompanion(
        targetTable: Value(tableName),
        operation: Value(operation),
        recordId: Value(recordId),
        payload: Value(jsonEncode(payload)),
      ),
    );
  }

  Future<void> _applyPulledRows(
    String table,
    List<Map<String, dynamic>> rows,
  ) async {
    for (final row in rows) {
      await _inserters[table]?.call(_db, row);
    }
  }
}

// ─────────────────────────────────────────────────
// PULL ORDER (dependency order — parent sebelum child)
// ─────────────────────────────────────────────────

const _pullOrder = [
  'produk',
  'satuan_produk',
  'supplier',
  'supplier_products',
  'transaksi',
  'hutang_piutang',
  'pembelian',
  'purchase_orders',
  'pending_order',
  'pending_pembelian',
  'online_customers',
  'online_orders',
];

const _appendOnlyTables = [
  'item_transaksi',
  'item_transaksi_sementara',
  'item_pembelian',
  'purchase_order_items',
  'riwayat_stok',
  'riwayat_harga',
  'notifikasi',
  'pending_order_item',
  'pending_pembelian_item',
  'online_order_items',
];

// ─────────────────────────────────────────────────
// INSERTERS — Supabase JSON → Drift local table
// ─────────────────────────────────────────────────

typedef _Inserter = Future<void> Function(AppDatabase db, Map<String, dynamic> row);

final Map<String, _Inserter> _inserters = {
  'produk': (db, r) async {
    await db.into(db.produkTable).insertOnConflictUpdate(ProdukTableCompanion(
      id: Value(r['id'] as String),
      nama: Value(r['nama'] as String),
      barcode: Value(r['barcode'] as String?),
      hargaBeli: Value((r['harga_beli'] as num).toDouble()),
      hargaJual: Value((r['harga_jual'] as num).toDouble()),
      stok: Value(r['stok'] as int? ?? 0),
      stokMinimum: Value(r['stok_minimum'] as int?),
      kategori: Value(r['kategori'] as String?),
      satuan: Value(r['satuan'] as String? ?? 'pcs'),
      imageUrl: Value(r['image_url'] as String?),
      updatedAt: Value(_parseDate(r['updated_at'])),
      createdAt: Value(_parseDate(r['created_at'])),
    ));
  },
  'satuan_produk': (db, r) async {
    await db.into(db.satuanProdukTable).insertOnConflictUpdate(SatuanProdukTableCompanion(
      id: Value(r['id'] as String),
      produkId: Value(r['produk_id'] as String),
      nama: Value(r['nama'] as String),
      konversi: Value((r['konversi'] as num).toDouble()),
      hargaBeli: Value((r['harga_beli'] as num).toDouble()),
      hargaJual: Value((r['harga_jual'] as num).toDouble()),
      updatedAt: Value(_parseDate(r['updated_at'])),
    ));
  },
  'supplier': (db, r) async {
    await db.into(db.supplierTable).insertOnConflictUpdate(SupplierTableCompanion(
      id: Value(r['id'] as String),
      nama: Value(r['nama'] as String),
      telepon: Value(r['telepon'] as String?),
      alamat: Value(r['alamat'] as String?),
      updatedAt: Value(_parseDate(r['updated_at'])),
      createdAt: Value(_parseDate(r['created_at'])),
    ));
  },
  'supplier_products': (db, r) async {
    await db.into(db.supplierProductsTable).insertOnConflictUpdate(SupplierProductsTableCompanion(
      id: Value(r['id'] as String),
      supplierId: Value(r['supplier_id'] as String),
      produkId: Value(r['produk_id'] as String),
      harga: Value((r['harga'] as num).toDouble()),
      updatedAt: Value(_parseDate(r['updated_at'])),
    ));
  },
  'transaksi': (db, r) async {
    await db.into(db.transaksiTable).insertOnConflictUpdate(TransaksiTableCompanion(
      id: Value(r['id'] as String),
      kasirId: Value(r['kasir_id'] as String?),
      totalHarga: Value((r['total_harga'] as num).toDouble()),
      jumlahBayar: Value((r['jumlah_bayar'] as num).toDouble()),
      kembalian: Value((r['kembalian'] as num).toDouble()),
      status: Value(r['status'] as String? ?? 'lunas'),
      updatedAt: Value(_parseDate(r['updated_at'])),
      createdAt: Value(_parseDate(r['created_at'])),
    ));
  },
  'item_transaksi_sementara': (db, r) async {
    await db.into(db.itemTransaksiSementaraTable).insertOnConflictUpdate(ItemTransaksiSementaraTableCompanion(
      id: Value(r['id'] as String),
      transaksiId: Value(r['transaksi_id'] as String),
      namaManual: Value(r['nama_manual'] as String?),
      hargaJualManual: Value((r['harga_jual_manual'] as num).toDouble()),
      jumlah: Value(r['jumlah'] as int),
      satuanManual: Value(r['satuan_manual'] as String?),
      catatan: Value(r['catatan'] as String?),
      status: Value(r['status'] as String? ?? 'pending'),
      produkId: Value(r['produk_id'] as String?),
      createdAt: Value(_parseDate(r['created_at'])),
      completedAt: Value(r['completed_at'] != null ? _parseDate(r['completed_at']) : null),
      completedBy: Value(r['completed_by'] as String?),
    ));
  },
  'item_transaksi': (db, r) async {
    await db.into(db.itemTransaksiTable).insertOnConflictUpdate(ItemTransaksiTableCompanion(
      id: Value(r['id'] as String),
      transaksiId: Value(r['transaksi_id'] as String),
      produkId: Value(r['produk_id'] as String),
      namaProduk: Value(r['nama_produk'] as String?),
      jumlah: Value(r['jumlah'] as int),
      hargaSatuan: Value((r['harga_satuan'] as num).toDouble()),
      subtotal: Value((r['subtotal'] as num).toDouble()),
    ));
  },
  'hutang_piutang': (db, r) async {
    await db.into(db.hutangPiutangTable).insertOnConflictUpdate(HutangPiutangTableCompanion(
      id: Value(r['id'] as String),
      transaksiId: Value(r['transaksi_id'] as String?),
      namaPelanggan: Value(r['nama_pelanggan'] as String),
      jumlah: Value((r['jumlah'] as num).toDouble()),
      status: Value(r['status'] as String? ?? 'belum_lunas'),
      tanggalJatuhTempo: Value(r['tanggal_jatuh_tempo'] != null
          ? DateTime.tryParse(r['tanggal_jatuh_tempo'] as String)
          : null),
      updatedAt: Value(_parseDate(r['updated_at'])),
      createdAt: Value(_parseDate(r['created_at'])),
    ));
  },
  'pembelian': (db, r) async {
    await db.into(db.pembelianTable).insertOnConflictUpdate(PembelianTableCompanion(
      id: Value(r['id'] as String),
      supplierId: Value(r['supplier_id'] as String?),
      namaSupplier: Value(r['nama_supplier'] as String?),
      totalHarga: Value((r['total_harga'] as num).toDouble()),
      updatedAt: Value(_parseDate(r['updated_at'])),
      createdAt: Value(_parseDate(r['created_at'])),
    ));
  },
  'item_pembelian': (db, r) async {
    await db.into(db.itemPembelianTable).insertOnConflictUpdate(ItemPembelianTableCompanion(
      id: Value(r['id'] as String),
      pembelianId: Value(r['pembelian_id'] as String),
      produkId: Value(r['produk_id'] as String),
      namaProduk: Value(r['nama_produk'] as String?),
      jumlah: Value(r['jumlah'] as int),
      hargaBeliSatuan: Value((r['harga_beli_satuan'] as num).toDouble()),
      subtotal: Value((r['subtotal'] as num).toDouble()),
      satuanId: Value(r['satuan_id'] as String?),
      konversi: Value((r['konversi'] as num? ?? 1.0).toDouble()),
    ));
  },
  'riwayat_stok': (db, r) async {
    await db.into(db.riwayatStokTable).insertOnConflictUpdate(RiwayatStokTableCompanion(
      id: Value(r['id'] as String),
      produkId: Value(r['produk_id'] as String),
      tipe: Value(r['tipe'] as String),
      jumlah: Value(r['jumlah'] as int),
      keterangan: Value(r['keterangan'] as String?),
      createdAt: Value(_parseDate(r['created_at'])),
    ));
  },
  'notifikasi': (db, r) async {
    await db.into(db.notifikasiTable).insertOnConflictUpdate(NotifikasiTableCompanion(
      id: Value(r['id'] as String),
      judul: Value(r['judul'] as String),
      pesan: Value(r['pesan'] as String),
      tipe: Value(r['tipe'] as String? ?? 'INFO'),
      isRead: Value(r['is_read'] as bool? ?? false),
      createdAt: Value(_parseDate(r['created_at'])),
    ));
  },
  'pending_order': (db, r) async {
    await db.into(db.pendingOrderTable).insertOnConflictUpdate(PendingOrderTableCompanion(
      id: Value(r['id'] as String),
      namaPelanggan: Value(r['nama_pelanggan'] as String),
      catatan: Value(r['catatan'] as String?),
      createdAt: Value(_parseDate(r['created_at'])),
    ));
  },
  'pending_order_item': (db, r) async {
    await db.into(db.pendingOrderItemTable).insertOnConflictUpdate(PendingOrderItemTableCompanion(
      id: Value(r['id'] as String),
      pendingOrderId: Value(r['pending_order_id'] as String),
      produkId: Value(r['produk_id'] as String),
      namaProduk: Value(r['nama_produk'] as String),
      hargaJual: Value((r['harga_jual'] as num).toDouble()),
      jumlah: Value(r['jumlah'] as int),
      diskonTipe: Value(r['diskon_tipe'] as int? ?? 0),
      diskonValue: Value((r['diskon_value'] as num? ?? 0).toDouble()),
      subtotal: Value((r['subtotal'] as num).toDouble()),
    ));
  },
  'purchase_orders': (db, r) async {
    await db.into(db.purchaseOrderTable).insertOnConflictUpdate(PurchaseOrderTableCompanion(
      id: Value(r['id'] as String),
      supplierId: Value(r['supplier_id'] as String?),
      namaSupplier: Value(r['nama_supplier'] as String?),
      status: Value(r['status'] as String? ?? 'open'),
      totalHarga: Value((r['total_harga'] as num).toDouble()),
      notes: Value(r['notes'] as String?),
      updatedAt: Value(_parseDate(r['updated_at'])),
      createdAt: Value(_parseDate(r['created_at'])),
    ));
  },
  'purchase_order_items': (db, r) async {
    await db.into(db.purchaseOrderItemTable).insertOnConflictUpdate(PurchaseOrderItemTableCompanion(
      id: Value(r['id'] as String),
      poId: Value(r['po_id'] as String),
      produkId: Value(r['produk_id'] as String),
      namaProduk: Value(r['nama_produk'] as String?),
      qtyPesan: Value(r['qty_pesan'] as int),
      qtyTerima: Value((r['qty_terima'] as num?)?.toInt() ?? 0),
      hargaSatuan: Value((r['harga_satuan'] as num).toDouble()),
      subtotal: Value((r['subtotal'] as num).toDouble()),
      satuanId: Value(r['satuan_id'] as String?),
      konversi: Value((r['konversi'] as num? ?? 1.0).toDouble()),
    ));
  },
  'pending_pembelian': (db, r) async {
    await db.into(db.pendingPembelianTable).insertOnConflictUpdate(PendingPembelianTableCompanion(
      id: Value(r['id'] as String),
      supplierId: Value(r['supplier_id'] as String?),
      namaSupplier: Value(r['nama_supplier'] as String?),
      isPpnEnabled: Value(r['is_ppn_enabled'] as bool? ?? false),
      ppnPercent: Value((r['ppn_percent'] as num? ?? 11.0).toDouble()),
      createdAt: Value(_parseDate(r['created_at'])),
    ));
  },
  'pending_pembelian_item': (db, r) async {
    await db.into(db.pendingPembelianItemTable).insertOnConflictUpdate(PendingPembelianItemTableCompanion(
      id: Value(r['id'] as String),
      pendingPembelianId: Value(r['pending_pembelian_id'] as String),
      produkId: Value(r['produk_id'] as String),
      namaProduk: Value(r['nama_produk'] as String),
      jumlah: Value(r['jumlah'] as int),
      hargaBeliSatuan: Value((r['harga_beli_satuan'] as num).toDouble()),
      hargaBeliLama: Value((r['harga_beli_lama'] as num).toDouble()),
      diskonTipe: Value(r['diskon_tipe'] as int? ?? 0),
      diskonValue: Value((r['diskon_value'] as num? ?? 0).toDouble()),
      satuanId: Value(r['satuan_id'] as String?),
      konversi: Value((r['konversi'] as num? ?? 1.0).toDouble()),
    ));
  },
  'online_customers': (db, r) async {
    await db.into(db.onlineCustomerTable).insertOnConflictUpdate(OnlineCustomerTableCompanion(
      id: Value(r['id']?.toString() ?? ''),
      nama: Value(r['nama']?.toString() ?? 'Pelanggan Online'),
      telepon: Value(r['telepon']?.toString()),
      alamat: Value(r['alamat']?.toString()),
      updatedAt: Value(_parseDate(r['updated_at'])),
      createdAt: Value(_parseDate(r['created_at'])),
    ));
  },
  'online_orders': (db, r) async {
    await db.into(db.onlineOrderTable).insertOnConflictUpdate(OnlineOrderTableCompanion(
      id: Value(r['id']?.toString() ?? ''),
      customerId: Value(r['customer_id']?.toString() ?? ''),
      status: Value(r['status']?.toString() ?? 'pending'),
      totalHarga: Value((r['total_harga'] as num?)?.toDouble() ?? 0.0),
      metodePengiriman: Value(r['metode_pengiriman']?.toString() ?? 'pickup'),
      alamatPengiriman: Value(r['alamat_pengiriman']?.toString()),
      catatan: Value(r['catatan']?.toString()),
      updatedAt: Value(_parseDate(r['updated_at'])),
      createdAt: Value(_parseDate(r['created_at'])),
    ));
  },
  'online_order_items': (db, r) async {
    await db.into(db.onlineOrderItemTable).insertOnConflictUpdate(OnlineOrderItemTableCompanion(
      id: Value(r['id']?.toString() ?? ''),
      onlineOrderId: Value(r['online_order_id']?.toString() ?? ''),
      produkId: Value(r['produk_id']?.toString() ?? ''),
      namaProduk: Value(r['nama_produk']?.toString() ?? ''),
      hargaSatuan: Value((r['harga_satuan'] as num?)?.toDouble() ?? 0.0),
      jumlah: Value((r['jumlah'] as num?)?.toInt() ?? 0),
      subtotal: Value((r['subtotal'] as num?)?.toDouble() ?? 0.0),
      satuanId: Value(r['satuan_id']?.toString()),
      konversi: Value((r['konversi'] as num?)?.toDouble() ?? 1.0),
      isUnavailable: Value(r['is_unavailable'] as bool? ?? false),
    ));
  },
};

DateTime _parseDate(dynamic v) {
  if (v == null) return DateTime.now().toUtc();
  if (v is DateTime) return v;
  return DateTime.tryParse(v.toString()) ?? DateTime.now().toUtc();
}
