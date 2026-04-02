// bottom_navigation.dart
import 'package:flutter/material.dart';
import 'package:flutter_application_military_directory/navigation/app_routes.dart';

class BottomNavigation extends StatelessWidget {
  final int currentIndex;
  final ValueChanged<int> onTap;
  final List<AppScreen> screens;

  const BottomNavigation({
    super.key,
    required this.currentIndex,
    required this.onTap,
    required this.screens,
  });

  @override
  Widget build(BuildContext context) {
    return NavigationBar(
      selectedIndex: currentIndex,
      onDestinationSelected: onTap,
      destinations: screens.map((screen) {
        return NavigationDestination(
          icon: Icon(screen.icon),
          selectedIcon: Icon(screen.activeIcon),
          label: screen.label,
        );
      }).toList(),
    );
  }
}
