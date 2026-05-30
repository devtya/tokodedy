import 'package:injectable/injectable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../domain/repositories/hutang_piutang_repository.dart';
import 'hutang_event.dart';
import 'hutang_state.dart';

@injectable
class HutangBloc extends Bloc<HutangEvent, HutangState> {
  final HutangPiutangRepository repository;

  HutangBloc({required this.repository}) : super(HutangInitial()) {
    on<LoadHutang>(_onLoad);
    on<FilterHutang>(_onFilter);
    on<AddHutangManual>(_onAdd);
    on<LunasHutang>(_onLunas);
  }

  Future<void> _onLoad(LoadHutang event, Emitter<HutangState> emit) async {
    emit(HutangLoading());
    try {
      final list = await repository.getAllHutang();
      final total = list.fold(0.0, (sum, h) => sum + h.jumlah);
      emit(HutangLoaded(hutangList: list, totalPiutang: total));
    } catch (e) {
      emit(HutangError(e.toString()));
    }
  }

  void _onFilter(FilterHutang event, Emitter<HutangState> emit) {
    if (state is HutangLoaded) {
      final current = state as HutangLoaded;
      emit(current.copyWith(filterStatus: event.status));
    }
  }

  Future<void> _onAdd(AddHutangManual event, Emitter<HutangState> emit) async {
    try {
      await repository.addHutang(event.hutang);
      emit(HutangSuccess('Hutang berhasil ditambahkan'));
      add(LoadHutang());
    } catch (e) {
      emit(HutangError(e.toString()));
    }
  }

  Future<void> _onLunas(LunasHutang event, Emitter<HutangState> emit) async {
    try {
      await repository.updateStatus(event.id, 'lunas');
      emit(HutangSuccess('Status diubah menjadi Lunas'));
      add(LoadHutang());
    } catch (e) {
      emit(HutangError(e.toString()));
    }
  }
}
