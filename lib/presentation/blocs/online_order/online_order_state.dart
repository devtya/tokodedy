part of 'online_order_bloc.dart';

abstract class OnlineOrderState extends Equatable {
  const OnlineOrderState();
  
  @override
  List<Object?> get props => [];
}

class OnlineOrderInitial extends OnlineOrderState {}

class OnlineOrderLoading extends OnlineOrderState {}

class OnlineOrderLoaded extends OnlineOrderState {
  final List<OnlineOrder> orders;
  /// Pesanan selesai / dibatalkan 14 hari terakhir (untuk tab Riwayat)
  final List<OnlineOrder> historyOrders;

  const OnlineOrderLoaded(this.orders, {this.historyOrders = const []});

  @override
  List<Object?> get props => [orders, historyOrders];
}

class OnlineOrderError extends OnlineOrderState {
  final String message;

  const OnlineOrderError(this.message);

  @override
  List<Object?> get props => [message];
}
