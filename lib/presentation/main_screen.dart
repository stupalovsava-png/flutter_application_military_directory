// main_screen.dart (пример)
import 'package:flutter/material.dart';
import 'package:flutter_application_military_directory/navigation/app_routes.dart';

class MainScreen extends StatelessWidget {
  const MainScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final allScreens = AppScreen.values; // или свой список для карточек

    return Scaffold(
      appBar: AppBar(title: const Text('Войсковой врач')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: GridView.builder(
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            crossAxisSpacing: 16,
            mainAxisSpacing: 16,
          ),
          itemCount: allScreens.length,
          itemBuilder: (context, index) {
            final screen = allScreens[index];

            return Card(
              elevation: 4,
              child: InkWell(
                onTap: () {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('Переход к: ${screen.label}')),
                  );
                },
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(screen.icon, size: 48),
                    const SizedBox(height: 12),
                    Text(
                      screen.label,
                      style: const TextStyle(fontSize: 18),
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
