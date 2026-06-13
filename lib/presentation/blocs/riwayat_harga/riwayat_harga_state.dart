import 'package:equatable/equatable.dart';
import '../../../domain/entities/riwayat_harga.dart';

abstract class RiwayatHargaState extends Equatable {
  const RiwayatHargaState();

  @override
  List<Object?> get props => [];
}

class RiwayatHargaInitial extends RiwayatHargaState {}

class RiwayatHargaLoading extends RiwayatHargaState {}

class RiwayatHargaLoaded extends RiwayatHargaState {
  final List<RiwayatHarga> riwayat;

  const RiwayatHargaLoaded(this.riwayat);

  @override
  List<Object?> get props => [riwayat];
}

class RiwayatHargaError extends RiwayatHargaState {
  final String message;

  const RiwayatHargaError(this.message);

  @override
  List<Object?> get props => [message];
}
