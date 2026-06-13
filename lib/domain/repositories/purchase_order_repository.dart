import '../entities/purchase_order.dart';
import '../entities/purchase_order_item.dart';

abstract class PurchaseOrderRepository {
  Future<List<PurchaseOrder>> getAllPurchaseOrders();
  Future<PurchaseOrder?> getPurchaseOrderById(String id);
  Future<String> addPurchaseOrder(PurchaseOrder po);
  Future<void> updatePurchaseOrder(PurchaseOrder po);
  Future<void> addPurchaseOrderItem(PurchaseOrderItem item);
  Future<void> updatePurchaseOrderItem(PurchaseOrderItem item);
  Future<List<PurchaseOrderItem>> getItemsByPoId(String poId);
  Future<void> updateStatus(String id, String status);
  Future<void> deleteItemsByPoId(String poId);
  Future<void> deletePurchaseOrder(String id);
}
