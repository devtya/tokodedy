import 'package:equatable/equatable.dart';

class SatuanProduk extends Equatable {
  final String? id; // UUID
  final String tokoId; // UUID FK ke toko
  final String produkId; // UUID FK ke produk
  final String nama;
  final double konversi;
  final double hargaBeli;
  final double hargaJual;
  final DateTime? updatedAt;

  const SatuanProduk({
    this.id,
    required this.tokoId,
    required this.produkId,
    required this.nama,
    required this.konversi,
    required this.hargaBeli,
    required this.hargaJual,
    this.updatedAt,
  });

  SatuanProduk copyWith({
    String? id,
    String? tokoId,
    String? produkId,
    String? nama,
    double? konversi,
    double? hargaBeli,
    double? hargaJual,
    DateTime? updatedAt,
  }) {
    return SatuanProduk(
      id: id ?? this.id,
      tokoId: tokoId ?? this.tokoId,
      produkId: produkId ?? this.produkId,
      nama: nama ?? this.nama,
      konversi: konversi ?? this.konversi,
      hargaBeli: hargaBeli ?? this.hargaBeli,
      hargaJual: hargaJual ?? this.hargaJual,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  @override
  List<Object?> get props => [id, tokoId, produkId, nama, konversi, hargaBeli, hargaJual, updatedAt];
}
