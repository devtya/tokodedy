import 'package:equatable/equatable.dart';

class PendingPembelian extends Equatable {
  final String? id; // UUID
  final String tokoId; // UUID FK ke toko
  final String? supplierId; // UUID FK ke supplier
  final String? namaSupplier;
  final DateTime? createdAt;
  final bool isPpnEnabled;
  final double ppnPercent;
  final int diskonTipe;
  final double diskonPersen;
  final double diskonNominal;

  const PendingPembelian({
    this.id,
    required this.tokoId,
    this.supplierId,
    this.namaSupplier,
    this.createdAt,
    this.isPpnEnabled = false,
    this.ppnPercent = 11.0,
    this.diskonTipe = 0,
    this.diskonPersen = 0,
    this.diskonNominal = 0,
  });

  @override
  List<Object?> get props => [
    id, tokoId, supplierId, namaSupplier, createdAt,
    isPpnEnabled, ppnPercent, diskonTipe, diskonPersen, diskonNominal,
  ];
}
