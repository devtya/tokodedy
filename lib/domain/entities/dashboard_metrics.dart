import 'package:equatable/equatable.dart';

class DashboardMetrics extends Equatable {
  final double omzet;
  final int transaksi;
  final int terjual;

  const DashboardMetrics({
    required this.omzet,
    required this.transaksi,
    required this.terjual,
  });

  @override
  List<Object?> get props => [omzet, transaksi, terjual];
}
