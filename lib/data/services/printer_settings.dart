import 'package:shared_preferences/shared_preferences.dart';

import '../../core/di/injection.dart';
import '../../core/services/toko_service.dart';

class PrinterSettings {
  static const _keyType = 'printer_type';
  static const _keyUrl = 'printer_url';
  static const _keyEnabled = 'printer_enabled';
  static const _keyAutoPrint = 'printer_auto_print';
  static const _keyLebarKertas = 'printer_lebar_kertas';
  static const _keyNamaToko = 'printer_nama_toko';
  static const _keyAlamatToko = 'printer_alamat_toko';
  static const _keyFontSize = 'printer_font_size';

  final SharedPreferences prefs;

  PrinterSettings(this.prefs);

  String get type => prefs.getString(_keyType) ?? 'network';
  set type(String v) => prefs.setString(_keyType, v);

  String get url => prefs.getString(_keyUrl) ?? 'http://192.168.1.100:5000';
  set url(String v) => prefs.setString(_keyUrl, v);

  bool get enabled => prefs.getBool(_keyEnabled) ?? false;
  set enabled(bool v) => prefs.setBool(_keyEnabled, v);

  bool get autoPrint => prefs.getBool(_keyAutoPrint) ?? true;
  set autoPrint(bool v) => prefs.setBool(_keyAutoPrint, v);

  int get lebarKertas => prefs.getInt(_keyLebarKertas) ?? 58;
  set lebarKertas(int v) => prefs.setInt(_keyLebarKertas, v);

  String get namaToko {
    final saved = prefs.getString(_keyNamaToko);
    if (saved != null && saved.isNotEmpty) return saved;
    try {
      final tokoName = sl<TokoService>().tokoName;
      if (tokoName != null && tokoName.isNotEmpty) return tokoName;
    } catch (_) {}
    return 'Toko';
  }
  set namaToko(String v) => prefs.setString(_keyNamaToko, v);

  String get alamatToko => prefs.getString(_keyAlamatToko) ?? '';
  set alamatToko(String v) => prefs.setString(_keyAlamatToko, v);

  String get fontSize => prefs.getString(_keyFontSize) ?? 'normal';
  set fontSize(String v) => prefs.setString(_keyFontSize, v);
}
