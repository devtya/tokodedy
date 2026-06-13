import 'package:equatable/equatable.dart';

import 'satuan_produk.dart';

class Produk extends Equatable {
  final String? id; // UUID
  final String nama;
  final String? barcode;
  final double hargaBeli;
  final double hargaJual;
  final int stok;
  final int? stokMinimum;
  final String? kategori;
  final String? satuan;
  final String? imageUrl;
  final bool isArchived;
  final DateTime? updatedAt;
  final DateTime? createdAt;
  final List<SatuanProduk>? satuanList;

  const Produk({
    this.id,
    required this.nama,
    this.barcode,
    required this.hargaBeli,
    required this.hargaJual,
    this.stok = 0,
    this.stokMinimum,
    this.kategori,
    this.satuan = 'pcs',
    this.imageUrl,
    this.isArchived = false,
    this.updatedAt,
    this.createdAt,
    this.satuanList,
  });

  Produk copyWith({
    String? id,
    String? nama,
    String? barcode,
    double? hargaBeli,
    double? hargaJual,
    int? stok,
    int? stokMinimum,
    String? kategori,
    String? satuan,
    String? imageUrl,
    bool? isArchived,
    DateTime? updatedAt,
    DateTime? createdAt,
    List<SatuanProduk>? satuanList,
  }) {
    return Produk(
      id: id ?? this.id,
      nama: nama ?? this.nama,
      barcode: barcode ?? this.barcode,
      hargaBeli: hargaBeli ?? this.hargaBeli,
      hargaJual: hargaJual ?? this.hargaJual,
      stok: stok ?? this.stok,
      stokMinimum: stokMinimum ?? this.stokMinimum,
      kategori: kategori ?? this.kategori,
      satuan: satuan ?? this.satuan,
      imageUrl: imageUrl ?? this.imageUrl,
      isArchived: isArchived ?? this.isArchived,
      updatedAt: updatedAt ?? this.updatedAt,
      createdAt: createdAt ?? this.createdAt,
      satuanList: satuanList ?? this.satuanList,
    );
  }

  @override
  List<Object?> get props => [
    id, nama, barcode, hargaBeli, hargaJual,
    stok, stokMinimum, kategori, satuan, imageUrl, isArchived, updatedAt, createdAt, satuanList,
  ];
}
