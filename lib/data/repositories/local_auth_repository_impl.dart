import 'package:injectable/injectable.dart';
import 'dart:convert';
import 'package:crypto/crypto.dart';
import 'package:local_auth/local_auth.dart';
import 'package:drift/drift.dart' show Value;
import 'package:shared_preferences/shared_preferences.dart';

import '../../domain/repositories/local_auth_repository.dart';
import '../database/app_database.dart';

@LazySingleton(as: LocalAuthRepository)
class LocalAuthRepositoryImpl implements LocalAuthRepository {
  final AppDatabase _db;
  final SharedPreferences _prefs;
  final LocalAuthentication _localAuth = LocalAuthentication();

  static const _hasPinPrefix = 'has_pin_';

  LocalAuthRepositoryImpl(this._db, this._prefs);

  @override
  Future<bool> hasPin(String userId) async {
    return _prefs.getBool('$_hasPinPrefix$userId') ?? false;
  }

  @override
  Future<void> setPin(String userId, String pin) async {
    final hash = _hashPin(pin);
    await _db.into(_db.localAuthTable).insertOnConflictUpdate(
          LocalAuthTableCompanion(
            userId: Value(userId),
            pinHash: Value(hash),
            failedAttempts: const Value(0),
            lockoutUntil: const Value(null),
          ),
        );
    await _prefs.setBool('$_hasPinPrefix$userId', true);
  }

  @override
  Future<bool> verifyPin(String userId, String pin) async {
    final row = await (_db.select(_db.localAuthTable)
          ..where((t) => t.userId.equals(userId)))
        .getSingleOrNull();

    if (row == null) return false;

    if (isLockedOut(row.lockoutUntil)) return false;

    final hash = _hashPin(pin);
    if (hash == row.pinHash) {
      await resetAttempts(userId);
      return true;
    }

    await recordFailedAttempt(userId);
    return false;
  }

  @override
  Future<void> removePin(String userId) async {
    await (_db.delete(_db.localAuthTable)
          ..where((t) => t.userId.equals(userId)))
        .go();
    await _prefs.remove('$_hasPinPrefix$userId');
  }

  @override
  Future<void> recordFailedAttempt(String userId) async {
    final row = await (_db.select(_db.localAuthTable)
          ..where((t) => t.userId.equals(userId)))
        .getSingleOrNull();

    if (row == null) return;

    final attempts = row.failedAttempts + 1;
    DateTime? lockoutUntil;
    if (attempts >= 5) {
      lockoutUntil = DateTime.now().add(const Duration(seconds: 30));
    }

    await (_db.update(_db.localAuthTable)
          ..where((t) => t.userId.equals(userId)))
        .write(LocalAuthTableCompanion(
      failedAttempts: Value(attempts),
      lockoutUntil: Value(lockoutUntil),
    ));
  }

  @override
  Future<void> resetAttempts(String userId) async {
    await (_db.update(_db.localAuthTable)
          ..where((t) => t.userId.equals(userId)))
        .write(const LocalAuthTableCompanion(
      failedAttempts: Value(0),
      lockoutUntil: Value(null),
    ));
  }

  @override
  Future<int> getFailedAttempts(String userId) async {
    final row = await (_db.select(_db.localAuthTable)
          ..where((t) => t.userId.equals(userId)))
        .getSingleOrNull();
    return row?.failedAttempts ?? 0;
  }

  @override
  Future<DateTime?> getLockoutUntil(String userId) async {
    final row = await (_db.select(_db.localAuthTable)
          ..where((t) => t.userId.equals(userId)))
        .getSingleOrNull();
    return row?.lockoutUntil;
  }

  @override
  bool isLockedOut(DateTime? lockoutUntil) {
    if (lockoutUntil == null) return false;
    return DateTime.now().isBefore(lockoutUntil);
  }

  @override
  Future<bool> isBiometricAvailable() async {
    try {
      return await _localAuth.canCheckBiometrics ||
          await _localAuth.isDeviceSupported();
    } catch (_) {
      return false;
    }
  }

  @override
  Future<bool> authenticateWithBiometrics() async {
    try {
      final available = await _localAuth.canCheckBiometrics ||
          await _localAuth.isDeviceSupported();
      if (!available) return false;

      return await _localAuth.authenticate(
        localizedReason: 'Tempelkan sidik jari untuk verifikasi',
        options: const AuthenticationOptions(
          biometricOnly: false,
          stickyAuth: true,
          useErrorDialogs: true,
        ),
      );
    } catch (e) {
      return false;
    }
  }

  @override
  Future<void> enableBiometric(String userId) async {
    await (_db.update(_db.localAuthTable)
          ..where((t) => t.userId.equals(userId)))
        .write(const LocalAuthTableCompanion(
      biometricEnabled: Value(true),
    ));
  }

  @override
  Future<void> disableBiometric(String userId) async {
    await (_db.update(_db.localAuthTable)
          ..where((t) => t.userId.equals(userId)))
        .write(const LocalAuthTableCompanion(
      biometricEnabled: Value(false),
    ));
  }

  @override
  Future<bool> isBiometricEnabled(String userId) async {
    final row = await (_db.select(_db.localAuthTable)
          ..where((t) => t.userId.equals(userId)))
        .getSingleOrNull();
    return row?.biometricEnabled ?? false;
  }

  String _hashPin(String pin) {
    final bytes = utf8.encode(pin);
    return sha256.convert(bytes).toString();
  }
}
