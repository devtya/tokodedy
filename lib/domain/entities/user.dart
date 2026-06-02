import 'package:equatable/equatable.dart';

/// User/Profile entity — linked ke Supabase Auth.
/// id = Supabase Auth UUID
class User extends Equatable {
  final String? id; // UUID = Supabase Auth UID
  final String? nama;
  final String role; // 'owner' | 'kasir'
  final String? email; // dari Supabase Auth (read-only, tidak disimpan di Drift)
  final DateTime? createdAt;

  const User({
    this.id,
    this.nama,
    required this.role,
    this.email,
    this.createdAt,
  });

  bool get isOwner => role == 'owner';
  bool get isKasir => role == 'kasir';

  User copyWith({
    String? id,
    String? nama,
    String? role,
    String? email,
    DateTime? createdAt,
  }) {
    return User(
      id: id ?? this.id,
      nama: nama ?? this.nama,
      role: role ?? this.role,
      email: email ?? this.email,
      createdAt: createdAt ?? this.createdAt,
    );
  }

  @override
  List<Object?> get props => [id, nama, role, email, createdAt];
}
