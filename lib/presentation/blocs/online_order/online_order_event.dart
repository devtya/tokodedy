part of 'online_order_bloc.dart';

abstract class OnlineOrderEvent extends Equatable {
  const OnlineOrderEvent();

  @override
  List<Object?> get props => [];
}

class LoadPendingOnlineOrders extends OnlineOrderEvent {}

class RefreshOnlineOrders extends OnlineOrderEvent {
  final Completer<void> completer;

  const RefreshOnlineOrders(this.completer);

  @override
  List<Object?> get props => [completer];
}

class ProcessOnlineOrder extends OnlineOrderEvent {
  final String orderId;
  final String status;
  final double? newTotal;

  const ProcessOnlineOrder(this.orderId, this.status, {this.newTotal});

  @override
  List<Object?> get props => [orderId, status, newTotal];
}

/// Selesaikan pesanan: buat transaksi + potong stok + update status ke 'completed'
class SelesaikanOnlineOrder extends OnlineOrderEvent {
  final String orderId;

  const SelesaikanOnlineOrder(this.orderId);

  @override
  List<Object?> get props => [orderId];
}

/// Toggle item pesanan sebagai habis / tersedia kembali
class ToggleItemUnavailable extends OnlineOrderEvent {
  final String orderId;
  final String itemId;
  final bool isUnavailable;

  const ToggleItemUnavailable({
    required this.orderId,
    required this.itemId,
    required this.isUnavailable,
  });

  @override
  List<Object?> get props => [orderId, itemId, isUnavailable];
}
