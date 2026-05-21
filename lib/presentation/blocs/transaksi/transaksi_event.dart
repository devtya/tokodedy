import 'package:equatable/equatable.dart';

abstract class TransaksiEvent extends Equatable {
  const TransaksiEvent();
  @override
  List<Object?> get props => [];
}

class LoadTransaksi extends TransaksiEvent {}

class LoadTransaksiDetail extends TransaksiEvent {
  final String id;
  const LoadTransaksiDetail(this.id);
  @override
  List<Object?> get props => [id];
}
