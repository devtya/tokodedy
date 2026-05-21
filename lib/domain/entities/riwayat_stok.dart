import 'package:equatable/equatable.dart';

class RiwayatStok extends Equatable {
  final String? id; // UUID
  final String tokoId; // UUID FK ke toko
  final String produkId; // UUID FK ke produk
  final String tipe; // 'masuk' | 'keluar' | 'koreksi'
  final int jumlah;
  final String? keterangan;
  final DateTime? createdAt;

  const RiwayatStok({
    this.id,
    required this.tokoId,
    required this.produkId,
    required this.tipe,
    required this.jumlah,
    this.keterangan,
    this.createdAt,
  });

  @override
  List<Object?> get props => [id, tokoId, produkId, tipe, jumlah, keterangan, createdAt];
}
