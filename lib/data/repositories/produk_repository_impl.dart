import 'package:drift/drift.dart';

import '../../data/database/app_database.dart';
import '../../data/services/supabase_sync_service.dart';
import '../../core/services/toko_service.dart';
import '../../domain/entities/produk.dart' as domain;
import '../../domain/entities/satuan_produk.dart' as domain;
import '../../domain/repositories/produk_repository.dart';

class ProdukRepositoryImpl implements ProdukRepository {
  final AppDatabase _db;
  final SupabaseSyncService _syncService;
  final TokoService _tokoService;

  ProdukRepositoryImpl(this._db, this._syncService, this._tokoService);

  String get _tokoId => _tokoService.tokoId ?? '';

  domain.Produk _mapToDomain(ProdukTableData data) {
    return domain.Produk(
      id: data.id,
      tokoId: data.tokoId,
      nama: data.nama,
      barcode: data.barcode,
      hargaBeli: data.hargaBeli,
      hargaJual: data.hargaJual,
      stok: data.stok,
      kategori: data.kategori,
      satuan: data.satuan,
      createdAt: data.createdAt,
      updatedAt: data.updatedAt,
    );
  }

  domain.SatuanProduk _mapSatuan(SatuanProdukTableData data) {
    return domain.SatuanProduk(
      id: data.id,
      tokoId: data.tokoId,
      produkId: data.produkId,
      nama: data.nama,
      konversi: data.konversi,
      hargaBeli: data.hargaBeli,
      hargaJual: data.hargaJual,
      updatedAt: data.updatedAt,
    );
  }

  @override
  Future<List<domain.Produk>> getAllProduk() async {
    final data = await (_db.select(_db.produkTable)..where((tbl) => tbl.tokoId.equals(_tokoId))).get();
    final result = data.map(_mapToDomain).toList();
    for (final produk in result) {
      final satuanList = await getSatuanByProdukId(produk.id!);
      result[result.indexOf(produk)] = produk.copyWith(satuanList: satuanList);
    }
    return result;
  }

  @override
  Future<List<domain.Produk>> searchProduk(String query) async {
    final likePattern = '%$query%';
    final data = await (_db.select(_db.produkTable)
      ..where((tbl) => tbl.tokoId.equals(_tokoId) & tbl.nama.like(likePattern)))
        .get();
    final result = data.map(_mapToDomain).toList();
    for (final produk in result) {
      final satuanList = await getSatuanByProdukId(produk.id!);
      result[result.indexOf(produk)] = produk.copyWith(satuanList: satuanList);
    }
    return result;
  }

  @override
  Future<domain.Produk?> getProdukById(String id) async {
    final data = await (_db.select(_db.produkTable)
      ..where((tbl) => tbl.tokoId.equals(_tokoId) & tbl.id.equals(id)))
        .getSingleOrNull();
    if (data == null) return null;
    final satuanList = await getSatuanByProdukId(data.id);
    return _mapToDomain(data).copyWith(satuanList: satuanList);
  }

  @override
  Future<domain.Produk?> getProdukByBarcode(String barcode) async {
    final data = await (_db.select(_db.produkTable)
      ..where((tbl) => tbl.tokoId.equals(_tokoId) & tbl.barcode.equals(barcode)))
        .getSingleOrNull();
    if (data == null) return null;
    final satuanList = await getSatuanByProdukId(data.id);
    return _mapToDomain(data).copyWith(satuanList: satuanList);
  }

  @override
  Future<Set<String>> getAllBarcodes() async {
    final rows = await (_db.select(_db.produkTable)..where((tbl) => tbl.tokoId.equals(_tokoId))).get();
    return rows
        .map((r) => r.barcode)
        .where((b) => b != null && b.isNotEmpty)
        .cast<String>()
        .toSet();
  }

  @override
  Future<String> addProduk(domain.Produk produk) async {
    final id = produk.id ?? _syncService.generateId();
    final row = ProdukTableCompanion.insert(
      id: id,
      tokoId: _tokoId,
      nama: produk.nama,
      barcode: Value(produk.barcode),
      hargaBeli: Value(produk.hargaBeli),
      hargaJual: Value(produk.hargaJual),
      stok: Value(produk.stok),
      kategori: Value(produk.kategori),
      satuan: Value(produk.satuan ?? 'pcs'),
    );
    await _db.into(_db.produkTable).insert(row);

    // Sync to Supabase
    await _syncService.upsert('produk', {
      'id': id,
      'toko_id': _tokoId,
      'nama': produk.nama,
      'barcode': produk.barcode,
      'harga_beli': produk.hargaBeli,
      'harga_jual': produk.hargaJual,
      'stok': produk.stok,
      'kategori': produk.kategori,
      'satuan': produk.satuan ?? 'pcs',
    });

    return id;
  }

  @override
  Future<void> updateProduk(domain.Produk produk) async {
    // Check old prices to record history
    final existing = await getProdukById(produk.id!);
    if (existing != null && (existing.hargaBeli != produk.hargaBeli || existing.hargaJual != produk.hargaJual)) {
      final riwayatId = _syncService.generateId();
      await _db.into(_db.riwayatHargaTable).insert(
        RiwayatHargaTableCompanion.insert(
          id: riwayatId,
          tokoId: _tokoId,
          produkId: produk.id!,
          hargaBeliLama: existing.hargaBeli,
          hargaBeliBaru: produk.hargaBeli,
          hargaJualLama: existing.hargaJual,
          hargaJualBaru: produk.hargaJual,
        )
      );
    }

    await (_db.update(_db.produkTable)
      ..where((tbl) => tbl.id.equals(produk.id!) & tbl.tokoId.equals(_tokoId)))
        .write(
      ProdukTableCompanion(
        nama: Value(produk.nama),
        barcode: Value(produk.barcode),
        hargaBeli: Value(produk.hargaBeli),
        hargaJual: Value(produk.hargaJual),
        kategori: Value(produk.kategori),
        satuan: Value(produk.satuan ?? 'pcs'),
      ),
    );

    // Sync to Supabase
    await _syncService.upsert('produk', {
      'id': produk.id!,
      'toko_id': _tokoId,
      'nama': produk.nama,
      'barcode': produk.barcode,
      'harga_beli': produk.hargaBeli,
      'harga_jual': produk.hargaJual,
      'stok': produk.stok,
      'kategori': produk.kategori,
      'satuan': produk.satuan ?? 'pcs',
    });
  }

  @override
  Future<void> deleteProduk(String id) async {
    await (_db.delete(_db.produkTable)
      ..where((tbl) => tbl.id.equals(id) & tbl.tokoId.equals(_tokoId)))
        .go();

    // Sync to Supabase
    await _syncService.delete('produk', id);
  }

  @override
  Future<void> updateStok(String produkId, int jumlah) async {
    await (_db.update(_db.produkTable)
      ..where((tbl) => tbl.id.equals(produkId) & tbl.tokoId.equals(_tokoId)))
        .write(ProdukTableCompanion(stok: Value(jumlah)));

    // Sync to Supabase
    final data = await getProdukById(produkId);
    if (data != null) {
      await _syncService.upsert('produk', {
        'id': produkId,
        'toko_id': _tokoId,
        'nama': data.nama,
        'barcode': data.barcode,
        'harga_beli': data.hargaBeli,
        'harga_jual': data.hargaJual,
        'stok': jumlah,
        'kategori': data.kategori,
        'satuan': data.satuan ?? 'pcs',
      });
    }
  }

  @override
  Future<List<domain.SatuanProduk>> getSatuanByProdukId(String produkId) async {
    final data = await (_db.select(_db.satuanProdukTable)
      ..where((t) => t.produkId.equals(produkId) & t.tokoId.equals(_tokoId)))
        .get();
    return data.map(_mapSatuan).toList();
  }

  @override
  Future<void> addSatuan(domain.SatuanProduk satuan) async {
    final id = satuan.id ?? _syncService.generateId();
    await _db.into(_db.satuanProdukTable).insert(
          SatuanProdukTableCompanion.insert(
            id: id,
            tokoId: _tokoId,
            produkId: satuan.produkId,
            nama: satuan.nama,
            konversi: Value(satuan.konversi),
            hargaBeli: Value(satuan.hargaBeli),
            hargaJual: Value(satuan.hargaJual),
          ),
        );

    // Sync to Supabase
    await _syncService.upsert('satuan_produk', {
      'id': id,
      'toko_id': _tokoId,
      'produk_id': satuan.produkId,
      'nama': satuan.nama,
      'konversi': satuan.konversi,
      'harga_beli': satuan.hargaBeli,
      'harga_jual': satuan.hargaJual,
    });
  }

  @override
  Future<void> updateSatuan(domain.SatuanProduk satuan) async {
    await (_db.update(_db.satuanProdukTable)
      ..where((t) => t.id.equals(satuan.id!) & t.tokoId.equals(_tokoId)))
        .write(
      SatuanProdukTableCompanion(
        nama: Value(satuan.nama),
        konversi: Value(satuan.konversi),
        hargaBeli: Value(satuan.hargaBeli),
        hargaJual: Value(satuan.hargaJual),
      ),
    );

    // Sync to Supabase
    await _syncService.upsert('satuan_produk', {
      'id': satuan.id!,
      'toko_id': _tokoId,
      'produk_id': satuan.produkId,
      'nama': satuan.nama,
      'konversi': satuan.konversi,
      'harga_beli': satuan.hargaBeli,
      'harga_jual': satuan.hargaJual,
    });
  }

  @override
  Future<void> deleteSatuan(String id) async {
    await (_db.delete(_db.satuanProdukTable)
      ..where((t) => t.id.equals(id) & t.tokoId.equals(_tokoId)))
        .go();

    // Sync to Supabase
    await _syncService.delete('satuan_produk', id);
  }

  @override
  Future<void> deleteSatuanByProdukId(String produkId) async {
    final list = await getSatuanByProdukId(produkId);
    await (_db.delete(_db.satuanProdukTable)
      ..where((t) => t.produkId.equals(produkId) & t.tokoId.equals(_tokoId)))
        .go();

    // Sync to Supabase
    for (final s in list) {
      await _syncService.delete('satuan_produk', s.id!);
    }
  }

  @override
  Future<({int imported, int skipped})> importAll({
    required List<domain.Produk> produkList,
    required Map<String, List<domain.SatuanProduk>> satuanByNama,
    required Set<String> existingBarcodes,
  }) async {
    int imported = 0;
    int skipped = 0;

    await _db.transaction(() async {
      for (final produk in produkList) {
        if (produk.barcode != null &&
            existingBarcodes.contains(produk.barcode)) {
          skipped++;
          continue;
        }

        final newId = produk.id ?? _syncService.generateId();
        await _db.into(_db.produkTable).insert(
              ProdukTableCompanion.insert(
                id: newId,
                tokoId: _tokoId,
                nama: produk.nama,
                barcode: Value(produk.barcode),
                hargaBeli: Value(produk.hargaBeli),
                hargaJual: Value(produk.hargaJual),
                stok: Value(produk.stok),
                kategori: Value(produk.kategori),
                satuan: Value(produk.satuan ?? 'pcs'),
              ),
            );

        // Sync to Supabase
        await _syncService.upsert('produk', {
          'id': newId,
          'toko_id': _tokoId,
          'nama': produk.nama,
          'barcode': produk.barcode,
          'harga_beli': produk.hargaBeli,
          'harga_jual': produk.hargaJual,
          'stok': produk.stok,
          'kategori': produk.kategori,
          'satuan': produk.satuan ?? 'pcs',
        });

        final satuanList = satuanByNama[produk.nama];
        if (satuanList != null) {
          for (final satuan in satuanList) {
            final newSatuanId = satuan.id ?? _syncService.generateId();
            await _db.into(_db.satuanProdukTable).insert(
                  SatuanProdukTableCompanion.insert(
                    id: newSatuanId,
                    tokoId: _tokoId,
                    produkId: newId,
                    nama: satuan.nama,
                    konversi: Value(satuan.konversi),
                    hargaBeli: Value(satuan.hargaBeli),
                    hargaJual: Value(satuan.hargaJual),
                  ),
                );

            // Sync to Supabase
            await _syncService.upsert('satuan_produk', {
              'id': newSatuanId,
              'toko_id': _tokoId,
              'produk_id': newId,
              'nama': satuan.nama,
              'konversi': satuan.konversi,
              'harga_beli': satuan.hargaBeli,
              'harga_jual': satuan.hargaJual,
            });
          }
        }

        imported++;
      }
    });

    return (imported: imported, skipped: skipped);
  }

  @override
  Future<List<String>> getAllSatuan() async {
    final result = <String>{};

    final produkRows = await (_db.selectOnly(_db.produkTable)
      ..addColumns([_db.produkTable.satuan])
      ..where(_db.produkTable.tokoId.equals(_tokoId))
    ).get();
    for (final row in produkRows) {
      final s = row.read(_db.produkTable.satuan);
      if (s != null && s.isNotEmpty) result.add(s);
    }

    final satuanRows = await (_db.selectOnly(_db.satuanProdukTable)
      ..addColumns([_db.satuanProdukTable.nama])
      ..where(_db.satuanProdukTable.tokoId.equals(_tokoId))
    ).get();
    for (final row in satuanRows) {
      final s = row.read(_db.satuanProdukTable.nama);
      if (s != null && s.isNotEmpty) result.add(s);
    }

    return result.toList()..sort();
  }

  @override
  Future<List<String>> getAllKategori() async {
    final rows = await (_db.selectOnly(_db.produkTable)
      ..addColumns([_db.produkTable.kategori])
      ..where(_db.produkTable.tokoId.equals(_tokoId))
      ..where(_db.produkTable.kategori.isNotNull())
    ).get();

    final result = <String>{};
    for (final row in rows) {
      final k = row.read(_db.produkTable.kategori);
      if (k != null && k.isNotEmpty) result.add(k);
    }
    return result.toList()..sort();
  }
}
