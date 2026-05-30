import 'package:equatable/equatable.dart';

abstract class LaporanEvent extends Equatable {
  const LaporanEvent();

  @override
  List<Object?> get props => [];
}

class LoadLaporan extends LaporanEvent {
  final int tabIndex; // 0=ringkasan, 1=laba-rugi, 2=terlaris, 3=hutang, 4=arus-kas, 5=stok
  final DateTime? startDate;
  final DateTime? endDate;

  const LoadLaporan({
    this.tabIndex = 0,
    this.startDate,
    this.endDate,
  });

  @override
  List<Object?> get props => [tabIndex, startDate, endDate];
}
