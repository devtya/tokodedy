import 'package:injectable/injectable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../domain/entities/purchase_order_item.dart';
import '../../../domain/repositories/purchase_order_repository.dart';
import '../../../domain/usecases/stok/batalkan_purchase_order.dart';
import '../../../domain/usecases/stok/buat_purchase_order.dart';
import '../../../domain/usecases/stok/edit_purchase_order.dart';
import 'purchase_order_event.dart';
import 'purchase_order_state.dart';

@injectable
class PurchaseOrderBloc extends Bloc<PurchaseOrderEvent, PurchaseOrderState> {
  final PurchaseOrderRepository repository;
  final BuatPurchaseOrder buatPurchaseOrder;
  final BatalkanPurchaseOrder batalkanPurchaseOrder;
  final EditPurchaseOrder editPurchaseOrder;

  PurchaseOrderBloc({
    required this.repository,
    required this.buatPurchaseOrder,
    required this.batalkanPurchaseOrder,
    required this.editPurchaseOrder,
  }) : super(PurchaseOrderInitial()) {
    on<LoadPurchaseOrders>(_onLoad);
    on<AddPurchaseOrderEvent>(_onAdd);
    on<CancelPurchaseOrderEvent>(_onCancel);
    on<EditPurchaseOrderEvent>(_onEdit);
  }

  Future<void> _onLoad(
    LoadPurchaseOrders event,
    Emitter<PurchaseOrderState> emit,
  ) async {
    emit(PurchaseOrderLoading());
    try {
      final list = await repository.getAllPurchaseOrders();
      emit(PurchaseOrdersLoaded(list));
    } catch (e) {
      emit(PurchaseOrderError(e.toString()));
    }
  }

  Future<void> _onAdd(
    AddPurchaseOrderEvent event,
    Emitter<PurchaseOrderState> emit,
  ) async {
    try {
      final items = event.items
          .map(
            (d) => PurchaseOrderItem(
              produkId: d.produkId,
              poId: '',
              qtyPesan: d.qtyPesan,
              hargaSatuan: d.hargaSatuan,
              subtotal: d.subtotal,
              satuanId: d.satuanId,
              konversi: d.konversi,
            ),
          )
          .toList();
      await buatPurchaseOrder(
        supplierId: event.supplierId,
        namaSupplier: event.namaSupplier,
        items: items,
        notes: event.notes,
      );
      emit(const PurchaseOrderSuccess('Purchase Order berhasil dibuat'));
      add(LoadPurchaseOrders());
    } catch (e) {
      emit(PurchaseOrderError(e.toString()));
    }
  }

  Future<void> _onCancel(
    CancelPurchaseOrderEvent event,
    Emitter<PurchaseOrderState> emit,
  ) async {
    try {
      await batalkanPurchaseOrder(event.poId);
      emit(const PurchaseOrderSuccess('Purchase Order berhasil dibatalkan'));
      add(LoadPurchaseOrders());
    } catch (e) {
      emit(PurchaseOrderError(e.toString()));
    }
  }

  Future<void> _onEdit(
    EditPurchaseOrderEvent event,
    Emitter<PurchaseOrderState> emit,
  ) async {
    try {
      final items = event.items
          .map(
            (d) => PurchaseOrderItem(
              produkId: d.produkId,
              poId: event.poId,
              qtyPesan: d.qtyPesan,
              hargaSatuan: d.hargaSatuan,
              subtotal: d.subtotal,
              satuanId: d.satuanId,
              konversi: d.konversi,
            ),
          )
          .toList();
      await editPurchaseOrder(
        poId: event.poId,
        supplierId: event.supplierId,
        namaSupplier: event.namaSupplier,
        newItems: items,
        notes: event.notes,
      );
      emit(const PurchaseOrderSuccess('Purchase Order berhasil diperbarui'));
      add(LoadPurchaseOrders());
    } catch (e) {
      emit(PurchaseOrderError(e.toString()));
    }
  }
}
