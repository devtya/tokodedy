import 'package:equatable/equatable.dart';

class ItemTransaksi extends Equatable {
  final String? id; // UUID
  final String tokoId; // UUID FK ke toko
  final String transaksiId; // UUID FK ke transaksi
  final String produkId; // UUID FK ke produk
  final String? namaProduk;
  final int jumlah;
  final double hargaSatuan;
  final double subtotal;

  const ItemTransaksi({
    this.id,
    required this.tokoId,
    required this.transaksiId,
    required this.produkId,
    this.namaProduk,
    required this.jumlah,
    required this.hargaSatuan,
    required this.subtotal,
  });

  @override
  List<Object?> get props => [
    id, tokoId, transaksiId, produkId, namaProduk, jumlah, hargaSatuan, subtotal,
  ];
}
