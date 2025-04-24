import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'theme_state.dart';

class ThemeCubit extends Cubit<ThemeState> {
  static const _prefKey = 'themeMode';

  ThemeCubit() : super(const ThemeState(themeMode: ThemeMode.system)) {
    _loadTheme();
  }

  Future<void> _loadTheme() async {
    final prefs = await SharedPreferences.getInstance();
    final value = prefs.getString(_prefKey) ?? 'dark';
    emit(ThemeState(themeMode: _stringToThemeMode(value)));
  }

  Future<void> toggleTheme(bool isDark) async {
    final newMode = isDark ? ThemeMode.dark : ThemeMode.light;
    emit(state.copyWith(themeMode: newMode));
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_prefKey, _themeModeToString(newMode));
  }

  ThemeMode _stringToThemeMode(String v) {
    switch (v) {
      case 'light':
        return ThemeMode.light;
      case 'dark':
        return ThemeMode.dark;
      default:
        return ThemeMode.system;
    }
  }

  String _themeModeToString(ThemeMode mode) {
    switch (mode) {
      case ThemeMode.light:
        return 'light';
      case ThemeMode.dark:
        return 'dark';
      default:
        return 'system';
    }
  }
}
