import 'package:drift/drift.dart';

import '../database/app_database.dart';
import '../services/supabase_sync_service.dart';
import '../../core/services/toko_service.dart';
import '../../domain/entities/supplier.dart' as domain;
import '../../domain/repositories/supplier_repository.dart';

class SupplierRepositoryImpl implements SupplierRepository {
  final AppDatabase _db;
  final SupabaseSyncService _syncService;
  final TokoService _tokoService;

  SupplierRepositoryImpl(this._db, this._syncService, this._tokoService);

  String get _tokoId => _tokoService.tokoId ?? '';

  domain.Supplier _map(SupplierTableData data) {
    return domain.Supplier(
      id: data.id,
      tokoId: data.tokoId,
      nama: data.nama,
      telepon: data.telepon,
      alamat: data.alamat,
      createdAt: data.createdAt,
    );
  }

  @override
  Future<List<domain.Supplier>> getAllSupplier() async {
    final data = await (_db.select(_db.supplierTable)..where((t) => t.tokoId.equals(_tokoId))).get();
    return data.map(_map).toList();
  }

  @override
  Future<domain.Supplier?> getSupplierById(String id) async {
    final data = await (_db.select(_db.supplierTable)
      ..where((t) => t.id.equals(id) & t.tokoId.equals(_tokoId)))
        .getSingleOrNull();
    return data != null ? _map(data) : null;
  }

  @override
  Future<List<domain.Supplier>> searchSupplier(String query) async {
    final likePattern = '%$query%';
    final data = await (_db.select(_db.supplierTable)
      ..where((t) => t.tokoId.equals(_tokoId) & t.nama.like(likePattern)))
        .get();
    return data.map(_map).toList();
  }

  @override
  Future<String> addSupplier(domain.Supplier supplier) async {
    final id = supplier.id ?? _syncService.generateId();
    await _db.into(_db.supplierTable).insert(
          SupplierTableCompanion.insert(
            id: id,
            tokoId: _tokoId,
            nama: supplier.nama,
            telepon: Value(supplier.telepon),
            alamat: Value(supplier.alamat),
          ),
        );

    // Sync to Supabase
    await _syncService.upsert('supplier', {
      'id': id,
      'toko_id': _tokoId,
      'nama': supplier.nama,
      'telepon': supplier.telepon,
      'alamat': supplier.alamat,
    });

    return id;
  }

  @override
  Future<void> updateSupplier(domain.Supplier supplier) async {
    await (_db.update(_db.supplierTable)
      ..where((t) => t.id.equals(supplier.id!) & t.tokoId.equals(_tokoId)))
        .write(
      SupplierTableCompanion(
        nama: Value(supplier.nama),
        telepon: Value(supplier.telepon),
        alamat: Value(supplier.alamat),
      ),
    );

    // Sync to Supabase
    await _syncService.upsert('supplier', {
      'id': supplier.id!,
      'toko_id': _tokoId,
      'nama': supplier.nama,
      'telepon': supplier.telepon,
      'alamat': supplier.alamat,
    });
  }

  @override
  Future<void> deleteSupplier(String id) async {
    await (_db.delete(_db.supplierTable)
      ..where((t) => t.id.equals(id) & t.tokoId.equals(_tokoId)))
        .go();

    // Sync to Supabase
    await _syncService.delete('supplier', id);
  }
}
