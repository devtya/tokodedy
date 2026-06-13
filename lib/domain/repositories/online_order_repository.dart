import '../entities/online_order.dart';

abstract class OnlineOrderRepository {
  Future<List<OnlineOrder>> getActiveOrders();
  /// Ambil pesanan selesai / dibatalkan dalam [days] hari terakhir (default 14)
  Future<List<OnlineOrder>> getRecentCompletedOrders({int days = 14});
  Future<void> updateOrderStatus(String id, String status, {double? newTotal});
  Future<OnlineOrder?> getOrderWithItems(String id);
  Future<void> markItemUnavailable(String itemId, bool isUnavailable);
}
