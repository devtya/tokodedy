import 'package:equatable/equatable.dart';

class PendingPembelian extends Equatable {
  final String? id; // UUID
  final String tokoId; // UUID FK ke toko
  final String? supplierId; // UUID FK ke supplier
  final String? namaSupplier;
  final DateTime? createdAt;
  final bool isPpnEnabled;
  final double ppnPercent;

  const PendingPembelian({
    this.id,
    required this.tokoId,
    this.supplierId,
    this.namaSupplier,
    this.createdAt,
    this.isPpnEnabled = false,
    this.ppnPercent = 11.0,
  });

  @override
  List<Object?> get props => [
    id, tokoId, supplierId, namaSupplier, createdAt, isPpnEnabled, ppnPercent,
  ];
}
