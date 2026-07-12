import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ThemeProvider extends ChangeNotifier {
  static const _themeKey = 'dennis_mendez_theme';
  final SharedPreferences sharedPreferences;
  bool _isDark = false;

  ThemeProvider(this.sharedPreferences) {
    _isDark = sharedPreferences.getBool(_themeKey) ?? false;
  }

  bool get isDark => _isDark;

  Future<void> toggleTheme() async {
    _isDark = !_isDark;
    await sharedPreferences.setBool(_themeKey, _isDark);
    notifyListeners();
  }
}
