import 'package:drift/drift.dart';
import '../../core/services/toko_service.dart';
import '../../domain/entities/dashboard_metrics.dart';
import '../../domain/repositories/dashboard_repository.dart';
import '../database/app_database.dart';

class DashboardRepositoryImpl implements DashboardRepository {
  final AppDatabase _db;
  final TokoService _tokoService;

  DashboardRepositoryImpl(this._db, this._tokoService);

  @override
  Future<DashboardMetrics> getTodayMetrics() async {
    final tokoId = _tokoService.tokoId;
    if (tokoId == null) {
      return const DashboardMetrics(omzet: 0, transaksi: 0, terjual: 0);
    }

    final now = DateTime.now();
    final startOfDay = DateTime(now.year, now.month, now.day);
    final endOfDay = startOfDay.add(const Duration(days: 1));

    final transaksiQuery = _db.select(_db.transaksiTable)..where((t) => 
      t.tokoId.equals(tokoId) &
      t.status.equals('lunas') &
      t.createdAt.isBetweenValues(startOfDay, endOfDay)
    );
    
    final transaksiList = await transaksiQuery.get();
    
    double omzet = 0;
    int transaksiCount = transaksiList.length;
    int terjualCount = 0;

    for (final tr in transaksiList) {
      omzet += tr.totalHarga;
      
      final itemsQuery = _db.select(_db.itemTransaksiTable)..where((i) =>
        i.tokoId.equals(tokoId) &
        i.transaksiId.equals(tr.id)
      );
      final items = await itemsQuery.get();
      for (final item in items) {
        terjualCount += item.jumlah;
      }
    }

    return DashboardMetrics(
      omzet: omzet,
      transaksi: transaksiCount,
      terjual: terjualCount,
    );
  }
}
