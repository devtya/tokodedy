import 'package:drift/drift.dart';
import 'package:injectable/injectable.dart';
import 'package:uuid/uuid.dart';

import '../../domain/entities/kas_harian.dart';
import '../../domain/entities/pengeluaran_operasional.dart';
import '../../domain/repositories/kas_harian_repository.dart';
import '../database/app_database.dart';
import '../services/supabase_sync_service.dart';

@LazySingleton(as: KasHarianRepository)
class KasHarianRepositoryImpl implements KasHarianRepository {
  final AppDatabase _db;
  final SupabaseSyncService _syncService;

  KasHarianRepositoryImpl(this._db, this._syncService);

  DateTime _getDateOnlyUtc(DateTime date) {
    return DateTime.utc(date.year, date.month, date.day);
  }

  @override
  Future<KasHarian?> getKasHarianByDate(DateTime date) async {
    final targetDate = _getDateOnlyUtc(date);
    
    final query = _db.select(_db.kasHarianTable)
      ..where((t) => t.tanggal.equals(targetDate));
      
    final result = await query.getSingleOrNull();
    if (result == null) return null;
    
    return KasHarian(
      id: result.id,
      modalAwal: result.modalAwal,
      keterangan: result.keterangan,
      tanggal: result.tanggal,
      createdAt: result.createdAt,
      updatedAt: result.updatedAt,
    );
  }

  @override
  Future<void> setModalAwal(KasHarian kasHarian) async {
    final targetDate = _getDateOnlyUtc(kasHarian.tanggal);
    final now = DateTime.now().toUtc();
    
    final existing = await getKasHarianByDate(targetDate);
    final id = existing?.id ?? const Uuid().v4();
    final isNew = existing == null;
    
    final companion = KasHarianTableCompanion(
      id: Value(id),
      modalAwal: Value(kasHarian.modalAwal),
      keterangan: Value(kasHarian.keterangan),
      tanggal: Value(targetDate),
      createdAt: Value(isNew ? now : existing.createdAt!),
      updatedAt: Value(now),
    );
    
    await _db.into(_db.kasHarianTable).insertOnConflictUpdate(companion);
    
    await _syncService.upsert('kas_harian', {
      'id': id,
      'modal_awal': kasHarian.modalAwal,
      'keterangan': kasHarian.keterangan,
      'tanggal': targetDate.toIso8601String(),
      'created_at': isNew ? now.toIso8601String() : existing.createdAt!.toIso8601String(),
      'updated_at': now.toIso8601String(),
    });
  }

  @override
  Future<List<PengeluaranOperasional>> getPengeluaranByDate(DateTime date) async {
    final targetDate = _getDateOnlyUtc(date);
    
    final query = _db.select(_db.pengeluaranOperasionalTable)
      ..where((t) => t.tanggal.equals(targetDate))
      ..orderBy([(t) => OrderingTerm(expression: t.createdAt, mode: OrderingMode.desc)]);
      
    final results = await query.get();
    
    return results.map((r) => PengeluaranOperasional(
      id: r.id,
      jumlah: r.jumlah,
      kategori: r.kategori,
      keterangan: r.keterangan,
      tanggal: r.tanggal,
      createdAt: r.createdAt,
    )).toList();
  }

  @override
  Future<void> addPengeluaran(PengeluaranOperasional pengeluaran) async {
    final id = pengeluaran.id ?? const Uuid().v4();
    final targetDate = _getDateOnlyUtc(pengeluaran.tanggal);
    final now = DateTime.now().toUtc();
    
    final companion = PengeluaranOperasionalTableCompanion(
      id: Value(id),
      jumlah: Value(pengeluaran.jumlah),
      kategori: Value(pengeluaran.kategori),
      keterangan: Value(pengeluaran.keterangan),
      tanggal: Value(targetDate),
      createdAt: Value(now),
      updatedAt: Value(now),
    );
    
    await _db.into(_db.pengeluaranOperasionalTable).insert(companion);
    
    await _syncService.upsert('pengeluaran_operasional', {
      'id': id,
      'jumlah': pengeluaran.jumlah,
      'kategori': pengeluaran.kategori,
      'keterangan': pengeluaran.keterangan,
      'tanggal': targetDate.toIso8601String(),
      'created_at': now.toIso8601String(),
      'updated_at': now.toIso8601String(),
    });
  }

  @override
  Future<void> deletePengeluaran(String id) async {
    await (_db.delete(_db.pengeluaranOperasionalTable)..where((t) => t.id.equals(id))).go();
    await _syncService.delete('pengeluaran_operasional', id);
  }

  @override
  Future<KasDailySummary> getDailySummary(DateTime date) async {
    final targetDate = _getDateOnlyUtc(date);
    final startOfDay = DateTime(date.year, date.month, date.day).toUtc();
    final endOfDay = DateTime(date.year, date.month, date.day, 23, 59, 59, 999).toUtc();
    
    // Modal Awal
    final kasHarian = await getKasHarianByDate(targetDate);
    final modalAwal = kasHarian?.modalAwal ?? 0.0;
    
    // Total Omzet (transaksi lunas)
    final transaksi = await (_db.select(_db.transaksiTable)
      ..where((t) => t.status.equals('lunas'))
      ..where((t) => t.createdAt.isBetweenValues(startOfDay, endOfDay))).get();
    final totalOmzet = transaksi.fold(0.0, (sum, t) => sum + t.totalHarga);
    
    // Total Pembelian
    final pembelian = await (_db.select(_db.pembelianTable)
      ..where((p) => p.createdAt.isBetweenValues(startOfDay, endOfDay))).get();
    final totalPembelian = pembelian.fold(0.0, (sum, p) => sum + p.totalHarga);
    
    // Pengeluaran Operasional
    final pengeluaranList = await getPengeluaranByDate(targetDate);
    final totalPengeluaran = pengeluaranList.fold(0.0, (sum, p) => sum + p.jumlah);
    
    // Saldo Akhir
    final saldoAkhir = modalAwal + totalOmzet - totalPembelian - totalPengeluaran;
    
    return KasDailySummary(
      modalAwal: modalAwal,
      totalOmzet: totalOmzet,
      totalPembelian: totalPembelian,
      totalPengeluaran: totalPengeluaran,
      saldoAkhir: saldoAkhir,
      pengeluaranList: pengeluaranList,
    );
  }
}
