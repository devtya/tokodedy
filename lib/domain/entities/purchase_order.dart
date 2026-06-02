import 'package:equatable/equatable.dart';

class PurchaseOrder extends Equatable {
  final String? id; // UUID
  final String? supplierId; // UUID FK ke supplier
  final String? namaSupplier;
  final String status; // open, partial, received, cancelled
  final double totalHarga;
  final String? notes;
  final DateTime? updatedAt;
  final DateTime? createdAt;
  final List<dynamic>? items; // List<PurchaseOrderItem>

  const PurchaseOrder({
    this.id,
    this.supplierId,
    this.namaSupplier,
    this.status = 'open',
    required this.totalHarga,
    this.notes,
    this.updatedAt,
    this.createdAt,
    this.items,
  });

  PurchaseOrder copyWith({
    String? id,
    String? supplierId,
    String? namaSupplier,
    String? status,
    double? totalHarga,
    String? notes,
    DateTime? updatedAt,
    DateTime? createdAt,
    List<dynamic>? items,
  }) {
    return PurchaseOrder(
      id: id ?? this.id,
      supplierId: supplierId ?? this.supplierId,
      namaSupplier: namaSupplier ?? this.namaSupplier,
      status: status ?? this.status,
      totalHarga: totalHarga ?? this.totalHarga,
      notes: notes ?? this.notes,
      updatedAt: updatedAt ?? this.updatedAt,
      createdAt: createdAt ?? this.createdAt,
      items: items ?? this.items,
    );
  }

  @override
  List<Object?> get props => [
    id, supplierId, namaSupplier, status, totalHarga, notes, updatedAt, createdAt,
  ];
}
