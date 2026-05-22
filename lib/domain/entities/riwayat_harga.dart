import 'package:equatable/equatable.dart';

class RiwayatHarga extends Equatable {
  final String id;
  final String tokoId;
  final String produkId;
  final String? produkNama; // Joined from ProdukTable
  final double hargaBeliLama;
  final double hargaBeliBaru;
  final double hargaJualLama;
  final double hargaJualBaru;
  final DateTime createdAt;

  const RiwayatHarga({
    required this.id,
    required this.tokoId,
    required this.produkId,
    this.produkNama,
    required this.hargaBeliLama,
    required this.hargaBeliBaru,
    required this.hargaJualLama,
    required this.hargaJualBaru,
    required this.createdAt,
  });

  bool get isHargaBeliNaik => hargaBeliBaru > hargaBeliLama;
  bool get isHargaBeliTurun => hargaBeliBaru < hargaBeliLama;
  bool get isHargaJualNaik => hargaJualBaru > hargaJualLama;
  bool get isHargaJualTurun => hargaJualBaru < hargaJualLama;

  @override
  List<Object?> get props => [
        id,
        tokoId,
        produkId,
        produkNama,
        hargaBeliLama,
        hargaBeliBaru,
        hargaJualLama,
        hargaJualBaru,
        createdAt,
      ];
}
