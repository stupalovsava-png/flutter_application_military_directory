import 'package:flutter/material.dart';
import 'package:flutter_application_military_directory/core/theme_provider.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class SettingsScreen extends ConsumerWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final appThmeState = ref.watch(appThemeStateNotifier);
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            const Text('Выбор темы', style: TextStyle(fontSize: 22)),
            SizedBox(height: 100),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                GestureDetector(
                  onTap: () => appThmeState.setDarkTheme(),
                  child: SizedBox(
                    height: 88,
                    width: 88,
                    child: Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(100),
                        color: Colors.black,
                        border: Border.all(color: Colors.grey),
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 80),
                GestureDetector(
                  onTap: () => appThmeState.setLightTheme(),
                  child: SizedBox(
                    height: 88,
                    width: 88,
                    child: Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(100),
                        color: Colors.white,

                        border: Border.all(color: Colors.grey),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
