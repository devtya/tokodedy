import 'package:equatable/equatable.dart';

class RiwayatPerubahan extends Equatable {
  final String id;
  final String produkId;
  final String kolomDiubah;
  final String nilaiLama;
  final String nilaiBaru;
  final DateTime createdAt;

  const RiwayatPerubahan({
    required this.id,
    required this.produkId,
    required this.kolomDiubah,
    required this.nilaiLama,
    required this.nilaiBaru,
    required this.createdAt,
  });

  @override
  List<Object?> get props => [id, produkId, kolomDiubah, nilaiLama, nilaiBaru, createdAt];
}
