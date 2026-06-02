import 'package:injectable/injectable.dart';
import 'package:drift/drift.dart';
import '../../domain/entities/dashboard_metrics.dart';
import '../../domain/repositories/dashboard_repository.dart';
import '../database/app_database.dart';
import '../../domain/entities/produk.dart' as domain;
import '../../domain/entities/riwayat_harga.dart';

@LazySingleton(as: DashboardRepository)
class DashboardRepositoryImpl implements DashboardRepository {
  final AppDatabase _db;

  DashboardRepositoryImpl(this._db);

  @override
  Future<DashboardMetrics> getTodayMetrics() async {
    final now = DateTime.now();
    final startOfDay = DateTime(now.year, now.month, now.day);
    final endOfDay = startOfDay.add(const Duration(days: 1));

    final transaksiQuery = _db.select(_db.transaksiTable)..where((t) =>
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
        i.transaksiId.equals(tr.id)
      );
      final items = await itemsQuery.get();
      for (final item in items) {
        terjualCount += item.jumlah;
      }
    }

    // Fetch stok menipis (stok <= 3)
    final stokMenipisQuery = _db.select(_db.produkTable)
      ..where((p) => p.stok.isSmallerOrEqualValue(3))
      ..limit(5);
    final stokMenipisData = await stokMenipisQuery.get();
    final stokMenipis = stokMenipisData.map((p) => domain.Produk(
      id: p.id,
      nama: p.nama,
      barcode: p.barcode,
      hargaBeli: p.hargaBeli,
      hargaJual: p.hargaJual,
      stok: p.stok,
      kategori: p.kategori,
      satuan: p.satuan,
      createdAt: p.createdAt,
      updatedAt: p.updatedAt,
    )).toList();

    // Fetch riwayat harga terakhir
    final riwayatHargaQuery = _db.select(_db.riwayatHargaTable)
      ..orderBy([(r) => OrderingTerm(expression: r.createdAt, mode: OrderingMode.desc)])
      ..limit(5);
    final riwayatHargaData = await riwayatHargaQuery.get();
    
    // Join with ProdukTable to get product names
    final List<RiwayatHarga> updateHargaTerakhir = [];
    for (final r in riwayatHargaData) {
      final produkData = await (_db.select(_db.produkTable)..where((p) => p.id.equals(r.produkId))).getSingleOrNull();
      updateHargaTerakhir.add(RiwayatHarga(
        id: r.id,
          produkId: r.produkId,
        produkNama: produkData?.nama ?? 'Produk Dihapus',
        hargaBeliLama: r.hargaBeliLama,
        hargaBeliBaru: r.hargaBeliBaru,
        hargaJualLama: r.hargaJualLama,
        hargaJualBaru: r.hargaJualBaru,
        createdAt: r.createdAt,
      ));
    }

    return DashboardMetrics(
      omzet: omzet,
      transaksi: transaksiCount,
      terjual: terjualCount,
      stokMenipis: stokMenipis,
      updateHargaTerakhir: updateHargaTerakhir,
    );
  }
}
