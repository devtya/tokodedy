import 'package:equatable/equatable.dart';

abstract class RiwayatHargaEvent extends Equatable {
  const RiwayatHargaEvent();

  @override
  List<Object?> get props => [];
}

class LoadRiwayatHarga extends RiwayatHargaEvent {
  const LoadRiwayatHarga();
}
