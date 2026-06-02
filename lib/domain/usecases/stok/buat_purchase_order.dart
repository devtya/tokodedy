import 'package:injectable/injectable.dart';
import '../../../data/database/app_database.dart';
import '../../entities/purchase_order.dart';
import '../../entities/purchase_order_item.dart';
import '../../repositories/purchase_order_repository.dart';

@lazySingleton
class BuatPurchaseOrder {
  final PurchaseOrderRepository repository;
  final AppDatabase db;

  BuatPurchaseOrder({
    required this.repository,
    required this.db,
  });

  Future<String> call({
    required String? supplierId,
    required String? namaSupplier,
    required List<PurchaseOrderItem> items,
    String? notes,
  }) async {
    return db.transaction(() async {
      final totalHarga = items.fold(0.0, (sum, item) => sum + item.subtotal);

      final poId = await repository.addPurchaseOrder(
        PurchaseOrder(
          supplierId: supplierId,
          namaSupplier: namaSupplier,
          totalHarga: totalHarga,
          notes: notes,
        ),
      );

      for (final item in items) {
        await repository.addPurchaseOrderItem(
          item.copyWith(poId: poId),
        );
      }

      return poId;
    });
  }
}
