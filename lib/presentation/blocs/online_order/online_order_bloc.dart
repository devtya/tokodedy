import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:injectable/injectable.dart';
import '../../../domain/entities/online_order.dart';
import '../../../domain/repositories/online_order_repository.dart';

part 'online_order_event.dart';
part 'online_order_state.dart';

@injectable
class OnlineOrderBloc extends Bloc<OnlineOrderEvent, OnlineOrderState> {
  final OnlineOrderRepository _repository;

  OnlineOrderBloc(this._repository) : super(OnlineOrderInitial()) {
    on<LoadPendingOnlineOrders>(_onLoadPendingOnlineOrders);
    on<ProcessOnlineOrder>(_onProcessOnlineOrder);
  }

  Future<void> _onLoadPendingOnlineOrders(
    LoadPendingOnlineOrders event,
    Emitter<OnlineOrderState> emit,
  ) async {
    emit(OnlineOrderLoading());
    try {
      final orders = await _repository.getPendingOrders();
      emit(OnlineOrderLoaded(orders));
    } catch (e) {
      emit(OnlineOrderError(e.toString()));
    }
  }

  Future<void> _onProcessOnlineOrder(
    ProcessOnlineOrder event,
    Emitter<OnlineOrderState> emit,
  ) async {
    try {
      await _repository.updateOrderStatus(event.orderId, event.status);
      add(LoadPendingOnlineOrders());
    } catch (e) {
      emit(OnlineOrderError(e.toString()));
    }
  }
}
