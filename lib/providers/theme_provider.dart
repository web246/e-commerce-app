import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../config/constants.dart';

class ThemeProvider extends ChangeNotifier {
  final SharedPreferences sharedPreferences;
  bool _isDark = false;

  ThemeProvider(this.sharedPreferences) {
    _isDark = sharedPreferences.getBool(AppConstants.prefsThemeMode) ?? false;
  }

  bool get isDark => _isDark;

  ThemeMode get themeMode => _isDark ? ThemeMode.dark : ThemeMode.light;

  Brightness get brightness => _isDark ? Brightness.dark : Brightness.light;

  Future<void> toggleTheme() async {
    _isDark = !_isDark;
    await sharedPreferences.setBool(AppConstants.prefsThemeMode, _isDark);
    notifyListeners();
  }
}
