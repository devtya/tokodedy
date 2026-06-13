import 'package:equatable/equatable.dart';

class OnlineOrderItem extends Equatable {
  final String id;
  final String produkId;
  final String namaProduk;
  final double hargaSatuan;
  final int jumlah;
  final double subtotal;
  final String? satuanId;
  final double konversi;
  final bool isUnavailable;

  const OnlineOrderItem({
    required this.id,
    required this.produkId,
    required this.namaProduk,
    required this.hargaSatuan,
    required this.jumlah,
    required this.subtotal,
    this.satuanId,
    required this.konversi,
    this.isUnavailable = false,
  });

  OnlineOrderItem copyWith({bool? isUnavailable}) {
    return OnlineOrderItem(
      id: id,
      produkId: produkId,
      namaProduk: namaProduk,
      hargaSatuan: hargaSatuan,
      jumlah: jumlah,
      subtotal: subtotal,
      satuanId: satuanId,
      konversi: konversi,
      isUnavailable: isUnavailable ?? this.isUnavailable,
    );
  }

  @override
  List<Object?> get props => [
        id,
        produkId,
        namaProduk,
        hargaSatuan,
        jumlah,
        subtotal,
        satuanId,
        konversi,
        isUnavailable,
      ];
}
