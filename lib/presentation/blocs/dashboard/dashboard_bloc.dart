import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../domain/repositories/dashboard_repository.dart';
import 'dashboard_event.dart';
import 'dashboard_state.dart';

class DashboardBloc extends Bloc<DashboardEvent, DashboardState> {
  final DashboardRepository _repository;

  DashboardBloc(this._repository) : super(DashboardInitial()) {
    on<LoadDashboardMetrics>(_onLoadDashboardMetrics);
  }

  Future<void> _onLoadDashboardMetrics(
    LoadDashboardMetrics event,
    Emitter<DashboardState> emit,
  ) async {
    emit(DashboardLoading());
    try {
      final metrics = await _repository.getTodayMetrics();
      emit(DashboardLoaded(metrics));
    } catch (e) {
      emit(DashboardError(e.toString()));
    }
  }
}
