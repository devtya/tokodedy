import 'package:equatable/equatable.dart';

abstract class KasHarianEvent extends Equatable {
  const KasHarianEvent();

  @override
  List<Object?> get props => [];
}

class LoadKasHarian extends KasHarianEvent {
  final DateTime date;

  const LoadKasHarian(this.date);

  @override
  List<Object?> get props => [date];
}

class SetModalAwalEvent extends KasHarianEvent {
  final double jumlah;
  final String? keterangan;

  const SetModalAwalEvent({required this.jumlah, this.keterangan});

  @override
  List<Object?> get props => [jumlah, keterangan];
}

class AddPengeluaranEvent extends KasHarianEvent {
  final double jumlah;
  final String kategori;
  final String? keterangan;

  const AddPengeluaranEvent({
    required this.jumlah,
    required this.kategori,
    this.keterangan,
  });

  @override
  List<Object?> get props => [jumlah, kategori, keterangan];
}

class DeletePengeluaranEvent extends KasHarianEvent {
  final String id;

  const DeletePengeluaranEvent(this.id);

  @override
  List<Object?> get props => [id];
}

class ChangeDateEvent extends KasHarianEvent {
  final DateTime date;

  const ChangeDateEvent(this.date);

  @override
  List<Object?> get props => [date];
}
