import 'package:equatable/equatable.dart';

class PurchaseOrderItem extends Equatable {
  final String? id; // UUID
  final String poId; // UUID FK ke purchase_order
  final String produkId; // UUID FK ke produk
  final String? namaProduk;
  final int qtyPesan;
  final int qtyTerima;
  final double hargaSatuan;
  final double subtotal;
  final String? satuanId;
  final double konversi;

  const PurchaseOrderItem({
    this.id,
    required this.poId,
    required this.produkId,
    this.namaProduk,
    required this.qtyPesan,
    this.qtyTerima = 0,
    required this.hargaSatuan,
    required this.subtotal,
    this.satuanId,
    this.konversi = 1.0,
  });

  PurchaseOrderItem copyWith({
    String? id,
    String? poId,
    String? produkId,
    String? namaProduk,
    int? qtyPesan,
    int? qtyTerima,
    double? hargaSatuan,
    double? subtotal,
    String? satuanId,
    double? konversi,
  }) {
    return PurchaseOrderItem(
      id: id ?? this.id,
      poId: poId ?? this.poId,
      produkId: produkId ?? this.produkId,
      namaProduk: namaProduk ?? this.namaProduk,
      qtyPesan: qtyPesan ?? this.qtyPesan,
      qtyTerima: qtyTerima ?? this.qtyTerima,
      hargaSatuan: hargaSatuan ?? this.hargaSatuan,
      subtotal: subtotal ?? this.subtotal,
      satuanId: satuanId ?? this.satuanId,
      konversi: konversi ?? this.konversi,
    );
  }

  @override
  List<Object?> get props => [
    id, poId, produkId, namaProduk, qtyPesan, qtyTerima,
    hargaSatuan, subtotal, satuanId, konversi,
  ];
}
