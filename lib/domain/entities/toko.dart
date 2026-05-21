import 'package:equatable/equatable.dart';

class Toko extends Equatable {
  final String? id; // UUID
  final String nama;
  final String? alamat;
  final String? telepon;
  final String? ownerId; // Supabase Auth UUID
  final DateTime? createdAt;

  const Toko({
    this.id,
    required this.nama,
    this.alamat,
    this.telepon,
    this.ownerId,
    this.createdAt,
  });

  Toko copyWith({
    String? id,
    String? nama,
    String? alamat,
    String? telepon,
    String? ownerId,
    DateTime? createdAt,
  }) {
    return Toko(
      id: id ?? this.id,
      nama: nama ?? this.nama,
      alamat: alamat ?? this.alamat,
      telepon: telepon ?? this.telepon,
      ownerId: ownerId ?? this.ownerId,
      createdAt: createdAt ?? this.createdAt,
    );
  }

  @override
  List<Object?> get props => [id, nama, alamat, telepon, ownerId, createdAt];
}
