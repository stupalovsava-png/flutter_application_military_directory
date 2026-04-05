// app_routes.dart
import 'package:flutter/material.dart';

import 'package:flutter_application_military_directory/presentation/main_screen.dart';
import 'package:flutter_application_military_directory/presentation/drugs/drug_screen.dart';
import 'package:flutter_application_military_directory/presentation/chek_list/check_lists_screen.dart';
import 'package:flutter_application_military_directory/presentation/settings/settings_screen.dart';

enum AppScreen {
  main,
  drugs,
  checklists,
  setting;

  // Возвращает соответствующий виджет экрана
  Widget get screen => switch (this) {
    AppScreen.main => const MainScreen(),
    AppScreen.drugs => const DrugScreen(),
    AppScreen.checklists => const CheckLists(),
    AppScreen.setting => const SettingsScreen(),
  };

  // Название для отображения в BottomNavigationBar
  String get label => switch (this) {
    AppScreen.main => 'Главная',
    AppScreen.drugs => 'Препараты',
    AppScreen.checklists => 'Чек-листы',
    AppScreen.setting => 'Настройки',
  };

  // Иконка для BottomNavigationBar
  IconData get icon => switch (this) {
    AppScreen.main => Icons.home,
    AppScreen.drugs => Icons.medication,
    AppScreen.checklists => Icons.checklist,
    AppScreen.setting => Icons.settings,
  };

  // Иконка активная (если хочешь отдельную)
  IconData get activeIcon => switch (this) {
    AppScreen.main => Icons.home_filled,
    AppScreen.drugs => Icons.medication_liquid,
    AppScreen.checklists => Icons.checklist_rounded,
    AppScreen.setting => Icons.settings,
  };
}
