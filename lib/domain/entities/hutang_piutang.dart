import 'package:equatable/equatable.dart';

class HutangPiutang extends Equatable {
  final String? id; // UUID
  final String tokoId; // UUID FK ke toko
  final String? transaksiId; // UUID FK ke transaksi
  final String namaPelanggan;
  final double jumlah;
  final String status; // 'belum_lunas' | 'lunas'
  final DateTime? tanggalJatuhTempo;
  final DateTime? updatedAt;
  final DateTime? createdAt;

  const HutangPiutang({
    this.id,
    required this.tokoId,
    this.transaksiId,
    required this.namaPelanggan,
    required this.jumlah,
    this.status = 'belum_lunas',
    this.tanggalJatuhTempo,
    this.updatedAt,
    this.createdAt,
  });

  HutangPiutang copyWith({
    String? id,
    String? tokoId,
    String? transaksiId,
    String? namaPelanggan,
    double? jumlah,
    String? status,
    DateTime? tanggalJatuhTempo,
    DateTime? updatedAt,
    DateTime? createdAt,
  }) {
    return HutangPiutang(
      id: id ?? this.id,
      tokoId: tokoId ?? this.tokoId,
      transaksiId: transaksiId ?? this.transaksiId,
      namaPelanggan: namaPelanggan ?? this.namaPelanggan,
      jumlah: jumlah ?? this.jumlah,
      status: status ?? this.status,
      tanggalJatuhTempo: tanggalJatuhTempo ?? this.tanggalJatuhTempo,
      updatedAt: updatedAt ?? this.updatedAt,
      createdAt: createdAt ?? this.createdAt,
    );
  }

  @override
  List<Object?> get props => [
    id, tokoId, transaksiId, namaPelanggan, jumlah,
    status, tanggalJatuhTempo, updatedAt, createdAt,
  ];
}
