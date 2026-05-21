import 'package:shared_preferences/shared_preferences.dart';

/// Service untuk menyimpan tokoId (UUID) aktif ke SharedPreferences.
/// Dibaca oleh semua repository untuk filter data per toko.
class TokoService {
  final SharedPreferences _prefs;
  static const _tokoIdKey  = 'toko_id_v2';  // UUID string
  static const _tokoNameKey = 'toko_name';

  TokoService(this._prefs);

  String? get tokoId   => _prefs.getString(_tokoIdKey);
  String? get tokoName => _prefs.getString(_tokoNameKey);

  Future<void> save(String id, String name) async {
    await _prefs.setString(_tokoIdKey, id);
    await _prefs.setString(_tokoNameKey, name);
  }

  Future<void> updateName(String name) async {
    await _prefs.setString(_tokoNameKey, name);
  }

  Future<void> clear() async {
    await _prefs.remove(_tokoIdKey);
    await _prefs.remove(_tokoNameKey);
  }
}
