import 'package:equatable/equatable.dart';

abstract class PurchaseOrderEvent extends Equatable {
  const PurchaseOrderEvent();
  @override
  List<Object?> get props => [];
}

class LoadPurchaseOrders extends PurchaseOrderEvent {}

class AddPurchaseOrderEvent extends PurchaseOrderEvent {
  final String? supplierId;
  final String namaSupplier;
  final List<ItemPoData> items;
  final String? notes;

  const AddPurchaseOrderEvent({
    this.supplierId,
    required this.namaSupplier,
    required this.items,
    this.notes,
  });

  @override
  List<Object?> get props => [supplierId, namaSupplier, items, notes];
}

class CancelPurchaseOrderEvent extends PurchaseOrderEvent {
  final String poId;
  const CancelPurchaseOrderEvent(this.poId);

  @override
  List<Object?> get props => [poId];
}

class EditPurchaseOrderEvent extends PurchaseOrderEvent {
  final String poId;
  final String? supplierId;
  final String namaSupplier;
  final List<ItemPoData> items;
  final String? notes;

  const EditPurchaseOrderEvent({
    required this.poId,
    this.supplierId,
    required this.namaSupplier,
    required this.items,
    this.notes,
  });

  @override
  List<Object?> get props => [poId, supplierId, namaSupplier, items, notes];
}

class ItemPoData {
  final String produkId;
  final String namaProduk;
  final int qtyPesan;
  final double hargaSatuan;
  final double subtotal;
  final String? satuanId;
  final double konversi;

  const ItemPoData({
    required this.produkId,
    required this.namaProduk,
    required this.qtyPesan,
    required this.hargaSatuan,
    required this.subtotal,
    this.satuanId,
    this.konversi = 1.0,
  });
}
