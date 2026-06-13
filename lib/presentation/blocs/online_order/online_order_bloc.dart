import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:injectable/injectable.dart';
import '../../../domain/entities/online_order.dart';
import '../../../domain/repositories/online_order_repository.dart';
import '../../../domain/usecases/transaksi/selesaikan_online_order.dart'
    as usecase;
import 'dart:async';
import '../../../data/services/supabase_sync_service.dart';

part 'online_order_event.dart';
part 'online_order_state.dart';

@injectable
class OnlineOrderBloc extends Bloc<OnlineOrderEvent, OnlineOrderState> {
  final OnlineOrderRepository _repository;
  final SupabaseSyncService _syncService;
  final usecase.SelesaikanOnlineOrder _selesaikanOnlineOrder;
  StreamSubscription? _realtimeSub;

  OnlineOrderBloc(
    this._repository,
    this._syncService,
    this._selesaikanOnlineOrder,
  ) : super(OnlineOrderInitial()) {
    on<LoadPendingOnlineOrders>(_onLoadPendingOnlineOrders);
    on<RefreshOnlineOrders>(_onRefreshOnlineOrders);
    on<ProcessOnlineOrder>(_onProcessOnlineOrder);
    on<SelesaikanOnlineOrder>(_onSelesaikanOnlineOrder);
    on<ToggleItemUnavailable>(_onToggleItemUnavailable);

    _realtimeSub = _syncService.onOnlineOrderReceived.listen((_) {
      add(LoadPendingOnlineOrders());
    });
  }

  @override
  Future<void> close() {
    _realtimeSub?.cancel();
    return super.close();
  }

  Future<void> _onLoadPendingOnlineOrders(
    LoadPendingOnlineOrders event,
    Emitter<OnlineOrderState> emit,
  ) async {
    emit(OnlineOrderLoading());
    try {
      final orders = await _repository.getActiveOrders();
      // Riwayat dimuat secara terpisah agar error di sini tidak crash seluruh halaman
      List<OnlineOrder> history = [];
      try {
        history = await _repository.getRecentCompletedOrders();
      } catch (_) {}
      emit(OnlineOrderLoaded(orders, historyOrders: history));
    } catch (e) {
      emit(OnlineOrderError(e.toString()));
    }
  }

  Future<void> _onRefreshOnlineOrders(
    RefreshOnlineOrders event,
    Emitter<OnlineOrderState> emit,
  ) async {
    try {
      await _syncService.pullOnlineOrdersForce();
      final orders = await _repository.getActiveOrders();
      List<OnlineOrder> history = [];
      try {
        history = await _repository.getRecentCompletedOrders();
      } catch (_) {}
      emit(OnlineOrderLoaded(orders, historyOrders: history));
    } catch (e) {
      try {
        final orders = await _repository.getActiveOrders();
        emit(OnlineOrderLoaded(orders));
      } catch (innerE) {
        emit(OnlineOrderError(innerE.toString()));
      }
    } finally {
      event.completer.complete();
    }
  }

  Future<void> _onProcessOnlineOrder(
    ProcessOnlineOrder event,
    Emitter<OnlineOrderState> emit,
  ) async {
    try {
      await _repository.updateOrderStatus(event.orderId, event.status, newTotal: event.newTotal);
      add(LoadPendingOnlineOrders());
    } catch (e) {
      emit(OnlineOrderError(e.toString()));
    }
  }

  /// Selesaikan pesanan: buat transaksi + potong stok secara atomic
  Future<void> _onSelesaikanOnlineOrder(
    SelesaikanOnlineOrder event,
    Emitter<OnlineOrderState> emit,
  ) async {
    try {
      // Ambil detail pesanan lengkap dengan items terbaru dari DB lokal
      final order = await _repository.getOrderWithItems(event.orderId);
      if (order == null) {
        emit(const OnlineOrderError('Pesanan tidak ditemukan.'));
        return;
      }
      // Buat transaksi + potong stok (atomic)
      await _selesaikanOnlineOrder(order);
      // Update status pesanan → completed (terpisah agar tidak circular DI)
      await _repository.updateOrderStatus(event.orderId, 'completed');
      add(LoadPendingOnlineOrders());
    } catch (e) {
      emit(OnlineOrderError(e.toString()));
    }
  }

  /// Tandai/batalkan tandai item sebagai habis
  Future<void> _onToggleItemUnavailable(
    ToggleItemUnavailable event,
    Emitter<OnlineOrderState> emit,
  ) async {
    try {
      await _repository.markItemUnavailable(event.itemId, event.isUnavailable);
      // Reload dari DB lokal untuk update UI
      final orders = await _repository.getActiveOrders();
      final history = await _repository.getRecentCompletedOrders();
      emit(OnlineOrderLoaded(orders, historyOrders: history));
    } catch (e) {
      emit(OnlineOrderError(e.toString()));
    }
  }
}
