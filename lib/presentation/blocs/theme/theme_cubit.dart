import 'package:injectable/injectable.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';

@injectable
class ThemeCubit extends Cubit<ThemeMode> {
  final SharedPreferences _prefs;

  ThemeCubit(this._prefs) : super(_load(_prefs));

  static ThemeMode _load(SharedPreferences prefs) {
    final index = prefs.getInt('theme_mode');
    if (index == null) return ThemeMode.system;
    return ThemeMode.values[index];
  }

  void setTheme(ThemeMode mode) {
    _prefs.setInt('theme_mode', mode.index);
    emit(mode);
  }
}
