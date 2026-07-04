import 'package:flutter/foundation.dart';
import 'package:injectable/injectable.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:supabase_flutter/supabase_flutter.dart' hide User;
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'dart:convert';

import '../../domain/entities/user.dart';
import '../../domain/repositories/auth_repository.dart';
import '../../domain/repositories/local_auth_repository.dart';
import '../database/app_database.dart';
import 'package:drift/drift.dart' show Value;
import 'local_auth_repository_impl.dart' show LocalAuthRepositoryImpl;

@LazySingleton(as: AuthRepository)
class AuthRepositoryImpl implements AuthRepository {
  final AppDatabase _db;
  final SupabaseClient _supabase;
  final SharedPreferences _prefs;
  final LocalAuthRepository _localAuth;

  static const _sessionKey = 'current_user_session';

  AuthRepositoryImpl(this._db, this._supabase, this._prefs)
      : _localAuth = LocalAuthRepositoryImpl(_db, _prefs);

  // ───────────── AUTH ─────────────

  @override
  Future<User?> login(String email, String password) async {
    if (kDebugMode) debugPrint('[AuthRepo] login() CALLED | email="$email" | password.length=${password.length}');

    try {
      if (kDebugMode) debugPrint('[AuthRepo] Calling _supabase.auth.signInWithPassword(email: "$email") ...');
      final response = await _supabase.auth.signInWithPassword(
        email: email,
        password: password,
      );

      if (kDebugMode) debugPrint('[AuthRepo] signInWithPassword RESPONSE:');
      if (kDebugMode) debugPrint('  - user: ${response.user?.id ?? "null"}');
      if (kDebugMode) debugPrint('  - user.email: ${response.user?.email ?? "null"}');
      if (kDebugMode) debugPrint('  - session: ${response.session?.accessToken != null ? "has token" : "null"}');
      if (kDebugMode) debugPrint('  - session.expiresIn: ${response.session?.expiresIn}');
      if (response.session == null) {
        if (kDebugMode) debugPrint('  ⚠️ session is NULL — mungkin email/password salah atau user tidak terdaftar');
      }

      final authUser = response.user;
      if (authUser == null) {
        if (kDebugMode) debugPrint('[AuthRepo] authUser is null → returning null');
        return null;
      }

      // Ambil profile dari Supabase
      if (kDebugMode) debugPrint('[AuthRepo] Fetching profile for id="${authUser.id}" ...');
      final profileData = await _supabase
          .from('profiles')
          .select()
          .eq('id', authUser.id)
          .maybeSingle();

      if (kDebugMode) debugPrint('[AuthRepo] profileData: ${profileData != null ? "found" : "null"}');
      if (profileData == null) {
        if (kDebugMode) debugPrint('[AuthRepo] Profile NOT found → throwing Exception');
        throw Exception('Profil tidak ditemukan. Hubungi pemilik toko.');
      }

      if (kDebugMode) debugPrint('  - nama: ${profileData['nama']}');
      if (kDebugMode) debugPrint('  - role: ${profileData['role']}');
      if (kDebugMode) debugPrint('  - email: ${profileData['email']}');

      final user = User(
        id: authUser.id,
        nama: profileData['nama'] as String?,
        role: profileData['role'] as String? ?? 'kasir',
        email: authUser.email,
        createdAt: DateTime.tryParse(authUser.createdAt),
      );

      await _saveSession(user);
      await _backupSupabaseSession();
      await _upsertLocalProfile(user);

      if (kDebugMode) debugPrint('[AuthRepo] login() SUCCESS → returning User(${user.nama})');
      return user;
    } on AuthApiException catch (e) {
      // Tangani error auth dari Supabase (invalid credentials, dll)
      // Return null agar AuthBloc menampilkan "Username atau password salah!"
      if (kDebugMode) debugPrint('[AuthRepo] AuthApiException: message="${e.message}" statusCode=${e.statusCode} code=${e.code}');
      return null;
    } catch (e, stack) {
      if (kDebugMode) debugPrint('[AuthRepo] login() EXCEPTION: $e');
      if (kDebugMode) debugPrint('[AuthRepo] STACKTRACE: $stack');
      rethrow;
    }
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
      nama: profileData['nama'] as String?,
      role: profileData['role'] as String? ?? 'kasir',
      email: authUser.email,
      createdAt: DateTime.tryParse(authUser.createdAt),
    );

    await _saveSession(user);
    await _backupSupabaseSession();
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
        .order('created_at');

    return (response as List).map((p) {
      return User(
        id: p['id'] as String,
        nama: p['nama'] as String?,
        role: p['role'] as String? ?? 'kasir',
        email: p['email'] as String?,
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
      emailRedirectTo: 'io.tokodedy.app://login-callback',
      shouldCreateUser: true,
    );

    // Simpan pending profile — akan di-complete saat kasir pertama login
    // (profile insert dilakukan setelah kasir klik link & login)
    await _supabase.from('pending_invites').upsert({
      'email': email,
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

    final existing = await _supabase
        .from('profiles')
        .select('id')
        .eq('id', user.id!)
        .maybeSingle();

    if (existing == null) throw Exception('User tidak ditemukan');

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

    final existing = await _supabase
        .from('profiles')
        .select('id')
        .eq('id', id)
        .maybeSingle();

    if (existing == null) throw Exception('User tidak ditemukan');

    // Hapus profile (auth user tetap ada di Supabase, butuh admin untuk hapus)
    await _supabase.from('profiles').delete().eq('id', id);

    // Hapus dari local cache
    await (_db.delete(_db.userTable)..where((t) => t.id.equals(id))).go();
  }

  // ───────────── LOCAL HELPERS ─────────────

  Future<void> _backupSupabaseSession() async {
    try {
      final session = _supabase.auth.currentSession;
      if (session != null) {
        const storage = FlutterSecureStorage();
        await storage.write(
          key: 'supabase_session_backup',
          value: jsonEncode(session.toJson()),
        );
      }
    } catch (_) {
      // backup failure is non-critical
    }
  }

  Future<void> _saveSession(User user) async {
    final hasPin = user.id != null && await _localAuth.hasPin(user.id!);
    await _prefs.setString(_sessionKey, jsonEncode({
      'id': user.id,
      'nama': user.nama,
      'role': user.role,
      'email': user.email,
      'hasPin': hasPin,
    }));
  }

  User _userFromMap(Map<String, dynamic> map) {
    return User(
      id: map['id'] as String?,
      nama: map['nama'] as String?,
      role: map['role'] as String? ?? 'kasir',
      email: map['email'] as String?,
    );
  }

  Future<void> _upsertLocalProfile(User user) async {
    if (user.id == null) return;
    await _db.into(_db.userTable).insertOnConflictUpdate(UserTableCompanion(
      id: Value(user.id!),
      nama: Value(user.nama),
      role: Value(user.role),
    ));
  }
}
