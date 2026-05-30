import 'package:injectable/injectable.dart';
import 'package:drift/drift.dart';
import '../../core/services/toko_service.dart';
import '../../domain/entities/hutang_piutang.dart' as domain;
import '../../domain/entities/produk.dart' as domain;
import '../../domain/repositories/laporan_repository.dart';
import '../database/app_database.dart';

@LazySingleton(as: LaporanRepository)
class LaporanRepositoryImpl implements LaporanRepository {
  final AppDatabase _db;
  final TokoService _tokoService;

  LaporanRepositoryImpl(this._db, this._tokoService);

  String get _tokoId => _tokoService.tokoId ?? '';

  @override
  Future<List<LabaRugiItem>> getLabaRugi({
    required DateTime startDate,
    required DateTime endDate,
  }) async {
    final endOfDay = DateTime(endDate.year, endDate.month, endDate.day, 23, 59, 59);

    // Get all transaksi in date range
    final transaksi = await (_db.select(_db.transaksiTable)
      ..where((t) =>
          t.tokoId.equals(_tokoId) &
          t.status.equals('lunas') &
          t.createdAt.isBetweenValues(startDate, endOfDay))).get();

    final Map<String, _LabaRugiAccum> acc = {};

    for (final trx in transaksi) {
      final items = await (_db.select(_db.itemTransaksiTable)
        ..where((i) =>
            i.tokoId.equals(_tokoId) & i.transaksiId.equals(trx.id))).get();

      for (final item in items) {
        final produk = await (_db.select(_db.produkTable)
          ..where((p) => p.id.equals(item.produkId))).getSingleOrNull();

        if (produk == null) continue;

        acc.putIfAbsent(item.produkId, () => _LabaRugiAccum(
          namaProduk: produk.nama,
        ));

        acc[item.produkId]!.qty += item.jumlah;
        acc[item.produkId]!.totalHargaJual += item.subtotal;
        // HPP = hargaPokok * qty sold (hargaPokok from produkTable, not item)
        acc[item.produkId]!.totalHargaPokok += produk.hargaBeli * item.jumlah;
      }
    }

    return acc.entries.map((e) {
      final v = e.value;
      final laba = v.totalHargaJual - v.totalHargaPokok;
      final margin = v.totalHargaJual > 0 ? (laba / v.totalHargaJual) * 100 : 0.0;
      return LabaRugiItem(
        produkId: e.key,
        namaProduk: v.namaProduk,
        qtyTerjual: v.qty,
        totalHargaJual: v.totalHargaJual,
        totalHargaPokok: v.totalHargaPokok,
        labaKotor: laba,
        marginPersen: margin,
      );
    }).toList()
      ..sort((a, b) => b.totalHargaJual.compareTo(a.totalHargaJual));
  }

  @override
  Future<List<ProdukTerlarisItem>> getProdukTerlaris({
    required DateTime startDate,
    required DateTime endDate,
    int limit = 10,
  }) async {
    final endOfDay = DateTime(endDate.year, endDate.month, endDate.day, 23, 59, 59);

    final transaksi = await (_db.select(_db.transaksiTable)
      ..where((t) =>
          t.tokoId.equals(_tokoId) &
          t.status.equals('lunas') &
          t.createdAt.isBetweenValues(startDate, endOfDay))).get();

    final Map<String, _QtyAccum> acc = {};

    for (final trx in transaksi) {
      final items = await (_db.select(_db.itemTransaksiTable)
        ..where((i) =>
            i.tokoId.equals(_tokoId) & i.transaksiId.equals(trx.id))).get();

      for (final item in items) {
        acc.putIfAbsent(item.produkId, () => _QtyAccum());
        acc[item.produkId]!.qty += item.jumlah;
        acc[item.produkId]!.total += item.subtotal;
      }
    }

    // Get product names
    final result = <ProdukTerlarisItem>[];
    for (final entry in acc.entries) {
      final produk = await (_db.select(_db.produkTable)
        ..where((p) => p.id.equals(entry.key))).getSingleOrNull();
      result.add(ProdukTerlarisItem(
        produkId: entry.key,
        namaProduk: produk?.nama ?? 'Dihapus',
        qtyTerjual: entry.value.qty,
        totalPenjualan: entry.value.total,
      ));
    }

    result.sort((a, b) => b.qtyTerjual.compareTo(a.qtyTerjual));
    return result.take(limit).toList();
  }

  @override
  Future<List<domain.HutangPiutang>> getRingkasanHutang() async {
    final data = await (_db.select(_db.hutangPiutangTable)
      ..where((h) => h.tokoId.equals(_tokoId))).get();

    data.sort((a, b) => b.createdAt.compareTo(a.createdAt));
    return data.map((h) => domain.HutangPiutang(
      id: h.id,
      tokoId: h.tokoId,
      transaksiId: h.transaksiId,
      namaPelanggan: h.namaPelanggan,
      jumlah: h.jumlah,
      status: h.status,
      tanggalJatuhTempo: h.tanggalJatuhTempo,
      createdAt: h.createdAt,
      updatedAt: h.updatedAt,
    )).toList();
  }

  @override
  Future<List<ArusKasItem>> getArusKas({
    required DateTime startDate,
    required DateTime endDate,
  }) async {
    final endOfDay = DateTime(endDate.year, endDate.month, endDate.day, 23, 59, 59);
    final Map<String, _ArusKasAccum> dailyMap = {};

    // Pemasukan: transaksi lunas
    final transaksi = await (_db.select(_db.transaksiTable)
      ..where((t) =>
          t.tokoId.equals(_tokoId) &
          t.createdAt.isBetweenValues(startDate, endOfDay))).get();

    for (final t in transaksi) {
      final key = _dateKey(t.createdAt);
      dailyMap.putIfAbsent(key, () => _ArusKasAccum());
      if (t.status == 'lunas') {
        dailyMap[key]!.pemasukan += t.totalHarga;
      }
    }

    // Pengeluaran: pembelian (harga pokok pembelian)
    final pembelian = await (_db.select(_db.pembelianTable)
      ..where((p) =>
          p.tokoId.equals(_tokoId) &
          p.createdAt.isBetweenValues(startDate, endOfDay))).get();

    for (final p in pembelian) {
      final key = _dateKey(p.createdAt);
      dailyMap.putIfAbsent(key, () => _ArusKasAccum());
      dailyMap[key]!.pengeluaran += p.totalHarga;
    }

    return dailyMap.entries.map((e) {
      final date = DateTime.tryParse(e.key) ?? startDate;
      return ArusKasItem(
        pemasukan: e.value.pemasukan,
        pengeluaran: e.value.pengeluaran,
        tanggal: date,
      );
    }).toList()
      ..sort((a, b) => a.tanggal.compareTo(b.tanggal));
  }

  @override
  Future<List<domain.Produk>> getStokMenipis({int? stokLimit}) async {
    final globalMin = _tokoService.stokMinimumGlobal;
    final limit = stokLimit ?? (globalMin > 0 ? globalMin : 5);

    final data = await (_db.select(_db.produkTable)
      ..where((p) => p.tokoId.equals(_tokoId))
      ..orderBy([(p) => OrderingTerm(expression: p.stok, mode: OrderingMode.asc)])).get();

    return data
      .where((p) {
        final minStok = p.stokMinimum ?? limit;
        return p.stok <= minStok;
      })
      .map((p) => domain.Produk(
        id: p.id,
        tokoId: p.tokoId,
        nama: p.nama,
        barcode: p.barcode,
        hargaBeli: p.hargaBeli,
        hargaJual: p.hargaJual,
        stok: p.stok,
        stokMinimum: p.stokMinimum,
        kategori: p.kategori,
        satuan: p.satuan,
        createdAt: p.createdAt,
        updatedAt: p.updatedAt,
      )).toList()
        ..sort((a, b) => a.stok.compareTo(b.stok));
  }

  String _dateKey(DateTime dt) =>
      '${dt.year}-${dt.month.toString().padLeft(2, '0')}-${dt.day.toString().padLeft(2, '0')}';
}

class _LabaRugiAccum {
  final String namaProduk;
  int qty = 0;
  double totalHargaJual = 0;
  double totalHargaPokok = 0;

  _LabaRugiAccum({required this.namaProduk});
}

class _QtyAccum {
  int qty = 0;
  double total = 0;
}

class _ArusKasAccum {
  double pemasukan = 0;
  double pengeluaran = 0;
}
