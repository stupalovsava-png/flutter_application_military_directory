import 'package:flutter/material.dart';
import 'package:flutter_application_military_directory/core/theme.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

// Импортируем готовый роутер
import 'package:flutter_application_military_directory/core/router/app_router.dart';
import 'package:flutter_riverpod/legacy.dart';

void main() {
  runApp(const ProviderScope(child: MainApp()));
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      debugShowCheckedModeBanner: false,
      title: 'Войсковой врач',
      theme: AppTheme.lightTheme,
      darkTheme: AppTheme.darkTheme,

      routerConfig: appRouter, // ← используем напрямую
    );
  }
}
