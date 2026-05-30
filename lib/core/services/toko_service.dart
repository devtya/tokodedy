import 'package:injectable/injectable.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// Service untuk menyimpan tokoId (UUID) aktif ke SharedPreferences.
/// Dibaca oleh semua repository untuk filter data per toko.
@lazySingleton
class TokoService {
  final SharedPreferences _prefs;
  static const _tokoIdKey  = 'toko_id_v2';  // UUID string
  static const _tokoNameKey = 'toko_name';
  static const _stokMinGlobalKey = 'stok_min_global';

  TokoService(this._prefs);

  String? get tokoId   => _prefs.getString(_tokoIdKey);
  String? get tokoName => _prefs.getString(_tokoNameKey);
  int get stokMinimumGlobal => _prefs.getInt(_stokMinGlobalKey) ?? 0;

  Future<void> save(String id, String name, [int stokMin = 0]) async {
    await _prefs.setString(_tokoIdKey, id);
    await _prefs.setString(_tokoNameKey, name);
    await _prefs.setInt(_stokMinGlobalKey, stokMin);
  }

  Future<void> updateName(String name) async {
    await _prefs.setString(_tokoNameKey, name);
  }

  Future<void> updateStokMinimumGlobal(int val) async {
    await _prefs.setInt(_stokMinGlobalKey, val);
  }

  Future<void> clear() async {
    await _prefs.remove(_tokoIdKey);
    await _prefs.remove(_tokoNameKey);
    await _prefs.remove(_stokMinGlobalKey);
  }
}
