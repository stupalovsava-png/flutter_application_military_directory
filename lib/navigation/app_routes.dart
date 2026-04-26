// app_routes.dart
import 'package:flutter/material.dart';
import 'package:flutter_application_military_directory/features/anylysis/presentation/analysis_screen.dart';
import 'package:flutter_application_military_directory/features/calculators/presentation/formulae_screen.dart';
import 'package:flutter_application_military_directory/features/equipment/presentation/screens/equipment_screen.dart';
import 'package:flutter_application_military_directory/features/manuals/presentation/screens/manual_screen.dart';
import 'package:flutter_application_military_directory/features/medical_help/presentation/screens/medical_screen.dart';

import 'package:flutter_application_military_directory/presentation/main_screen.dart';
import 'package:flutter_application_military_directory/features/drugs/presentations/screens/drug_screen.dart';
import 'package:flutter_application_military_directory/features/chek_lists/presentation/screens/check_lists_screen.dart';
import 'package:flutter_application_military_directory/features/settings/presentation/screens/settings_screen.dart';
import 'package:flutter_application_military_directory/features/theory/presentation/screens/theory_screen.dart';
import 'package:material_symbols_icons/symbols.dart';

enum AppScreen {
  main,
  drugs,
  checklists,
  theory,
  equipment,
  analysis,
  formula,
  manipulation,
  medicalHelp,

  setting;

  // Возвращает соответствующий виджет экрана
  Widget get screen => switch (this) {
    AppScreen.formula => FormulaeScreen(),
    AppScreen.analysis => AnalysisScreen(),
    AppScreen.theory => const TheoryScreen(),
    AppScreen.main => const MainScreen(),
    AppScreen.drugs => const DrugScreen(),
    AppScreen.checklists => const CheckLists(),
    AppScreen.setting => const SettingsScreen(),
    AppScreen.equipment => const EquipmentScreen(),
    AppScreen.manipulation => const ManipulationScreen(),
    AppScreen.medicalHelp => const MedicalScreen(),
  };

  // Название для отображения в BottomNavigationBar
  String get label => switch (this) {
    AppScreen.analysis => 'Анализы',
    AppScreen.formula => 'Медицинские рассчеты',

    AppScreen.theory => 'Теория',
    AppScreen.equipment => 'Оснащение',
    AppScreen.manipulation => 'Манипуляции',

    AppScreen.main => 'Главная',
    AppScreen.drugs => 'Препараты',
    AppScreen.checklists => 'Чек-листы',
    AppScreen.setting => 'Настройки',
    AppScreen.medicalHelp => 'Врачебная помощь',
  };

  // Иконка для BottomNavigationBar
  IconData get icon => switch (this) {
    AppScreen.analysis => Icons.analytics,
    AppScreen.formula => Icons.calculate,
    AppScreen.equipment => Icons.add_box,
    AppScreen.theory => Icons.book,
    AppScreen.main => Icons.home,
    AppScreen.drugs => Icons.medication,
    AppScreen.checklists => Icons.checklist,
    AppScreen.setting => Icons.settings_rounded,
    AppScreen.manipulation => Icons.accessibility_new_rounded,
    AppScreen.medicalHelp => Symbols.stethoscope,
  };

  // Иконка активная (если хочешь отдельную)
  IconData get activeIcon => switch (this) {
    AppScreen.formula => Icons.calculate,
    AppScreen.analysis => Icons.analytics,
    AppScreen.theory => Icons.book,
    AppScreen.equipment => Icons.bolt,
    AppScreen.manipulation => Icons.accessibility_new,
    AppScreen.medicalHelp => Icons.accessibility_new,

    AppScreen.main => Icons.home_filled,
    AppScreen.drugs => Icons.medication_liquid,
    AppScreen.checklists => Icons.checklist_rounded,
    AppScreen.setting => Icons.settings,
  };
}
