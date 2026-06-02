import 'package:drift/drift.dart';
import '../../core/services/toko_service.dart';
import '../database/app_database.dart';
import '../services/supabase_sync_service.dart';
import '../../domain/entities/online_order.dart' as domain;
import '../../domain/repositories/online_order_repository.dart';
import 'package:injectable/injectable.dart';

@LazySingleton(as: OnlineOrderRepository)
class OnlineOrderRepositoryImpl implements OnlineOrderRepository {
  final AppDatabase _db;
  final SupabaseSyncService _syncService;
  final TokoService _tokoService;

  OnlineOrderRepositoryImpl(this._db, this._syncService, this._tokoService);

  @override
  Future<List<domain.OnlineOrder>> getPendingOrders() async {
    final tokoId = _tokoService.tokoId;
    if (tokoId == null) return [];

    final query = _db.select(_db.onlineOrderTable).join([
      innerJoin(
        _db.onlineCustomerTable,
        _db.onlineCustomerTable.id.equalsExp(_db.onlineOrderTable.customerId),
      ),
    ])
      ..where(_db.onlineOrderTable.tokoId.equals(tokoId))
      ..where(_db.onlineOrderTable.status.equals('pending'))
      ..orderBy([OrderingTerm.desc(_db.onlineOrderTable.createdAt)]);

    final rows = await query.get();

    return rows.map((row) {
      final order = row.readTable(_db.onlineOrderTable);
      final customer = row.readTable(_db.onlineCustomerTable);

      return domain.OnlineOrder(
        id: order.id,
        customerId: order.customerId,
        namaCustomer: customer.nama,
        status: order.status,
        totalHarga: order.totalHarga,
        metodePengiriman: order.metodePengiriman,
        alamatPengiriman: order.alamatPengiriman,
        catatan: order.catatan,
        createdAt: order.createdAt,
      );
    }).toList();
  }

  @override
  Future<void> updateOrderStatus(String id, String status) async {
    await (_db.update(_db.onlineOrderTable)..where((t) => t.id.equals(id))).write(
      OnlineOrderTableCompanion(
        status: Value(status),
        updatedAt: Value(DateTime.now()),
      ),
    );

    // Sync to Supabase
    final updatedRow = await (_db.select(_db.onlineOrderTable)..where((t) => t.id.equals(id))).getSingle();
    final rowMap = updatedRow.toJson(serializer: const ValueSerializer.defaults(serializeDateTimeValuesAsString: true));
    
    // Konversi json drift ke json supabase (snake_case)
    final supabaseMap = {
      'id': rowMap['id'],
      'toko_id': rowMap['tokoId'],
      'customer_id': rowMap['customerId'],
      'status': rowMap['status'],
      'total_harga': rowMap['totalHarga'],
      'metode_pengiriman': rowMap['metodePengiriman'],
      'alamat_pengiriman': rowMap['alamatPengiriman'],
      'catatan': rowMap['catatan'],
      'updated_at': rowMap['updatedAt'],
      'created_at': rowMap['createdAt'],
    };

    await _syncService.upsert('online_orders', supabaseMap);
  }
}
