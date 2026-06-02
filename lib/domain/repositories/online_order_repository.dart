import '../entities/online_order.dart';

abstract class OnlineOrderRepository {
  Future<List<OnlineOrder>> getPendingOrders();
  Future<void> updateOrderStatus(String id, String status);
}
