import 'package:injectable/injectable.dart';
import 'package:drift/drift.dart';

import '../database/app_database.dart';
import '../services/supabase_sync_service.dart';
import '../../domain/entities/produk.dart' as domain;
import '../../domain/entities/satuan_produk.dart' as domain;
import '../../domain/entities/riwayat_harga.dart';
import '../../domain/entities/riwayat_perubahan.dart';
import '../../domain/repositories/produk_repository.dart';

@LazySingleton(as: ProdukRepository)
class ProdukRepositoryImpl implements ProdukRepository {
  final AppDatabase _db;
  final SupabaseSyncService _syncService;

  ProdukRepositoryImpl(this._db, this._syncService);

  domain.Produk _mapToDomain(ProdukTableData data) {
    return domain.Produk(
      id: data.id,
      nama: data.nama,
      barcode: data.barcode,
      hargaBeli: data.hargaBeli,
      hargaJual: data.hargaJual,
      stok: data.stok,
      stokMinimum: data.stokMinimum,
      kategori: data.kategori,
      satuan: data.satuan,
      imageUrl: data.imageUrl,
      isArchived: data.isArchived,
      createdAt: data.createdAt,
      updatedAt: data.updatedAt,
    );
  }

  domain.SatuanProduk _mapSatuan(SatuanProdukTableData data) {
    return domain.SatuanProduk(
      id: data.id,
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
    final data = await (_db.select(_db.produkTable)).get();
    final result = data.map(_mapToDomain).toList();
    for (final produk in result) {
      final satuanList = await getSatuanByProdukId(produk.id!);
      result[result.indexOf(produk)] = produk.copyWith(satuanList: satuanList);
    }
    return result;
  }

  @override
  Future<List<RiwayatHarga>> getAllRiwayatHarga({int limit = 100}) async {
    final riwayatHargaQuery = _db.select(_db.riwayatHargaTable)
      ..orderBy([(r) => OrderingTerm(expression: r.createdAt, mode: OrderingMode.desc)])
      ..limit(limit);
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
    return updateHargaTerakhir;
  }

  @override
  Future<List<domain.Produk>> searchProduk(String query) async {
    final likePattern = '%$query%';
    final data = await (_db.select(_db.produkTable)
      ..where((tbl) => tbl.nama.like(likePattern)))
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
      ..where((tbl) => tbl.id.equals(id)))
        .getSingleOrNull();
    if (data == null) return null;
    final satuanList = await getSatuanByProdukId(data.id);
    return _mapToDomain(data).copyWith(satuanList: satuanList);
  }

  @override
  Future<domain.Produk?> getProdukByBarcode(String barcode) async {
    final data = await (_db.select(_db.produkTable)
      ..where((tbl) => tbl.barcode.equals(barcode)))
        .getSingleOrNull();
    if (data == null) return null;
    final satuanList = await getSatuanByProdukId(data.id);
    return _mapToDomain(data).copyWith(satuanList: satuanList);
  }

  @override
  Future<Set<String>> getAllBarcodes() async {
    final rows = await _db.select(_db.produkTable).get();
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
      nama: produk.nama,
      barcode: Value(produk.barcode),
      hargaBeli: Value(produk.hargaBeli),
      hargaJual: Value(produk.hargaJual),
      stok: Value(produk.stok),
      stokMinimum: Value(produk.stokMinimum),
      kategori: Value(produk.kategori),
      satuan: Value(produk.satuan ?? 'pcs'),
      imageUrl: Value(produk.imageUrl),
      isArchived: Value(produk.isArchived),
    );
    await _db.into(_db.produkTable).insert(row);

    // Sync to Supabase
    await _syncService.upsert('produk', {
      'id': id,
      'nama': produk.nama,
      'barcode': produk.barcode,
      'harga_beli': produk.hargaBeli,
      'harga_jual': produk.hargaJual,
      'stok': produk.stok,
      'stok_minimum': produk.stokMinimum,
      'kategori': produk.kategori,
      'satuan': produk.satuan ?? 'pcs',
      'image_url': produk.imageUrl,
      'is_archived': produk.isArchived,
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
              produkId: produk.id!,
          hargaBeliLama: existing.hargaBeli,
          hargaBeliBaru: produk.hargaBeli,
          hargaJualLama: existing.hargaJual,
          hargaJualBaru: produk.hargaJual,
        )
      );
    }

    if (existing != null && existing.nama != produk.nama) {
      final riwayatId = _syncService.generateId();
      await _db.into(_db.riwayatPerubahanProdukTable).insert(
        RiwayatPerubahanProdukTableCompanion.insert(
          id: riwayatId,
          produkId: produk.id!,
          kolomDiubah: 'NAMA',
          nilaiLama: existing.nama,
          nilaiBaru: produk.nama,
        )
      );
    }

    await (_db.update(_db.produkTable)
      ..where((tbl) => tbl.id.equals(produk.id!)))
        .write(
      ProdukTableCompanion(
        nama: Value(produk.nama),
        barcode: Value(produk.barcode),
        hargaBeli: Value(produk.hargaBeli),
        hargaJual: Value(produk.hargaJual),
        stokMinimum: Value(produk.stokMinimum),
        kategori: Value(produk.kategori),
        satuan: Value(produk.satuan ?? 'pcs'),
        imageUrl: Value(produk.imageUrl),
        isArchived: Value(produk.isArchived),
      ),
    );

    // Sync to Supabase
    await _syncService.upsert('produk', {
      'id': produk.id!,
      'nama': produk.nama,
      'barcode': produk.barcode,
      'harga_beli': produk.hargaBeli,
      'harga_jual': produk.hargaJual,
      'stok': produk.stok,
      'stok_minimum': produk.stokMinimum,
      'kategori': produk.kategori,
      'satuan': produk.satuan ?? 'pcs',
      'image_url': produk.imageUrl,
      'is_archived': produk.isArchived,
    });
  }

  @override
  Future<void> deleteProduk(String id) async {
    await (_db.delete(_db.produkTable)
      ..where((tbl) => tbl.id.equals(id)))
        .go();

    // Sync to Supabase
    await _syncService.delete('produk', id);
  }

  @override
  Future<void> archiveProduk(String id, bool isArchived) async {
    await (_db.update(_db.produkTable)
      ..where((tbl) => tbl.id.equals(id)))
        .write(ProdukTableCompanion(isArchived: Value(isArchived)));
    
    final existing = await getProdukById(id);
    if (existing != null) {
      await _syncService.upsert('produk', {
        'id': id,
        'nama': existing.nama,
        'barcode': existing.barcode,
        'harga_beli': existing.hargaBeli,
        'harga_jual': existing.hargaJual,
        'stok': existing.stok,
        'stok_minimum': existing.stokMinimum,
        'kategori': existing.kategori,
        'satuan': existing.satuan ?? 'pcs',
        'image_url': existing.imageUrl,
        'is_archived': isArchived,
      });
    }
  }

  @override
  Future<void> updateStok(String produkId, int jumlah) async {
    await (_db.update(_db.produkTable)
      ..where((tbl) => tbl.id.equals(produkId)))
        .write(ProdukTableCompanion(stok: Value(jumlah)));

    // Sync to Supabase
    final data = await getProdukById(produkId);
    if (data != null) {
      await _syncService.upsert('produk', {
        'id': produkId,
          'nama': data.nama,
        'barcode': data.barcode,
        'harga_beli': data.hargaBeli,
        'harga_jual': data.hargaJual,
        'stok': jumlah,
        'stok_minimum': data.stokMinimum,
        'kategori': data.kategori,
        'satuan': data.satuan ?? 'pcs',
        'image_url': data.imageUrl,
        'is_archived': data.isArchived,
      });
    }
  }

  @override
  Future<List<domain.SatuanProduk>> getSatuanByProdukId(String produkId) async {
    final data = await (_db.select(_db.satuanProdukTable)
      ..where((t) => t.produkId.equals(produkId))
      ..orderBy([(t) => OrderingTerm(expression: t.konversi, mode: OrderingMode.asc)]))
        .get();
    return data.map(_mapSatuan).toList();
  }

  @override
  Future<String> addSatuan(domain.SatuanProduk satuan) async {
    final id = satuan.id ?? _syncService.generateId();
    await _db.into(_db.satuanProdukTable).insert(
          SatuanProdukTableCompanion.insert(
            id: id,
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
      'produk_id': satuan.produkId,
      'nama': satuan.nama,
      'konversi': satuan.konversi,
      'harga_beli': satuan.hargaBeli,
      'harga_jual': satuan.hargaJual,
    });
    
    return id;
  }

  @override
  Future<void> updateSatuan(domain.SatuanProduk satuan) async {
    await (_db.update(_db.satuanProdukTable)
      ..where((t) => t.id.equals(satuan.id!)))
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
      ..where((t) => t.id.equals(id)))
        .go();

    // Sync to Supabase
    await _syncService.delete('satuan_produk', id);
  }

  @override
  Future<void> deleteSatuanByProdukId(String produkId) async {
    final list = await getSatuanByProdukId(produkId);
    await (_db.delete(_db.satuanProdukTable)
      ..where((t) => t.produkId.equals(produkId)))
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
                          nama: produk.nama,
                barcode: Value(produk.barcode),
                hargaBeli: Value(produk.hargaBeli),
                hargaJual: Value(produk.hargaJual),
                stok: Value(produk.stok),
                stokMinimum: Value(produk.stokMinimum),
                kategori: Value(produk.kategori),
                satuan: Value(produk.satuan ?? 'pcs'),
              ),
            );

        // Sync to Supabase
        await _syncService.upsert('produk', {
          'id': newId,
              'nama': produk.nama,
          'barcode': produk.barcode,
          'harga_beli': produk.hargaBeli,
          'harga_jual': produk.hargaJual,
          'stok': produk.stok,
          'stok_minimum': produk.stokMinimum,
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
    ).get();
    for (final row in produkRows) {
      final s = row.read(_db.produkTable.satuan);
      if (s != null && s.isNotEmpty) result.add(s);
    }

    final satuanRows = await (_db.selectOnly(_db.satuanProdukTable)
      ..addColumns([_db.satuanProdukTable.nama])
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
      ..where(_db.produkTable.kategori.isNotNull())
    ).get();

    final result = <String>{};
    for (final row in rows) {
      final k = row.read(_db.produkTable.kategori);
      if (k != null && k.isNotEmpty) result.add(k);
    }
    return result.toList()..sort();
  }

  @override
  Future<({int deleted, int protected})> cleanupDuplicateSatuan() async {
    int deleted = 0;
    int protected = 0;

    // Ambil semua satuan
    final allSatuan = await _db.select(_db.satuanProdukTable).get();

    // Group by produkId + nama (uppercase)
    final grouped = <String, List<SatuanProdukTableData>>{};
    for (final s in allSatuan) {
      final key = '${s.produkId}_${s.nama.toUpperCase()}';
      grouped.putIfAbsent(key, () => []).add(s);
    }

    for (final group in grouped.values) {
      if (group.length <= 1) continue; // Tidak duplikat

      // Cek mana yang dipakai di transaksi
      final List<SatuanProdukTableData> usedSatuan = [];
      final List<SatuanProdukTableData> unusedSatuan = [];

      for (final s in group) {
        final id = s.id;

        final check1 = await (_db.select(_db.itemPembelianTable)..where((t) => t.satuanId.equals(id))..limit(1)).get();
        final check2 = await (_db.select(_db.pendingPembelianItemTable)..where((t) => t.satuanId.equals(id))..limit(1)).get();
        final check3 = await (_db.select(_db.purchaseOrderItemTable)..where((t) => t.satuanId.equals(id))..limit(1)).get();
        final check4 = await (_db.select(_db.onlineOrderItemTable)..where((t) => t.satuanId.equals(id))..limit(1)).get();

        if (check1.isNotEmpty || check2.isNotEmpty || check3.isNotEmpty || check4.isNotEmpty) {
          usedSatuan.add(s);
        } else {
          unusedSatuan.add(s);
        }
      }

      protected += usedSatuan.length;

      // Jika ada yg unused, hapus
      // Tapi kalau ternyata usedSatuan kosong (semuanya unused), kita harus simpan 1 agar tidak hilang semua
      if (usedSatuan.isEmpty && unusedSatuan.isNotEmpty) {
        // Simpan index 0, hapus sisanya
        for (int i = 1; i < unusedSatuan.length; i++) {
          await deleteSatuan(unusedSatuan[i].id);
          deleted++;
        }
        protected++; // Yang disisakan 1
      } else if (usedSatuan.isNotEmpty && unusedSatuan.isNotEmpty) {
        // Karena sudah ada yg used, hapus semua yg unused
        for (final s in unusedSatuan) {
          await deleteSatuan(s.id);
          deleted++;
        }
      }
    }

    return (deleted: deleted, protected: protected);
  }

  @override
  Future<List<RiwayatPerubahan>> getRiwayatPerubahan(String produkId) async {
    final data = await (_db.select(_db.riwayatPerubahanProdukTable)
      ..where((t) => t.produkId.equals(produkId))
      ..orderBy([(t) => OrderingTerm(expression: t.createdAt, mode: OrderingMode.desc)])
    ).get();

    return data.map((d) => RiwayatPerubahan(
      id: d.id,
      produkId: d.produkId,
      kolomDiubah: d.kolomDiubah,
      nilaiLama: d.nilaiLama,
      nilaiBaru: d.nilaiBaru,
      createdAt: d.createdAt,
    )).toList();
  }
}
