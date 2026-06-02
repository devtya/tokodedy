import 'package:equatable/equatable.dart';

class Supplier extends Equatable {
  final String? id; // UUID
  final String nama;
  final String? telepon;
  final String? alamat;
  final DateTime? updatedAt;
  final DateTime? createdAt;

  const Supplier({
    this.id,
    required this.nama,
    this.telepon,
    this.alamat,
    this.updatedAt,
    this.createdAt,
  });

  Supplier copyWith({
    String? id,
    String? nama,
    String? telepon,
    String? alamat,
    DateTime? updatedAt,
    DateTime? createdAt,
  }) {
    return Supplier(
      id: id ?? this.id,
      nama: nama ?? this.nama,
      telepon: telepon ?? this.telepon,
      alamat: alamat ?? this.alamat,
      updatedAt: updatedAt ?? this.updatedAt,
      createdAt: createdAt ?? this.createdAt,
    );
  }

  @override
  List<Object?> get props => [id, nama, telepon, alamat, updatedAt, createdAt];
}
