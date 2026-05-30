import 'package:equatable/equatable.dart';

import '../../../domain/entities/hutang_piutang.dart';
import '../../../domain/entities/produk.dart';
import '../../../domain/entities/transaksi.dart';
import '../../../domain/repositories/laporan_repository.dart';

abstract class LaporanState extends Equatable {
  const LaporanState();

  @override
  List<Object?> get props => [];
}

class LaporanInitial extends LaporanState {}

class LaporanLoading extends LaporanState {
  final int tabIndex;
  const LaporanLoading({this.tabIndex = 0});

  @override
  List<Object?> get props => [tabIndex];
}

class LaporanError extends LaporanState {
  final String message;
  const LaporanError(this.message);

  @override
  List<Object?> get props => [message];
}

// Tab 0: Ringkasan (existing)
class LaporanLoaded extends LaporanState {
  final double omsetHariIni;
  final int totalTransaksi;
  final List<Transaksi> transaksiHariIni;

  const LaporanLoaded({
    this.omsetHariIni = 0,
    this.totalTransaksi = 0,
    this.transaksiHariIni = const [],
  });

  @override
  List<Object?> get props => [omsetHariIni, totalTransaksi, transaksiHariIni];
}

// Tab 1: Laba Rugi
class LaporanLabaRugiLoaded extends LaporanState {
  final List<LabaRugiItem> items;
  final double totalLabaKotor;
  final double totalOmzet;

  const LaporanLabaRugiLoaded({
    required this.items,
    required this.totalLabaKotor,
    required this.totalOmzet,
  });

  @override
  List<Object?> get props => [items, totalLabaKotor, totalOmzet];
}

// Tab 2: Produk Terlaris
class LaporanTerlarisLoaded extends LaporanState {
  final List<ProdukTerlarisItem> items;

  const LaporanTerlarisLoaded({required this.items});

  @override
  List<Object?> get props => [items];
}

// Tab 3: Ringkasan Hutang
class LaporanHutangLoaded extends LaporanState {
  final List<HutangPiutang> hutangList;
  final double totalOutstanding;
  final double totalLunas;
  final int pelangganOutstanding;

  const LaporanHutangLoaded({
    required this.hutangList,
    required this.totalOutstanding,
    required this.totalLunas,
    required this.pelangganOutstanding,
  });

  @override
  List<Object?> get props => [hutangList, totalOutstanding, totalLunas, pelangganOutstanding];
}

// Tab 4: Arus Kas
class LaporanArusKasLoaded extends LaporanState {
  final List<ArusKasItem> items;
  final double totalPemasukan;
  final double totalPengeluaran;
  final double saldoBersih;

  const LaporanArusKasLoaded({
    required this.items,
    required this.totalPemasukan,
    required this.totalPengeluaran,
    required this.saldoBersih,
  });

  @override
  List<Object?> get props => [items, totalPemasukan, totalPengeluaran, saldoBersih];
}

// Tab 5: Stok Menipis
class LaporanStokLoaded extends LaporanState {
  final List<Produk> produkList;

  const LaporanStokLoaded({required this.produkList});

  @override
  List<Object?> get props => [produkList];
}
