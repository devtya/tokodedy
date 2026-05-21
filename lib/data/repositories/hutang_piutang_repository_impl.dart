import 'package:drift/drift.dart';

import '../../data/database/app_database.dart';
import '../../data/services/supabase_sync_service.dart';
import '../../core/services/toko_service.dart';
import '../../domain/entities/hutang_piutang.dart' as domain;
import '../../domain/repositories/hutang_piutang_repository.dart';

class HutangPiutangRepositoryImpl implements HutangPiutangRepository {
  final AppDatabase _db;
  final SupabaseSyncService _syncService;
  final TokoService _tokoService;

  HutangPiutangRepositoryImpl(this._db, this._syncService, this._tokoService);

  String get _tokoId => _tokoService.tokoId ?? '';

  domain.HutangPiutang _mapToDomain(HutangPiutangTableData data) {
    return domain.HutangPiutang(
      id: data.id,
      tokoId: data.tokoId,
      transaksiId: data.transaksiId,
      namaPelanggan: data.namaPelanggan,
      jumlah: data.jumlah,
      status: data.status,
      tanggalJatuhTempo: data.tanggalJatuhTempo,
      createdAt: data.createdAt,
      updatedAt: data.updatedAt,
    );
  }

  @override
  Future<List<domain.HutangPiutang>> getAllHutang() async {
    final data = await (_db.select(_db.hutangPiutangTable)..where((t) => t.tokoId.equals(_tokoId))).get();
    data.sort((a, b) => b.createdAt.compareTo(a.createdAt));
    return data.map(_mapToDomain).toList();
  }

  @override
  Future<List<domain.HutangPiutang>> getHutangByStatus(String status) async {
    final data = await (_db.select(_db.hutangPiutangTable)
      ..where((t) => t.status.equals(status) & t.tokoId.equals(_tokoId)))
        .get();
    data.sort((a, b) => b.createdAt.compareTo(a.createdAt));
    return data.map(_mapToDomain).toList();
  }

  @override
  Future<void> addHutang(domain.HutangPiutang hutang) async {
    final id = hutang.id ?? _syncService.generateId();
    await _db.into(_db.hutangPiutangTable).insert(
          HutangPiutangTableCompanion.insert(
            id: id,
            tokoId: _tokoId,
            transaksiId: Value(hutang.transaksiId),
            namaPelanggan: hutang.namaPelanggan,
            jumlah: Value(hutang.jumlah),
            status: Value(hutang.status),
            tanggalJatuhTempo: Value(hutang.tanggalJatuhTempo),
          ),
        );

    // Sync to Supabase
    await _syncService.upsert('hutang_piutang', {
      'id': id,
      'toko_id': _tokoId,
      'transaksi_id': hutang.transaksiId,
      'nama_pelanggan': hutang.namaPelanggan,
      'jumlah': hutang.jumlah,
      'status': hutang.status,
      'tanggal_jatuh_tempo': hutang.tanggalJatuhTempo?.toIso8601String(),
    });
  }

  @override
  Future<void> updateStatus(String id, String status) async {
    final existing = await (_db.select(_db.hutangPiutangTable)
      ..where((t) => t.id.equals(id) & t.tokoId.equals(_tokoId)))
        .getSingleOrNull();

    await (_db.update(_db.hutangPiutangTable)
      ..where((t) => t.id.equals(id) & t.tokoId.equals(_tokoId)))
        .write(HutangPiutangTableCompanion(status: Value(status)));

    // Sync to Supabase
    if (existing != null) {
      await _syncService.upsert('hutang_piutang', {
        'id': id,
        'toko_id': _tokoId,
        'transaksi_id': existing.transaksiId,
        'nama_pelanggan': existing.namaPelanggan,
        'jumlah': existing.jumlah,
        'status': status,
        'tanggal_jatuh_tempo': existing.tanggalJatuhTempo?.toIso8601String(),
      });
    }

    if (existing?.transaksiId != null && status == 'lunas') {
      final transaksiId = existing!.transaksiId!;
      
      // Update local transaksi
      await (_db.update(_db.transaksiTable)
            ..where((t) => t.id.equals(transaksiId) & t.tokoId.equals(_tokoId)))
          .write(TransaksiTableCompanion(status: Value('lunas')));

      // Sync transaksi to Supabase
      final tx = await (_db.select(_db.transaksiTable)
        ..where((t) => t.id.equals(transaksiId) & t.tokoId.equals(_tokoId)))
          .getSingleOrNull();
      if (tx != null) {
        await _syncService.upsert('transaksi', {
          'id': tx.id,
          'toko_id': _tokoId,
          'kasir_id': tx.kasirId,
          'total_harga': tx.totalHarga,
          'jumlah_bayar': tx.jumlahBayar,
          'kembalian': tx.kembalian,
          'status': 'lunas',
        });
      }
    }
  }
}
