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

  const OnlineOrderLoaded(this.orders);

  @override
  List<Object?> get props => [orders];
}

class OnlineOrderError extends OnlineOrderState {
  final String message;

  const OnlineOrderError(this.message);

  @override
  List<Object?> get props => [message];
}
