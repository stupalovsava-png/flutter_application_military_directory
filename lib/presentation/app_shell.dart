import 'package:flutter/material.dart';
import 'package:flutter_application_military_directory/navigation/app_routes.dart';

import 'package:flutter_application_military_directory/presentation/widgets/bottom_navigation.dart';

class AppShell extends StatefulWidget {
  const AppShell({super.key});

  @override
  State<AppShell> createState() => _AppShellState();
}

class _AppShellState extends State<AppShell> {
  int _currentIndex = 0;
  List<AppScreen> get _bottomNavScreens => [
    AppScreen.main,
    AppScreen.drugs,
    AppScreen.checklists,
  ];
  void _onTap(int index) {
    setState(() {
      _currentIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    final currentScreen = _bottomNavScreens[_currentIndex];

    return Scaffold(
      body: IndexedStack(
        index: _currentIndex,
        children: _bottomNavScreens.map((screen) => screen.screen).toList(),
      ),
      bottomNavigationBar: BottomNavigation(
        currentIndex: _currentIndex,
        onTap: _onTap,
        screens: _bottomNavScreens,
      ),
    );
  }
}
