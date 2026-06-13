import 'package:injectable/injectable.dart';
import '../../entities/purchase_order.dart';
import '../../entities/purchase_order_item.dart';
import '../../repositories/purchase_order_repository.dart';

@lazySingleton
class EditPurchaseOrder {
  final PurchaseOrderRepository repository;

  EditPurchaseOrder(this.repository);

  Future<void> call({
    required String poId,
    required String? supplierId,
    required String namaSupplier,
    required List<PurchaseOrderItem> newItems,
    String? notes,
  }) async {
    // Hitung ulang total
    double totalHarga = 0;
    for (var item in newItems) {
      totalHarga += item.subtotal;
    }

    // Update data PO utama
    final updatedPo = PurchaseOrder(
      id: poId,
      supplierId: supplierId,
      namaSupplier: namaSupplier,
      status: 'open',
      totalHarga: totalHarga,
      notes: notes,
      updatedAt: DateTime.now(),
    );
    await repository.updatePurchaseOrder(updatedPo);

    // Hapus semua item lama
    await repository.deleteItemsByPoId(poId);

    // Masukkan item baru
    for (var item in newItems) {
      await repository.addPurchaseOrderItem(
        item.copyWith(poId: poId),
      );
    }
  }
}
