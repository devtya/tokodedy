import 'package:injectable/injectable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../domain/repositories/laporan_repository.dart';
import '../../../domain/repositories/transaksi_repository.dart';
import 'laporan_event.dart';
import 'laporan_state.dart';

@injectable
class LaporanBloc extends Bloc<LaporanEvent, LaporanState> {
  final TransaksiRepository transaksiRepository;
  final LaporanRepository laporanRepository;

  LaporanBloc({
    required this.transaksiRepository,
    required this.laporanRepository,
  }) : super(LaporanInitial()) {
    on<LoadLaporan>(_onLoad);
  }

  Future<void> _onLoad(LoadLaporan event, Emitter<LaporanState> emit) async {
    emit(LaporanLoading(tabIndex: event.tabIndex));
    try {
      switch (event.tabIndex) {
        case 0:
          await _loadRingkasan(emit);
          break;
        case 1:
          await _loadLabaRugi(event, emit);
          break;
        case 2:
          await _loadTerlaris(event, emit);
          break;
        case 3:
          await _loadHutang(emit);
          break;
        case 4:
          await _loadArusKas(event, emit);
          break;
        case 5:
          await _loadStokMenipis(emit);
          break;
      }
    } catch (e) {
      emit(LaporanError(e.toString()));
    }
  }

  Future<void> _loadRingkasan(Emitter<LaporanState> emit) async {
    final today = DateTime.now();
    final transaksiList = await transaksiRepository.getTransaksiByDate(today);
    final omset = transaksiList.fold(
      0.0,
      (sum, t) => sum + (t.status == 'lunas' ? t.totalHarga : 0),
    );
    emit(LaporanLoaded(
      omsetHariIni: omset,
      totalTransaksi: transaksiList.length,
      transaksiHariIni: transaksiList,
    ));
  }

  Future<void> _loadLabaRugi(LoadLaporan event, Emitter<LaporanState> emit) async {
    final start = event.startDate ?? DateTime.now().subtract(const Duration(days: 30));
    final end = event.endDate ?? DateTime.now();
    final items = await laporanRepository.getLabaRugi(startDate: start, endDate: end);

    final totalOmzet = items.fold(0.0, (s, i) => s + i.totalHargaJual);
    final totalLaba = items.fold(0.0, (s, i) => s + i.labaKotor);

    emit(LaporanLabaRugiLoaded(
      items: items,
      totalLabaKotor: totalLaba,
      totalOmzet: totalOmzet,
    ));
  }

  Future<void> _loadTerlaris(LoadLaporan event, Emitter<LaporanState> emit) async {
    final start = event.startDate ?? DateTime.now().subtract(const Duration(days: 30));
    final end = event.endDate ?? DateTime.now();
    final items = await laporanRepository.getProdukTerlaris(startDate: start, endDate: end);
    emit(LaporanTerlarisLoaded(items: items));
  }

  Future<void> _loadHutang(Emitter<LaporanState> emit) async {
    final hutangList = await laporanRepository.getRingkasanHutang();
    final totalOutstanding = hutangList
        .where((h) => h.status == 'belum_lunas')
        .fold(0.0, (s, h) => s + h.jumlah);
    final totalLunas = hutangList
        .where((h) => h.status == 'lunas')
        .fold(0.0, (s, h) => s + h.jumlah);
    final pelangganOutstanding = hutangList
        .where((h) => h.status == 'belum_lunas')
        .map((h) => h.namaPelanggan)
        .toSet()
        .length;

    emit(LaporanHutangLoaded(
      hutangList: hutangList,
      totalOutstanding: totalOutstanding,
      totalLunas: totalLunas,
      pelangganOutstanding: pelangganOutstanding,
    ));
  }

  Future<void> _loadArusKas(LoadLaporan event, Emitter<LaporanState> emit) async {
    final start = event.startDate ?? DateTime.now().subtract(const Duration(days: 7));
    final end = event.endDate ?? DateTime.now();
    final items = await laporanRepository.getArusKas(startDate: start, endDate: end);

    final totalPemasukan = items.fold(0.0, (s, i) => s + i.pemasukan);
    final totalPengeluaran = items.fold(0.0, (s, i) => s + i.pengeluaran);

    emit(LaporanArusKasLoaded(
      items: items,
      totalPemasukan: totalPemasukan,
      totalPengeluaran: totalPengeluaran,
      saldoBersih: totalPemasukan - totalPengeluaran,
    ));
  }

  Future<void> _loadStokMenipis(Emitter<LaporanState> emit) async {
    final produkList = await laporanRepository.getStokMenipis();
    emit(LaporanStokLoaded(produkList: produkList));
  }
}
