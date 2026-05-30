import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:supabase_flutter/supabase_flutter.dart' hide User;
import 'package:uuid/uuid.dart';
import 'dart:convert';

import '../../domain/entities/toko.dart';
import '../../domain/entities/user.dart';
import '../../domain/repositories/auth_repository.dart';
import '../../domain/repositories/local_auth_repository.dart';
import '../database/app_database.dart';
import '../../core/services/toko_service.dart';
import 'package:drift/drift.dart' show Value;
import 'local_auth_repository_impl.dart' show LocalAuthRepositoryImpl;

class AuthRepositoryImpl implements AuthRepository {
  final AppDatabase _db;
  final SupabaseClient _supabase;
  final SharedPreferences _prefs;
  final TokoService _tokoService;
  final LocalAuthRepository _localAuth;

  static const _sessionKey = 'current_user_session';

  AuthRepositoryImpl(this._db, this._supabase, this._prefs, this._tokoService)
      : _localAuth = LocalAuthRepositoryImpl(_db, _prefs);

  // ───────────── AUTH ─────────────

  @override
  Future<User?> login(String email, String password) async {
    final response = await _supabase.auth.signInWithPassword(
      email: email,
      password: password,
    );

    final authUser = response.user;
    if (authUser == null) return null;

    // Ambil profile dari Supabase
    final profileData = await _supabase
        .from('profiles')
        .select()
        .eq('id', authUser.id)
        .maybeSingle();

    if (profileData == null) {
      throw Exception('Profil tidak ditemukan. Hubungi pemilik toko.');
    }

    final user = User(
      id: authUser.id,
      tokoId: profileData['toko_id'] as String,
      nama: profileData['nama'] as String?,
      role: profileData['role'] as String? ?? 'kasir',
      email: authUser.email,
      createdAt: DateTime.tryParse(authUser.createdAt),
    );

    // Simpan session lokal
    await _saveSession(user);

    // Upsert ke Drift local cache
    await _upsertLocalProfile(user);

    // Simpan ke TokoService
    final tokoData = await _supabase
        .from('toko')
        .select('nama')
        .eq('id', user.tokoId)
        .maybeSingle();
    final tokoName = tokoData?['nama'] as String? ?? '';
    final stokMin = tokoData?['stok_minimum_global'] as int? ?? 0;
    await _tokoService.save(user.tokoId, tokoName, stokMin);

    return user;
  }

  @override
  Future<void> logout() async {
    await _supabase.auth.signOut();
    await _prefs.remove(_sessionKey);
  }

  @override
  User? getCurrentUser() {
    final json = _prefs.getString(_sessionKey);
    if (json == null) return null;
    try {
      final map = jsonDecode(json) as Map<String, dynamic>;
      return _userFromMap(map);
    } catch (_) {
      return null;
    }
  }

  @override
  Future<User?> fetchCurrentUser() async {
    final authUser = _supabase.auth.currentUser;
    if (authUser == null) return null;

    final profileData = await _supabase
        .from('profiles')
        .select()
        .eq('id', authUser.id)
        .maybeSingle();

    if (profileData == null) return null;

    final user = User(
      id: authUser.id,
      tokoId: profileData['toko_id'] as String,
      nama: profileData['nama'] as String?,
      role: profileData['role'] as String? ?? 'kasir',
      email: authUser.email,
      createdAt: DateTime.tryParse(authUser.createdAt),
    );

    await _saveSession(user);
    await _upsertLocalProfile(user);

    final tokoData = await _supabase
        .from('toko')
        .select('nama')
        .eq('id', user.tokoId)
        .maybeSingle();
    final tokoName = tokoData?['nama'] as String? ?? '';
    final stokMin = tokoData?['stok_minimum_global'] as int? ?? 0;
    await _tokoService.save(user.tokoId, tokoName, stokMin);

    return user;
  }

  // ───────────── REGISTER STORE ─────────────

  @override
  Future<User> registerStore({
    required String namaToko,
    String? alamat,
    String? telepon,
    required String email,
    required String password,
    String? nama,
  }) async {
    // 1. Buat akun Supabase Auth
    debugPrint('[registerStore] signUp dimulai: email=$email');
    final authResponse = await _supabase.auth.signUp(
      email: email,
      password: password,
    );

    final authUser = authResponse.user;
    debugPrint('[registerStore] authUser.id=${authUser?.id}');
    debugPrint('[registerStore] session ada=${authResponse.session != null}');
    debugPrint('[registerStore] currentSession ada=${_supabase.auth.currentSession != null}');
    debugPrint('[registerStore] currentUser email=${_supabase.auth.currentUser?.email}');

    if (authUser == null) {
      throw Exception('Gagal membuat akun. Coba lagi.');
    }

    // 2. Insert toko ke Supabase (generate UUID client-side to avoid RETURNING RLS issues)
    final tokoId = const Uuid().v4();
    debugPrint('[registerStore] insert toko: id=$tokoId owner_id=${authUser.id}');
    try {
      await _supabase.from('toko').insert({
        'id': tokoId,
        'nama': namaToko,
        'alamat': alamat,
        'telepon': telepon,
        'owner_id': authUser.id,
      });
      debugPrint('[registerStore] insert toko BERHASIL');
      await _tokoService.save(tokoId, namaToko, 0);
    } catch (e) {
      debugPrint('[registerStore] insert toko GAGAL: $e');
      rethrow;
    }

    // 3. Insert profile owner
    await _supabase.from('profiles').insert({
      'id': authUser.id,
      'toko_id': tokoId,
      'nama': nama ?? email.split('@').first,
      'role': 'owner',
    });

    final user = User(
      id: authUser.id,
      tokoId: tokoId,
      nama: nama ?? email.split('@').first,
      role: 'owner',
      email: email,
    );

    // 4. Simpan ke lokal
    await _saveSession(user);
    await _upsertLocalToko(tokoId, namaToko, alamat, telepon, authUser.id);
    await _upsertLocalProfile(user);

    return user;
  }

  // ───────────── USER MANAGEMENT ─────────────

  @override
  Future<List<User>> getAllUsers() async {
    final currentUser = getCurrentUser();
    if (currentUser == null) return [];

    final response = await _supabase
        .from('profiles')
        .select()
        .eq('toko_id', currentUser.tokoId)
        .order('created_at');

    final authUsers = <String, String>{}; // uid → email
    // Supabase tidak expose email user lain via client SDK (security).
    // Email hanya untuk user sendiri.

    return (response as List).map((p) {
      return User(
        id: p['id'] as String,
        tokoId: p['toko_id'] as String,
        nama: p['nama'] as String?,
        role: p['role'] as String? ?? 'kasir',
        email: authUsers[p['id']],
        createdAt: p['created_at'] != null
            ? DateTime.tryParse(p['created_at'] as String)
            : null,
      );
    }).toList();
  }

  @override
  Future<void> inviteKasir({
    required String email,
    String? nama,
  }) async {
    final currentUser = getCurrentUser();
    if (currentUser == null) throw Exception('Tidak ada sesi aktif');
    if (!currentUser.isOwner) throw Exception('Hanya owner yang bisa invite kasir');

    // Gunakan Supabase Admin API via Edge Function atau simpan pending invite
    // Karena client SDK tidak bisa invite user lain, kita gunakan signUp dulu
    // kemudian owner set password sementara yang harus diganti kasir.
    // Alternatif: gunakan Supabase Magic Link / OTP
    await _supabase.auth.signInWithOtp(
      email: email,
      emailRedirectTo: 'io.hendkasir.app://login-callback',
      shouldCreateUser: true,
    );

    // Simpan pending profile — akan di-complete saat kasir pertama login
    // (profile insert dilakukan setelah kasir klik link & login)
    await _supabase.from('pending_invites').upsert({
      'email': email,
      'toko_id': currentUser.tokoId,
      'nama': nama,
      'role': 'kasir',
    }, onConflict: 'email');
  }

  @override
  Future<void> updateUser(User user) async {
    final currentUser = getCurrentUser();
    if (currentUser == null) throw Exception('Tidak ada sesi aktif');
    if (!currentUser.isOwner && currentUser.id != user.id) {
      throw Exception('Tidak diizinkan');
    }

    // Validasi user dalam toko yang sama
    final existing = await _supabase
        .from('profiles')
        .select('toko_id')
        .eq('id', user.id!)
        .maybeSingle();

    if (existing == null) throw Exception('User tidak ditemukan');
    if (existing['toko_id'] != currentUser.tokoId) {
      throw Exception('User bukan bagian dari toko ini');
    }

    await _supabase.from('profiles').update({
      'nama': user.nama,
    }).eq('id', user.id!);

    // Update local cache jika update diri sendiri
    if (user.id == currentUser.id) {
      final updated = currentUser.copyWith(nama: user.nama);
      await _saveSession(updated);
    }
  }

  @override
  Future<void> deleteUser(String id) async {
    final currentUser = getCurrentUser();
    if (currentUser == null) throw Exception('Tidak ada sesi aktif');
    if (!currentUser.isOwner) throw Exception('Hanya owner yang bisa hapus user');
    if (id == currentUser.id) throw Exception('Tidak bisa hapus akun sendiri');

    // Validasi user dalam toko yang sama
    final existing = await _supabase
        .from('profiles')
        .select('toko_id')
        .eq('id', id)
        .maybeSingle();

    if (existing == null) throw Exception('User tidak ditemukan');
    if (existing['toko_id'] != currentUser.tokoId) {
      throw Exception('User bukan bagian dari toko ini');
    }

    // Hapus profile (auth user tetap ada di Supabase, butuh admin untuk hapus)
    await _supabase.from('profiles').delete().eq('id', id);

    // Hapus dari local cache
    await (_db.delete(_db.userTable)..where((t) => t.id.equals(id))).go();
  }

  // ───────────── TOKO ─────────────

  @override
  Future<Toko?> fetchToko() async {
    final currentUser = getCurrentUser();
    if (currentUser == null) return null;

    final data = await _supabase
        .from('toko')
        .select()
        .eq('id', currentUser.tokoId)
        .maybeSingle();

    if (data == null) return null;

    return Toko(
      id: data['id'] as String,
      nama: data['nama'] as String,
      alamat: data['alamat'] as String?,
      telepon: data['telepon'] as String?,
      ownerId: data['owner_id'] as String?,
      createdAt: data['created_at'] != null
          ? DateTime.tryParse(data['created_at'] as String)
          : null,
    );
  }

  @override
  Future<void> updateToko(Toko toko) async {
    final currentUser = getCurrentUser();
    if (currentUser == null) throw Exception('Tidak ada sesi aktif');
    if (!currentUser.isOwner) throw Exception('Hanya owner yang bisa edit toko');

    await _supabase.from('toko').update({
      'nama': toko.nama,
      'alamat': toko.alamat,
      'telepon': toko.telepon,
    }).eq('id', currentUser.tokoId);

    // Update local cache
    await (_db.update(_db.tokoTable)
      ..where((t) => t.id.equals(currentUser.tokoId)))
        .write(TokoTableCompanion(
      nama: Value(toko.nama),
      alamat: Value(toko.alamat),
      telepon: Value(toko.telepon),
      stokMinimumGlobal: Value(toko.stokMinimumGlobal),
    ));

    await _tokoService.updateName(toko.nama);
    await _tokoService.updateStokMinimumGlobal(toko.stokMinimumGlobal);
  }

  // ───────────── LOCAL HELPERS ─────────────

  Future<void> _saveSession(User user) async {
    final hasPin = user.id != null && await _localAuth.hasPin(user.id!);
    await _prefs.setString(_sessionKey, jsonEncode({
      'id': user.id,
      'tokoId': user.tokoId,
      'nama': user.nama,
      'role': user.role,
      'email': user.email,
      'hasPin': hasPin,
    }));
  }

  User _userFromMap(Map<String, dynamic> map) {
    return User(
      id: map['id'] as String?,
      tokoId: map['tokoId'] as String? ?? '',
      nama: map['nama'] as String?,
      role: map['role'] as String? ?? 'kasir',
      email: map['email'] as String?,
    );
  }

  Future<void> _upsertLocalProfile(User user) async {
    if (user.id == null) return;
    await _db.into(_db.userTable).insertOnConflictUpdate(UserTableCompanion(
      id: Value(user.id!),
      tokoId: Value(user.tokoId),
      nama: Value(user.nama),
      role: Value(user.role),
    ));
  }

  Future<void> _upsertLocalToko(
    String id,
    String nama,
    String? alamat,
    String? telepon,
    String ownerId,
  ) async {
    await _db.into(_db.tokoTable).insertOnConflictUpdate(TokoTableCompanion(
      id: Value(id),
      nama: Value(nama),
      alamat: Value(alamat),
      telepon: Value(telepon),
      ownerId: Value(ownerId),
      stokMinimumGlobal: const Value(0),
    ));
  }
}
