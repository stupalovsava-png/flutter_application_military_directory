import 'package:flutter/material.dart';
import 'package:flutter_application_military_directory/presentation/chek_list/check_lists.dart';
import 'package:flutter_application_military_directory/presentation/drugs/drug_screen.dart';
import 'package:flutter_application_military_directory/presentation/main_screen.dart';
import 'package:flutter_application_military_directory/presentation/widgets/bottom_navigation.dart';

class AppShell extends StatefulWidget {
  const AppShell({super.key});

  @override
  State<AppShell> createState() => _AppShellState();
}

class _AppShellState extends State<AppShell> {
  int _currentIndex = 0;
  final List<Widget> _screens = const [
    MainScreen(),
    DrugScreen(),
    CheckLists(),
  ];
  void _onTap(int index) {
    setState(() {
      _currentIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IndexedStack(index: _currentIndex, children: _screens),
      bottomNavigationBar: BottomNavigation(
        currentIndex: _currentIndex,
        onTap: _onTap,
      ),
    );
  }
}
