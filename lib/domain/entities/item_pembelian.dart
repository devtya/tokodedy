import 'package:equatable/equatable.dart';

class ItemPembelian extends Equatable {
  final String? id; // UUID
  final String tokoId; // UUID FK ke toko
  final String pembelianId; // UUID FK ke pembelian
  final String produkId; // UUID FK ke produk
  final String? namaProduk;
  final int jumlah;
  final double hargaBeliSatuan;
  final double subtotal;
  // null = satuan dasar, non-null = SatuanProduk.id (UUID)
  final String? satuanId;
  // 1.0 = satuan dasar, >1.0 = satuan konversi (misal karton=10 pcs)
  final double konversi;

  const ItemPembelian({
    this.id,
    required this.tokoId,
    required this.pembelianId,
    required this.produkId,
    this.namaProduk,
    required this.jumlah,
    required this.hargaBeliSatuan,
    required this.subtotal,
    this.satuanId,
    this.konversi = 1.0,
  });

  ItemPembelian copyWith({
    String? id,
    String? tokoId,
    String? pembelianId,
    String? produkId,
    String? namaProduk,
    int? jumlah,
    double? hargaBeliSatuan,
    double? subtotal,
    String? satuanId,
    double? konversi,
  }) {
    return ItemPembelian(
      id: id ?? this.id,
      tokoId: tokoId ?? this.tokoId,
      pembelianId: pembelianId ?? this.pembelianId,
      produkId: produkId ?? this.produkId,
      namaProduk: namaProduk ?? this.namaProduk,
      jumlah: jumlah ?? this.jumlah,
      hargaBeliSatuan: hargaBeliSatuan ?? this.hargaBeliSatuan,
      subtotal: subtotal ?? this.subtotal,
      satuanId: satuanId ?? this.satuanId,
      konversi: konversi ?? this.konversi,
    );
  }

  @override
  List<Object?> get props => [
    id, tokoId, pembelianId, produkId, namaProduk, jumlah,
    hargaBeliSatuan, subtotal, satuanId, konversi,
  ];
}
