import 'package:injectable/injectable.dart';
import '../../repositories/purchase_order_repository.dart';

@lazySingleton
class BatalkanPurchaseOrder {
  final PurchaseOrderRepository repository;

  BatalkanPurchaseOrder(this.repository);

  Future<void> call(String poId) async {
    await repository.updateStatus(poId, 'cancelled');
  }
}
