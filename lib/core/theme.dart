import 'package:flutter/material.dart';

final primaryColor = Colors.green.shade800;

class AppTheme {
  // Светлая тема
  static final lightTheme = ThemeData(
    scaffoldBackgroundColor: Colors.grey.shade200,
    colorScheme: ColorScheme.fromSeed(
      seedColor: Colors.teal, // твой основной цвет
      brightness: Brightness.light,
    ),
    useMaterial3: true,
    // cardTheme почти не трогаем — Material 3 сам выберет правильные цвета
    cardTheme: CardThemeData(
      elevation: 1, // лёгкая тень в светлой теме
      shadowColor: Colors.transparent,
      surfaceTintColor: Colors.transparent, // убираем лишний tint
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
    ),
  );

  static final darkTheme = ThemeData(
    colorScheme: ColorScheme.fromSeed(
      seedColor: Colors.teal,
      brightness: Brightness.dark,
    ),
    useMaterial3: true,
    cardTheme: CardThemeData(
      elevation: 3, // в тёмной — тоже маленькая
      shadowColor: const Color.fromARGB(184, 0, 0, 0),
      surfaceTintColor: Colors.transparent,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      // Можно чуть подправить для тёмной темы, но лучше без color:
      // color: null,   // или вообще не указывать
    ),
  );
}
