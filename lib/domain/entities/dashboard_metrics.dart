import 'package:equatable/equatable.dart';

import 'produk.dart';
import 'riwayat_harga.dart';

class DashboardMetrics extends Equatable {
  final double omzet;
  final int transaksi;
  final int terjual;
  final List<Produk> stokMenipis;
  final List<RiwayatHarga> updateHargaTerakhir;

  const DashboardMetrics({
    required this.omzet,
    required this.transaksi,
    required this.terjual,
    required this.stokMenipis,
    required this.updateHargaTerakhir,
  });

  @override
  List<Object?> get props => [
    omzet, 
    transaksi, 
    terjual, 
    stokMenipis, 
    updateHargaTerakhir,
  ];
}
