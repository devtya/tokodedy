import 'package:equatable/equatable.dart';

class Toko extends Equatable {
  final String? id; // UUID
  final String nama;
  final String? alamat;
  final String? telepon;
  final String? ownerId; // Supabase Auth UUID
  final int stokMinimumGlobal;
  final DateTime? createdAt;

  const Toko({
    this.id,
    required this.nama,
    this.alamat,
    this.telepon,
    this.ownerId,
    this.stokMinimumGlobal = 0,
    this.createdAt,
  });

  Toko copyWith({
    String? id,
    String? nama,
    String? alamat,
    String? telepon,
    String? ownerId,
    int? stokMinimumGlobal,
    DateTime? createdAt,
  }) {
    return Toko(
      id: id ?? this.id,
      nama: nama ?? this.nama,
      alamat: alamat ?? this.alamat,
      telepon: telepon ?? this.telepon,
      ownerId: ownerId ?? this.ownerId,
      stokMinimumGlobal: stokMinimumGlobal ?? this.stokMinimumGlobal,
      createdAt: createdAt ?? this.createdAt,
    );
  }

  @override
  List<Object?> get props => [id, nama, alamat, telepon, ownerId, stokMinimumGlobal, createdAt];
}
