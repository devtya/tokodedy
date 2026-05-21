import 'dart:convert';
import 'package:drift/drift.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:math';

import '../../data/database/app_database.dart';
import '../../data/services/sync_helper.dart';
import '../../core/services/toko_service.dart';
import '../../domain/entities/user.dart' as domain;
import '../../domain/repositories/auth_repository.dart';

class AuthRepositoryImpl implements AuthRepository {
  final AppDatabase _db;
  final SharedPreferences _prefs;
  final SyncHelper _syncHelper;
  final SupabaseClient _supabase;
  final TokoService _tokoService;
  static const String _sessionKey = 'logged_in_user';

  AuthRepositoryImpl(
    this._db,
    this._prefs,
    this._syncHelper,
    this._supabase,
    this._tokoService,
  );

  domain.User _mapUser(UserTableData data) {
    return domain.User(
      id: data.id,
      username: data.username ?? '',
      password: data.password,
      role: data.role,
      nama: data.nama,
      email: data.email,
      tokoId: data.tokoId,
      createdAt: data.createdAt,
    );
  }

  @override
  Future<domain.User?> login(String usernameOrEmail, String password) async {
    var data =
        await (_db.select(_db.userTable)
              ..where((u) => u.username.equals(usernameOrEmail))
              ..where((u) => u.password.equals(password)))
            .getSingleOrNull();

    if (data == null) {
      data = await (_db.select(_db.userTable)
            ..where((u) => u.email.equals(usernameOrEmail))
            ..where((u) => u.password.equals(password)))
          .getSingleOrNull();
    }

    if (data == null) {
      try {
        // Look for user record in Supabase records table
        final query = await _supabase
            .from('records')
            .select('data')
            .eq('data->>_table', 'user')
            .eq('data->>password', password);

        Map<String, dynamic>? matchedUserJson;
        for (final row in query as List<dynamic>) {
          final userJson = jsonDecode(row['data'] as String) as Map<String, dynamic>;
          final username = userJson['username'] as String?;
          final email = userJson['email'] as String?;
          if (username == usernameOrEmail || email == usernameOrEmail) {
            matchedUserJson = userJson;
            break;
          }
        }

        if (matchedUserJson != null) {
          final uId = matchedUserJson['id'] as int;
          final uTokoId = matchedUserJson['tokoId'] as int;
          final uUsername = matchedUserJson['username'] as String?;
          final uPassword = matchedUserJson['password'] as String;
          final uRole = matchedUserJson['role'] as String;
          final uNama = matchedUserJson['nama'] as String?;
          final uEmail = matchedUserJson['email'] as String?;

          // Fetch store details from Supabase stores table
          String storeName = 'Toko Baru';
          String? storeAlamat;
          try {
            final storeRes = await _supabase
                .from('stores')
                .select('name, address')
                .eq('id', uTokoId)
                .maybeSingle();
            if (storeRes != null) {
              storeName = storeRes['name'] as String;
              storeAlamat = storeRes['address'] as String?;
            }
          } catch (e) {
            print('Failed to fetch store details from Supabase: $e');
          }

          // Save store locally
          await _db.into(_db.tokoTable).insert(
            TokoTableCompanion(
              id: Value(uTokoId),
              nama: Value(storeName),
              alamat: Value(storeAlamat),
            ),
            mode: InsertMode.insertOrReplace,
          );

          // Save user locally
          await _db.into(_db.userTable).insert(
            UserTableCompanion(
              id: Value(uId),
              username: Value(uUsername),
              password: Value(uPassword),
              role: Value(uRole),
              nama: Value(uNama),
              email: Value(uEmail),
              tokoId: Value(uTokoId),
            ),
            mode: InsertMode.insertOrReplace,
          );

          // Insert sync record to prevent duplicate push
          final userUuid = matchedUserJson['_uuid'] as String?;
          if (userUuid != null) {
            await _db.into(_db.syncRecordTable).insert(
              SyncRecordTableCompanion(
                uuid: Value(userUuid),
                tableEntity: const Value('user'),
                localId: Value(uId),
                tokoId: Value(uTokoId),
                syncStatus: const Value('synced'),
                updatedAt: Value(DateTime.now().millisecondsSinceEpoch),
              ),
              mode: InsertMode.insertOrReplace,
            );
          }

          // Trigger initial sync on login success
          await _prefs.setBool('initial_sync_done', false);
          await _prefs.setInt('last_sync_timestamp', 0);

          data = UserTableData(
            id: uId,
            username: uUsername,
            password: uPassword,
            role: uRole,
            nama: uNama,
            email: uEmail,
            tokoId: uTokoId,
            createdAt: DateTime.now(),
          );
        }
      } catch (e) {
        print('Supabase cloud recovery login failed: $e');
      }
    }

    if (data != null) {
      final loggedInUser = data;
      final user = _mapUser(loggedInUser);
      // Simpan session
      final userMap = {
        'id': user.id,
        'username': user.username,
        'role': user.role,
        if (user.nama != null) 'nama': user.nama,
        if (user.email != null) 'email': user.email,
      };
      await _prefs.setString(_sessionKey, jsonEncode(userMap));

      // Pastikan toko_id tersimpan di TokoService
      if (_tokoService.tokoId == null || _tokoService.tokoId != loggedInUser.tokoId) {
        final tokoData = await (_db.select(_db.tokoTable)
          ..where((t) => t.id.equals(loggedInUser.tokoId)))
          .getSingleOrNull();
        if (tokoData != null) {
          await _tokoService.save(tokoData.id, tokoData.nama);
        }
      }

      return user;
    }
    return null;
  }

  @override
  Future<void> logout() async {
    await _prefs.remove(_sessionKey);
  }

  @override
  Future<domain.User?> getCurrentUser() async {
    final sessionString = _prefs.getString(_sessionKey);
    if (sessionString != null) {
      try {
        final map = jsonDecode(sessionString) as Map<String, dynamic>;
        final id = map['id'] as int;
        final data = await (_db.select(
          _db.userTable,
        )..where((u) => u.id.equals(id))).getSingleOrNull();
        if (data != null) {
          return _mapUser(data);
        } else {
          await logout();
        }
      } catch (e) {
        await logout();
      }
    }
    return null;
  }

  @override
  Future<List<domain.User>> getAllUsers() async {
    final currentTokoId = _tokoService.tokoId;
    if (currentTokoId == null) return [];
    final data = await (_db.select(_db.userTable)
      ..where((u) => u.tokoId.equals(currentTokoId)))
      .get();
    return data.map(_mapUser).toList();
  }

  @override
  Future<int> addUser(domain.User user) async {
    final currentTokoId = _tokoService.tokoId ?? 1;
    // Auto-generate username dari email jika tidak disediakan
    var username = user.username;
    if (username.isEmpty && user.email != null && user.email!.isNotEmpty) {
      final base = user.email!.split('@').first.toLowerCase();
      username = base;
      var existing = await (_db.select(_db.userTable)
            ..where((u) => u.username.equals(username)))
          .get();
      if (existing.isNotEmpty) {
        final suffix = Random().nextInt(9999).toString().padLeft(4, '0');
        username = '${base}_$suffix';
      }
    }
    final newId = await _db
        .into(_db.userTable)
        .insert(
          UserTableCompanion(
            username: Value(username),
            password: Value(user.password),
            role: Value(user.role),
            nama: Value(user.nama),
            email: Value(user.email),
            tokoId: Value(currentTokoId),
          ),
        );
    await _syncHelper.onInsert(tableEntity: 'user', localId: newId);
    return newId;
  }

  @override
  Future<void> updateUser(domain.User user) async {
    final existing = await (_db.select(_db.userTable)
      ..where((u) => u.id.equals(user.id!)))
      .getSingleOrNull();
    if (existing == null) return;
    await _db
        .update(_db.userTable)
        .replace(
          UserTableData(
            id: user.id!,
            username: user.username.isEmpty ? existing.username : user.username,
            password: user.password,
            role: user.role,
            nama: user.nama,
            email: user.email,
            tokoId: existing.tokoId,
            createdAt: user.createdAt ?? DateTime.now(),
          ),
        );
    // Update session jika ini user yang sedang login
    final sessionString = _prefs.getString(_sessionKey);
    if (sessionString != null) {
      final session = jsonDecode(sessionString) as Map<String, dynamic>;
      if (session['id'] == user.id) {
        session['nama'] = user.nama;
        session['email'] = user.email;
        await _prefs.setString(_sessionKey, jsonEncode(session));
      }
    }

    await _syncHelper.onUpdate(tableEntity: 'user', localId: user.id!);
  }

  @override
  Future<void> deleteUser(int id) async {
    await (_db.delete(_db.userTable)..where((u) => u.id.equals(id))).go();
    await _syncHelper.onDelete(tableEntity: 'user', localId: id);
  }

  @override
  Future<domain.User> registerStore({
    required String namaToko,
    String? alamat,
    required String email,
    required String password,
    String? nama,
  }) async {
    // 1. Insert store ke Supabase, dapetin toko_id
    final response = await _supabase.from('stores').insert({
      'name': namaToko,
      'address': alamat,
    }).select('id').single();
    final tokoId = response['id'] as int;

    // 2. Simpan ke local Drift
    await _db.into(_db.tokoTable).insert(
      TokoTableCompanion(
        id: Value(tokoId),
        nama: Value(namaToko),
        alamat: Value(alamat),
      ),
      mode: InsertMode.insertOrReplace,
    );

    // 3. Simpan ke TokoService
    await _tokoService.save(tokoId, namaToko);

    // 4. Auto-generate username dari email
    final baseUsername = email.split('@').first.toLowerCase();
    var finalUsername = baseUsername;
    // Cek apakah username sudah ada
    var existing = await (_db.select(_db.userTable)
          ..where((u) => u.username.equals(finalUsername)))
        .get();
    if (existing.isNotEmpty) {
      final suffix = Random().nextInt(9999).toString().padLeft(4, '0');
      finalUsername = '${baseUsername}_$suffix';
    }

    // 5. Buat admin user
    final newId = await _db.into(_db.userTable).insert(
      UserTableCompanion(
        username: Value(finalUsername),
        password: Value(password),
        role: const Value('admin'),
        nama: Value(nama),
        email: Value(email),
        tokoId: Value(tokoId),
      ),
    );
    await _syncHelper.onInsert(tableEntity: 'user', localId: newId, tokoId: tokoId);

    // 6. Simpan session
    final userMap = {
      'id': newId,
      'username': finalUsername,
      'role': 'admin',
      if (nama != null) 'nama': nama,
      'email': email,
    };
    await _prefs.setString(_sessionKey, jsonEncode(userMap));

    return domain.User(
      id: newId,
      username: finalUsername,
      password: password,
      role: 'admin',
      nama: nama,
      email: email,
    );
  }
}
