import 'package:flutter/material.dart';
import 'package:flutter_riverpod/legacy.dart';
import 'package:shared_preferences/shared_preferences.dart';

final appThemeStateNotifier = ChangeNotifierProvider((ref) => AppThemeState());

class AppThemeState extends ChangeNotifier {
  bool isDarkModeEnabled = false;

  AppThemeState() {
    _loadThemeFromPrefs();
  }

  Future<void> _loadThemeFromPrefs() async {
    final prefs = await SharedPreferences.getInstance();
    final savedTheme = prefs.getBool('isDarkModeEnabled');

    if (savedTheme != null) {
      isDarkModeEnabled = savedTheme;
      notifyListeners();
    }
  }

  Future<void> _saveThemeToPrefs() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('isDarkModeEnabled', isDarkModeEnabled);
  }

  void setLightTheme() async {
    isDarkModeEnabled = false;
    await _saveThemeToPrefs();
    notifyListeners();
  }

  void setDarkTheme() async {
    isDarkModeEnabled = true;
    await _saveThemeToPrefs();
    notifyListeners();
  }
}
