import 'package:equatable/equatable.dart';

class Pembelian extends Equatable {
  final String? id; // UUID
  final String tokoId; // UUID FK ke toko
  final String? supplierId; // UUID FK ke supplier
  final String? namaSupplier;
  final double totalHarga;
  final DateTime? updatedAt;
  final DateTime? createdAt;
  final List<dynamic>? items; // List<ItemPembelian>

  const Pembelian({
    this.id,
    required this.tokoId,
    this.supplierId,
    this.namaSupplier,
    required this.totalHarga,
    this.updatedAt,
    this.createdAt,
    this.items,
  });

  @override
  List<Object?> get props => [
    id, tokoId, supplierId, namaSupplier, totalHarga, updatedAt, createdAt,
  ];
}
