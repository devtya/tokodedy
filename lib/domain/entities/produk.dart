import 'package:equatable/equatable.dart';

import 'satuan_produk.dart';

class Produk extends Equatable {
  final String? id; // UUID
  final String tokoId; // UUID FK ke toko
  final String nama;
  final String? barcode;
  final double hargaBeli;
  final double hargaJual;
  final int stok;
  final String? kategori;
  final String? satuan;
  final DateTime? updatedAt;
  final DateTime? createdAt;
  final List<SatuanProduk>? satuanList;

  const Produk({
    this.id,
    required this.tokoId,
    required this.nama,
    this.barcode,
    required this.hargaBeli,
    required this.hargaJual,
    this.stok = 0,
    this.kategori,
    this.satuan = 'pcs',
    this.updatedAt,
    this.createdAt,
    this.satuanList,
  });

  Produk copyWith({
    String? id,
    String? tokoId,
    String? nama,
    String? barcode,
    double? hargaBeli,
    double? hargaJual,
    int? stok,
    String? kategori,
    String? satuan,
    DateTime? updatedAt,
    DateTime? createdAt,
    List<SatuanProduk>? satuanList,
  }) {
    return Produk(
      id: id ?? this.id,
      tokoId: tokoId ?? this.tokoId,
      nama: nama ?? this.nama,
      barcode: barcode ?? this.barcode,
      hargaBeli: hargaBeli ?? this.hargaBeli,
      hargaJual: hargaJual ?? this.hargaJual,
      stok: stok ?? this.stok,
      kategori: kategori ?? this.kategori,
      satuan: satuan ?? this.satuan,
      updatedAt: updatedAt ?? this.updatedAt,
      createdAt: createdAt ?? this.createdAt,
      satuanList: satuanList ?? this.satuanList,
    );
  }

  @override
  List<Object?> get props => [
    id, tokoId, nama, barcode, hargaBeli, hargaJual,
    stok, kategori, satuan, updatedAt, createdAt, satuanList,
  ];
}
