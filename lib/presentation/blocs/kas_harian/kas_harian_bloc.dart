import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';

import '../../../../domain/entities/kas_harian.dart';
import '../../../../domain/entities/pengeluaran_operasional.dart';
import '../../../../domain/usecases/kas/add_pengeluaran.dart';
import '../../../../domain/usecases/kas/delete_pengeluaran.dart';
import '../../../../domain/usecases/kas/get_kas_daily_summary.dart';
import '../../../../domain/usecases/kas/set_modal_awal.dart';
import 'kas_harian_event.dart';
import 'kas_harian_state.dart';

@injectable
class KasHarianBloc extends Bloc<KasHarianEvent, KasHarianState> {
  final GetKasDailySummary _getKasDailySummary;
  final SetModalAwal _setModalAwal;
  final AddPengeluaran _addPengeluaran;
  final DeletePengeluaran _deletePengeluaran;

  DateTime _currentDate = DateTime.now();

  KasHarianBloc(
    this._getKasDailySummary,
    this._setModalAwal,
    this._addPengeluaran,
    this._deletePengeluaran,
  ) : super(KasHarianInitial()) {
    on<LoadKasHarian>(_onLoadKasHarian);
    on<SetModalAwalEvent>(_onSetModalAwal);
    on<AddPengeluaranEvent>(_onAddPengeluaran);
    on<DeletePengeluaranEvent>(_onDeletePengeluaran);
    on<ChangeDateEvent>(_onChangeDate);
  }

  Future<void> _onLoadKasHarian(LoadKasHarian event, Emitter<KasHarianState> emit) async {
    _currentDate = event.date;
    emit(KasHarianLoading());
    try {
      final summary = await _getKasDailySummary(event.date);
      emit(KasHarianLoaded(summary: summary, selectedDate: event.date));
    } catch (e) {
      emit(KasHarianError(e.toString()));
    }
  }

  Future<void> _onSetModalAwal(SetModalAwalEvent event, Emitter<KasHarianState> emit) async {
    try {
      final kasHarian = KasHarian(
        modalAwal: event.jumlah,
        keterangan: event.keterangan,
        tanggal: _currentDate,
      );
      await _setModalAwal(kasHarian);
      add(LoadKasHarian(_currentDate));
    } catch (e) {
      emit(KasHarianError(e.toString()));
    }
  }

  Future<void> _onAddPengeluaran(AddPengeluaranEvent event, Emitter<KasHarianState> emit) async {
    try {
      final pengeluaran = PengeluaranOperasional(
        jumlah: event.jumlah,
        kategori: event.kategori,
        keterangan: event.keterangan,
        tanggal: _currentDate,
      );
      await _addPengeluaran(pengeluaran);
      add(LoadKasHarian(_currentDate));
    } catch (e) {
      emit(KasHarianError(e.toString()));
    }
  }

  Future<void> _onDeletePengeluaran(DeletePengeluaranEvent event, Emitter<KasHarianState> emit) async {
    try {
      await _deletePengeluaran(event.id);
      add(LoadKasHarian(_currentDate));
    } catch (e) {
      emit(KasHarianError(e.toString()));
    }
  }

  void _onChangeDate(ChangeDateEvent event, Emitter<KasHarianState> emit) {
    add(LoadKasHarian(event.date));
  }
}
