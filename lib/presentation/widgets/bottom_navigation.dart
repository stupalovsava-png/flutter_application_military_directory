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
    return BottomNavigationBar(
      currentIndex: currentIndex,
      onTap: onTap,
      items: screens.map((screen) {
        return BottomNavigationBarItem(
          icon: Icon(screen.icon),
          label: screen.label,
        );
      }).toList(),
    );
  }
}
