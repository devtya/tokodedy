import '../entities/pending_order.dart';

abstract class PendingOrderRepository {
  Future<List<PendingOrder>> getAllPending();
  Future<PendingOrder?> getPendingById(String id);
  Future<String> addPending(PendingOrder pending);
  Future<void> deletePending(String id);
  Future<List<CartItemData>> getItemsByPendingId(String pendingId);
  Future<void> addItem(String pendingId, CartItemData item);
}

class CartItemData {
  final String? id; // UUID
  final String produkId; // UUID
  final String namaProduk;
  final double hargaJual;
  final int jumlah;
  final int diskonTipe;
  final double diskonValue;
  final double subtotal;

  const CartItemData({
    this.id,
    required this.produkId,
    required this.namaProduk,
    required this.hargaJual,
    required this.jumlah,
    this.diskonTipe = 0,
    this.diskonValue = 0,
    this.subtotal = 0,
  });
}
