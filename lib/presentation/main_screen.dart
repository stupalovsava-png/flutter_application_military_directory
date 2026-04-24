import 'package:flutter/material.dart';
import 'package:flutter_application_military_directory/core/theme/theme.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_application_military_directory/navigation/router/route_names.dart';
import 'package:flutter_application_military_directory/navigation/app_routes.dart';

class MainScreen extends StatelessWidget {
  const MainScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // Убираем Главную из списка карточек
    final visibleScreens = [
      AppScreen.drugs,
      AppScreen.checklists,
      // AppScreen.theory,
      AppScreen.analysis,
      // AppScreen.equipment,
      AppScreen.formula,
      AppScreen.manipulation,

      AppScreen.setting,
    ];
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
          itemCount: visibleScreens.length,
          itemBuilder: (context, index) {
            final screen = visibleScreens[index];

            return Card(
              elevation: 6,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
              child: InkWell(
                borderRadius: BorderRadius.circular(16),
                onTap: () {
                  if (screen == AppScreen.drugs) {
                    context.go(RouteNames.drugs);
                  } else if (screen == AppScreen.checklists) {
                    context.go(RouteNames.chekLists);
                  } else if (screen == AppScreen.setting) {
                    context.push('/main/settings');
                  } else if (screen == AppScreen.theory) {
                    context.go('/main/theory');
                  } else if (screen == AppScreen.manipulation) {
                    context.go('/main/manipulation');
                  } else if (screen == AppScreen.equipment) {
                    context.go('/main/equipment');
                  } else if (screen == AppScreen.analysis) {
                    context.go('/main/analysis');
                  } else if (screen == AppScreen.formula) {
                    context.go(RouteNames.formula);
                  }
                },
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(screen.icon, size: 56, color: primaryColor),
                    const SizedBox(height: 16),
                    Text(
                      screen.label,
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w600,
                      ),
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
