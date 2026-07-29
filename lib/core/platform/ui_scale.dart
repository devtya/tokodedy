import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// App-wide UI zoom, applied via [MediaQuery.textScaler] in the root
/// MaterialApp builder. Controlled from the desktop cashier (buttons +
/// Ctrl +/-/0) and persisted so the cashier PC keeps its preferred size.
class UiScale {
  UiScale._();
  static final UiScale instance = UiScale._();

  static const double min = 0.8;
  static const double max = 2.0;
  static const double _step = 0.1;
  static const String _key = 'ui_scale';

  final ValueNotifier<double> scale = ValueNotifier<double>(1.0);

  Future<void> load() async {
    final prefs = await SharedPreferences.getInstance();
    final v = prefs.getDouble(_key) ?? 1.0;
    scale.value = v.clamp(min, max);
  }

  void zoomIn() => _set(scale.value + _step);
  void zoomOut() => _set(scale.value - _step);
  void reset() => _set(1.0);

  void _set(double v) {
    final clamped = double.parse(v.clamp(min, max).toStringAsFixed(2));
    if (clamped == scale.value) return;
    scale.value = clamped;
    SharedPreferences.getInstance()
        .then((prefs) => prefs.setDouble(_key, clamped));
  }
}
