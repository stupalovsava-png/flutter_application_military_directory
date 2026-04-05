import 'package:flutter/material.dart';
import 'package:flutter_application_military_directory/presentation/widgets/bottom_navigation.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_application_military_directory/navigation/app_routes.dart';

class AppShell extends StatelessWidget {
  final StatefulNavigationShell navigationShell;

  const AppShell({super.key, required this.navigationShell});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: navigationShell,
      bottomNavigationBar: BottomNavigation(
        currentIndex: navigationShell.currentIndex,
        onTap: (index) => navigationShell.goBranch(
          index,
          initialLocation: index == navigationShell.currentIndex,
        ),
        screens: const [AppScreen.main, AppScreen.drugs, AppScreen.checklists],
      ),
    );
  }
}
