import 'package:injectable/injectable.dart';
import 'package:drift/drift.dart';

import '../database/app_database.dart';
import '../services/supabase_sync_service.dart';
import '../../domain/entities/riwayat_stok.dart' as domain;
import '../../domain/repositories/riwayat_stok_repository.dart';

@LazySingleton(as: RiwayatStokRepository)
class RiwayatStokRepositoryImpl implements RiwayatStokRepository {
  final AppDatabase _db;
  final SupabaseSyncService _syncService;

  RiwayatStokRepositoryImpl(this._db, this._syncService);

  domain.RiwayatStok _mapToDomain(RiwayatStokTableData data) {
    return domain.RiwayatStok(
      id: data.id,
      produkId: data.produkId,
      tipe: data.tipe,
      jumlah: data.jumlah,
      keterangan: data.keterangan,
      createdAt: data.createdAt,
    );
  }

  @override
  Future<List<domain.RiwayatStok>> getRiwayatByProdukId(String produkId) async {
    final data = await (_db.select(_db.riwayatStokTable)
      ..where((tbl) => tbl.produkId.equals(produkId)))
        .get();
    data.sort((a, b) => b.createdAt.compareTo(a.createdAt));
    return data.map(_mapToDomain).toList();
  }

  @override
  Future<void> addRiwayat(domain.RiwayatStok riwayat) async {
    final id = riwayat.id ?? _syncService.generateId();
    await _db.into(_db.riwayatStokTable).insert(
          RiwayatStokTableCompanion.insert(
            id: id,
                  produkId: riwayat.produkId,
            tipe: riwayat.tipe,
            jumlah: Value(riwayat.jumlah),
            keterangan: Value(riwayat.keterangan),
          ),
        );

    // Sync to Supabase
    await _syncService.upsert('riwayat_stok', {
      'id': id,
      'produk_id': riwayat.produkId,
      'tipe': riwayat.tipe,
      'jumlah': riwayat.jumlah,
      'keterangan': riwayat.keterangan,
    });
  }
}
