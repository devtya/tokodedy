part of 'online_order_bloc.dart';

abstract class OnlineOrderEvent extends Equatable {
  const OnlineOrderEvent();

  @override
  List<Object?> get props => [];
}

class LoadPendingOnlineOrders extends OnlineOrderEvent {}

class ProcessOnlineOrder extends OnlineOrderEvent {
  final String orderId;
  final String status;

  const ProcessOnlineOrder(this.orderId, this.status);

  @override
  List<Object?> get props => [orderId, status];
}
