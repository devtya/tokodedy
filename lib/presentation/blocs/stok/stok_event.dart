import 'package:equatable/equatable.dart';

abstract class StokEvent extends Equatable {
  const StokEvent();
  @override
  List<Object?> get props => [];
}

class LoadRiwayatStok extends StokEvent {
  final String produkId;
  const LoadRiwayatStok(this.produkId);
  @override
  List<Object?> get props => [produkId];
}

class TambahStokEvent extends StokEvent {
  final String produkId;
  final int jumlah;
  final String? keterangan;
  const TambahStokEvent({
    required this.produkId,
    required this.jumlah,
    this.keterangan,
  });
  @override
  List<Object?> get props => [produkId, jumlah, keterangan];
}
