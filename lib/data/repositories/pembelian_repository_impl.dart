import 'package:drift/drift.dart';

import '../database/app_database.dart';
import '../services/supabase_sync_service.dart';
import '../../core/services/toko_service.dart';
import '../../domain/entities/item_pembelian.dart' as domain;
import '../../domain/entities/pembelian.dart' as domain;
import '../../domain/repositories/pembelian_repository.dart';

class PembelianRepositoryImpl implements PembelianRepository {
  final AppDatabase _db;
  final SupabaseSyncService _syncService;
  final TokoService _tokoService;

  PembelianRepositoryImpl(this._db, this._syncService, this._tokoService);

  String get _tokoId => _tokoService.tokoId ?? '';

  domain.Pembelian _map(PembelianTableData data) {
    return domain.Pembelian(
      id: data.id,
      tokoId: data.tokoId,
      supplierId: data.supplierId,
      namaSupplier: data.namaSupplier,
      totalHarga: data.totalHarga,
      createdAt: data.createdAt,
      updatedAt: data.updatedAt,
    );
  }

  @override
  Future<List<domain.Pembelian>> getAllPembelian() async {
    final data = await (_db.select(_db.pembelianTable)..where((t) => t.tokoId.equals(_tokoId))).get();
    data.sort((a, b) => b.createdAt.compareTo(a.createdAt));
    return data.map(_map).toList();
  }

  @override
  Future<domain.Pembelian?> getPembelianById(String id) async {
    final data = await (_db.select(_db.pembelianTable)
      ..where((t) => t.id.equals(id) & t.tokoId.equals(_tokoId)))
        .getSingleOrNull();
    return data != null ? _map(data) : null;
  }

  @override
  Future<String> addPembelian(domain.Pembelian pembelian) async {
    final id = pembelian.id ?? _syncService.generateId();
    await _db.into(_db.pembelianTable).insert(
          PembelianTableCompanion.insert(
            id: id,
            tokoId: _tokoId,
            supplierId: Value(pembelian.supplierId),
            namaSupplier: Value(pembelian.namaSupplier),
            totalHarga: Value(pembelian.totalHarga),
          ),
        );

    // Sync to Supabase
    await _syncService.upsert('pembelian', {
      'id': id,
      'toko_id': _tokoId,
      'supplier_id': pembelian.supplierId,
      'nama_supplier': pembelian.namaSupplier,
      'total_harga': pembelian.totalHarga,
    });

    return id;
  }

  @override
  Future<void> addItemPembelian(domain.ItemPembelian item) async {
    final id = item.id ?? _syncService.generateId();
    await _db.into(_db.itemPembelianTable).insert(
          ItemPembelianTableCompanion.insert(
            id: id,
            tokoId: _tokoId,
            pembelianId: item.pembelianId,
            produkId: item.produkId,
            jumlah: Value(item.jumlah),
            hargaBeliSatuan: Value(item.hargaBeliSatuan),
            subtotal: Value(item.subtotal),
            satuanId: Value(item.satuanId),
            konversi: Value(item.konversi),
          ),
        );

    // Sync to Supabase
    await _syncService.upsert('item_pembelian', {
      'id': id,
      'toko_id': _tokoId,
      'pembelian_id': item.pembelianId,
      'produk_id': item.produkId,
      'jumlah': item.jumlah,
      'harga_beli_satuan': item.hargaBeliSatuan,
      'subtotal': item.subtotal,
      'satuan_id': item.satuanId,
      'konversi': item.konversi,
    });
  }

  @override
  Future<domain.Pembelian?> getLastPembelianByProdukId(String produkId) async {
    final query = _db.select(_db.itemPembelianTable).join([
      innerJoin(
        _db.pembelianTable,
        _db.pembelianTable.id.equalsExp(_db.itemPembelianTable.pembelianId),
      ),
      innerJoin(
        _db.produkTable,
        _db.produkTable.id.equalsExp(_db.itemPembelianTable.produkId),
      ),
      leftOuterJoin(
        _db.satuanProdukTable,
        _db.satuanProdukTable.id.equalsExp(_db.itemPembelianTable.satuanId),
      ),
    ])
      ..where(_db.itemPembelianTable.produkId.equals(produkId) & _db.itemPembelianTable.tokoId.equals(_tokoId))
      ..orderBy([
        OrderingTerm(
          expression: _db.pembelianTable.createdAt,
          mode: OrderingMode.desc,
        ),
      ])
      ..limit(1);

    final result = await query.getSingleOrNull();
    if (result == null) return null;

    final item = result.readTable(_db.itemPembelianTable);
    final pembelian = result.readTable(_db.pembelianTable);
    final produk = result.readTable(_db.produkTable);
    final satuan = result.readTableOrNull(_db.satuanProdukTable);
    final unitName = satuan?.nama ?? produk.satuan;
      return domain.Pembelian(
        id: pembelian.id,
        tokoId: pembelian.tokoId,
        supplierId: pembelian.supplierId,
        namaSupplier: pembelian.namaSupplier,
        totalHarga: pembelian.totalHarga,
        createdAt: pembelian.createdAt,
        updatedAt: pembelian.updatedAt,
        items: [
          domain.ItemPembelian(
            id: item.id,
            tokoId: item.tokoId,
            pembelianId: item.pembelianId,
            produkId: item.produkId,
            namaProduk: '${produk.nama} - $unitName',
            jumlah: item.jumlah,
            hargaBeliSatuan: item.hargaBeliSatuan,
            subtotal: item.subtotal,
            satuanId: item.satuanId,
            konversi: item.konversi,
          ),
        ],
      );
  }

  @override
  Future<List<domain.ItemPembelian>> getItemsByPembelianId(
    String pembelianId,
  ) async {
    final query = _db.select(_db.itemPembelianTable).join([
      innerJoin(
        _db.produkTable,
        _db.produkTable.id.equalsExp(_db.itemPembelianTable.produkId),
      ),
      leftOuterJoin(
        _db.satuanProdukTable,
        _db.satuanProdukTable.id.equalsExp(_db.itemPembelianTable.satuanId),
      ),
    ])..where(_db.itemPembelianTable.pembelianId.equals(pembelianId) & _db.itemPembelianTable.tokoId.equals(_tokoId));

    final result = await query.get();
    return result.map((row) {
      final item = row.readTable(_db.itemPembelianTable);
      final produk = row.readTable(_db.produkTable);
      final satuan = row.readTableOrNull(_db.satuanProdukTable);
      final unitName = satuan?.nama ?? produk.satuan;
      return domain.ItemPembelian(
        id: item.id,
        tokoId: item.tokoId,
        pembelianId: item.pembelianId,
        produkId: item.produkId,
        namaProduk: '${produk.nama} - $unitName',
        jumlah: item.jumlah,
        hargaBeliSatuan: item.hargaBeliSatuan,
        subtotal: item.subtotal,
        satuanId: item.satuanId,
        konversi: item.konversi,
      );
    }).toList();
  }

  @override
  Future<void> updatePembelian(domain.Pembelian pembelian) async {
    await (_db.update(_db.pembelianTable)
      ..where((t) => t.id.equals(pembelian.id!) & t.tokoId.equals(_tokoId)))
      .write(PembelianTableCompanion(
        namaSupplier: Value(pembelian.namaSupplier),
        totalHarga: Value(pembelian.totalHarga),
      ));

    // Sync to Supabase
    await _syncService.upsert('pembelian', {
      'id': pembelian.id!,
      'toko_id': _tokoId,
      'supplier_id': pembelian.supplierId,
      'nama_supplier': pembelian.namaSupplier,
      'total_harga': pembelian.totalHarga,
    });
  }

  @override
  Future<void> deleteItemsByPembelianId(String pembelianId) async {
    final list = await getItemsByPembelianId(pembelianId);
    await (_db.delete(_db.itemPembelianTable)
      ..where((t) => t.pembelianId.equals(pembelianId) & t.tokoId.equals(_tokoId)))
      .go();

    // Sync to Supabase
    for (final s in list) {
      await _syncService.delete('item_pembelian', s.id!);
    }
  }

  @override
  Future<void> deletePembelian(String id) async {
    await (_db.delete(_db.pembelianTable)
      ..where((t) => t.id.equals(id) & t.tokoId.equals(_tokoId)))
      .go();

    // Sync to Supabase
    await _syncService.delete('pembelian', id);
  }

  @override
  Future<void> runInTransaction(Future<void> Function() action) async {
    await _db.transaction(action);
  }
}
