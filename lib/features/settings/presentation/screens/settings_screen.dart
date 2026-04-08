import 'package:flutter/material.dart';
import 'package:flutter_application_military_directory/core/theme/theme_provider.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class SettingsScreen extends ConsumerWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final themeState = ref.watch(appThemeStateNotifier);
    final themeNotifier = ref.read(appThemeStateNotifier);

    return Scaffold(
      appBar: AppBar(title: const Text('Настройки')),
      body: SafeArea(
        child: Column(
          children: [
            const SizedBox(height: 40),
            const Text(
              'Выбор темы',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 60),

            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // Тёмная тема
                _buildThemeOption(
                  context: context,
                  isSelected: themeState.isDarkModeEnabled,
                  color: Colors.black,
                  label: 'Тёмная',
                  onTap: themeNotifier.setDarkTheme,
                ),
                const SizedBox(width: 60),
                // Светлая тема
                _buildThemeOption(
                  context: context,
                  isSelected: !themeState.isDarkModeEnabled,
                  color: Colors.white,
                  label: 'Светлая',
                  onTap: themeNotifier.setLightTheme,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildThemeOption({
    required BuildContext context,
    required bool isSelected,
    required Color color,
    required String label,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Column(
        children: [
          Container(
            height: 88,
            width: 88,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: color,
              border: Border.all(
                color: isSelected ? Colors.teal : Colors.grey,
                width: isSelected ? 4 : 2,
              ),
            ),
          ),
          const SizedBox(height: 12),
          Text(
            label,
            style: TextStyle(
              fontSize: 16,
              fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
            ),
          ),
        ],
      ),
    );
  }
}
