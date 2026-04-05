import 'package:flutter/material.dart';
import 'package:flutter_application_military_directory/core/theme.dart';
import 'package:flutter_application_military_directory/core/theme_provider.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

// Импортируем готовый роутер
import 'package:flutter_application_military_directory/navigation/router/app_router.dart';

void main() {
  runApp(const ProviderScope(child: MainApp()));
}

class MainApp extends ConsumerWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final appThemeState = ref.watch(appThemeStateNotifier);
    return MaterialApp.router(
      debugShowCheckedModeBanner: false,
      title: 'Войсковой врач',
      theme: AppTheme.lightTheme,
      darkTheme: AppTheme.darkTheme,
      themeMode: appThemeState.isDarkModeEnabled
          ? ThemeMode.dark
          : ThemeMode.light,

      routerConfig: appRouter, // ← используем напрямую
    );
  }
}
