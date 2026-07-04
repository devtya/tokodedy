import 'package:shared_preferences/shared_preferences.dart';
import '../di/injection.dart';

class StokMinimumPreference {
  static const _key = 'stok_minimum_global';

  static Future<int> getStokMinimumGlobal() async {
    final prefs = sl<SharedPreferences>();
    return prefs.getInt(_key) ?? 0;
  }

  static Future<void> setStokMinimumGlobal(int value) async {
    final prefs = sl<SharedPreferences>();
    await prefs.setInt(_key, value);
  }
}
