import 'package:uuid/uuid.dart';
import 'package:drift/drift.dart';

import '../database/app_database.dart';
import '../../core/services/toko_service.dart';

class SyncHelper {
  final AppDatabase _db;
  final TokoService _tokoService;
  final Uuid _uuid;

  SyncHelper(this._db, this._tokoService) : _uuid = const Uuid();

  Future<String> onInsert({
    required String tableEntity,
    required int localId,
    int? tokoId,
  }) async {
    final uuid = _uuid.v4();
    final activeTokoId = tokoId ?? _tokoService.tokoId ?? 1;
    await _db.into(_db.syncRecordTable).insert(
          SyncRecordTableCompanion(
            uuid: Value(uuid),
            tableEntity: Value(tableEntity),
            localId: Value(localId),
            updatedAt: Value(DateTime.now().millisecondsSinceEpoch),
            tokoId: Value(activeTokoId),
          ),
        );
    return uuid;
  }

  Future<void> onUpdate({
    required String tableEntity,
    required int localId,
  }) async {
    final existing = await (_db.select(
      _db.syncRecordTable,
    )
      ..where((t) =>
          t.tableEntity.equals(tableEntity) & t.localId.equals(localId)))
      .get();

    if (existing.isNotEmpty) {
      await (_db.update(_db.syncRecordTable)
        ..where((t) =>
            t.tableEntity.equals(tableEntity) & t.localId.equals(localId)))
        .write(SyncRecordTableCompanion(
          updatedAt: Value(DateTime.now().millisecondsSinceEpoch),
          syncStatus: const Value('pending'),
        ));
    }
  }

  Future<void> onDelete({
    required String tableEntity,
    required int localId,
  }) async {
    final existing = await (_db.select(
      _db.syncRecordTable,
    )
      ..where((t) =>
          t.tableEntity.equals(tableEntity) & t.localId.equals(localId)))
      .get();

    if (existing.isNotEmpty) {
      await (_db.update(_db.syncRecordTable)
        ..where((t) =>
            t.tableEntity.equals(tableEntity) & t.localId.equals(localId)))
        .write(SyncRecordTableCompanion(
          isDeleted: const Value(true),
          updatedAt: Value(DateTime.now().millisecondsSinceEpoch),
          syncStatus: const Value('pending'),
        ));
    }
  }
}
