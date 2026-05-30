import 'package:injectable/injectable.dart';
import 'package:drift/drift.dart';

import '../database/app_database.dart';
import '../services/supabase_sync_service.dart';
import '../../core/services/toko_service.dart';
import '../../domain/entities/notifikasi.dart' as domain;
import '../../domain/repositories/notifikasi_repository.dart';

@LazySingleton(as: NotifikasiRepository)
class NotifikasiRepositoryImpl implements NotifikasiRepository {
  final AppDatabase _db;
  final SupabaseSyncService _syncService;
  final TokoService _tokoService;

  NotifikasiRepositoryImpl(this._db, this._syncService, this._tokoService);

  String get _tokoId => _tokoService.tokoId ?? '';

  domain.Notifikasi _mapToEntity(NotifikasiTableData data) {
    return domain.Notifikasi(
      id: data.id,
      tokoId: data.tokoId,
      judul: data.judul,
      pesan: data.pesan,
      tipe: data.tipe,
      isRead: data.isRead,
      createdAt: data.createdAt,
    );
  }

  @override
  Future<void> addNotifikasi(domain.Notifikasi notifikasi) async {
    final id = notifikasi.id ?? _syncService.generateId();
    await _db.into(_db.notifikasiTable).insert(
          NotifikasiTableCompanion.insert(
            id: id,
            tokoId: _tokoId,
            judul: notifikasi.judul,
            pesan: notifikasi.pesan,
            tipe: Value(notifikasi.tipe),
            isRead: Value(notifikasi.isRead),
          ),
        );

    // Sync to Supabase
    await _syncService.upsert('notifikasi', {
      'id': id,
      'toko_id': _tokoId,
      'judul': notifikasi.judul,
      'pesan': notifikasi.pesan,
      'tipe': notifikasi.tipe,
      'is_read': notifikasi.isRead,
    });
  }

  @override
  Future<List<domain.Notifikasi>> getAllNotifikasi() async {
    final query = _db.select(_db.notifikasiTable)
      ..where((t) => t.tokoId.equals(_tokoId))
      ..orderBy([
        (t) => OrderingTerm(expression: t.createdAt, mode: OrderingMode.desc),
      ]);
    final results = await query.get();
    return results.map(_mapToEntity).toList();
  }

  @override
  Future<List<domain.Notifikasi>> getUnreadNotifikasi() async {
    final query = _db.select(_db.notifikasiTable)
      ..where((t) => t.isRead.equals(false) & t.tokoId.equals(_tokoId))
      ..orderBy([
        (t) => OrderingTerm(expression: t.createdAt, mode: OrderingMode.desc),
      ]);
    final results = await query.get();
    return results.map(_mapToEntity).toList();
  }

  @override
  Future<void> markAsRead(String id) async {
    final existing = await (_db.select(_db.notifikasiTable)
      ..where((t) => t.id.equals(id) & t.tokoId.equals(_tokoId)))
        .getSingleOrNull();

    await (_db.update(_db.notifikasiTable)
      ..where((t) => t.id.equals(id) & t.tokoId.equals(_tokoId)))
        .write(const NotifikasiTableCompanion(isRead: Value(true)));

    // Sync to Supabase
    if (existing != null) {
      await _syncService.upsert('notifikasi', {
        'id': id,
        'toko_id': _tokoId,
        'judul': existing.judul,
        'pesan': existing.pesan,
        'tipe': existing.tipe,
        'is_read': true,
      });
    }
  }

  @override
  Future<List<domain.Notifikasi>> getNotifikasiByJudul(String search) async {
    final query = _db.select(_db.notifikasiTable)
      ..where((t) => t.judul.contains(search) & t.tokoId.equals(_tokoId))
      ..orderBy([
        (t) => OrderingTerm(expression: t.createdAt, mode: OrderingMode.desc),
      ]);
    final results = await query.get();
    return results.map(_mapToEntity).toList();
  }

  @override
  Stream<int> watchUnreadCount() {
    final query = _db.select(_db.notifikasiTable)
      ..where((t) => t.isRead.equals(false) & t.tokoId.equals(_tokoId));
    return query.watch().map((list) => list.length);
  }
}
