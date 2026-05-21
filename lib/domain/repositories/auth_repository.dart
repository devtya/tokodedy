import '../entities/toko.dart';
import '../entities/user.dart';

abstract class AuthRepository {
  /// Login via Supabase Auth (email + password)
  Future<User?> login(String email, String password);

  /// Logout dari Supabase Auth + clear local session
  Future<void> logout();

  /// Ambil user yang sedang login dari sesi lokal (cepat, tanpa network)
  User? getCurrentUser();

  /// Ambil profil user terkini dari Supabase (untuk refresh)
  Future<User?> fetchCurrentUser();

  /// Ambil semua user dalam satu toko (hanya owner)
  Future<List<User>> getAllUsers();

  /// Undang kasir baru via Supabase email invite
  /// Kasir akan terima email dengan link untuk set password
  Future<void> inviteKasir({
    required String email,
    String? nama,
  });

  /// Update nama kasir (owner only)
  Future<void> updateUser(User user);

  /// Hapus kasir dari toko (owner only)
  Future<void> deleteUser(String id);

  /// Daftar toko baru:
  /// 1. Buat akun Supabase Auth (email+password)
  /// 2. Insert toko ke Supabase
  /// 3. Insert profile owner ke Supabase
  /// 4. Simpan session lokal
  Future<User> registerStore({
    required String namaToko,
    String? alamat,
    String? telepon,
    required String email,
    required String password,
    String? nama,
  });

  /// Ambil info toko dari Supabase
  Future<Toko?> fetchToko();

  /// Update info toko (nama, alamat, telepon)
  Future<void> updateToko(Toko toko);
}
