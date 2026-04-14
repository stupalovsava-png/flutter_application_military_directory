// import 'package:flutter/material.dart';
// import 'package:flutter_application_military_directory/navigation/app_routes.dart';

// class BottomNavigation extends StatelessWidget {
//   final int currentIndex;
//   final ValueChanged<int> onTap;

//   const BottomNavigation({
//     super.key,
//     required this.currentIndex,
//     required this.onTap,
//   });

//   @override
//   Widget build(BuildContext context) {
//     const visibleScreens = [
//       AppScreen.main,
//       AppScreen.drugs,
//       AppScreen.checklists,
//       AppScreen.formula,
//     ];
//     return BottomNavigationBar(
//       currentIndex: currentIndex,
//       onTap: onTap,
//       backgroundColor: Colors.black87,
//       selectedItemColor: Colors.white,
//       unselectedItemColor: Colors.grey,
//       selectedLabelStyle: const TextStyle(fontWeight: FontWeight.bold),
//       unselectedLabelStyle: const TextStyle(fontWeight: FontWeight.normal),
//       type: BottomNavigationBarType.fixed, // важно для кастомных цветов
//       items: visibleScreens.map((screen) {
//         return BottomNavigationBarItem(
//           icon: Icon(screen.icon),
//           label: screen.label,
//         );
//       }).toList(),
//     );
//   }
// }

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
      backgroundColor: Colors.black87,
      selectedItemColor: Colors.white,
      unselectedItemColor: Colors.grey,
      selectedLabelStyle: const TextStyle(fontWeight: FontWeight.bold),
      type: BottomNavigationBarType.fixed, // важно для кастомных цветов

      unselectedLabelStyle: const TextStyle(fontWeight: FontWeight.normal),
      items: screens.map((screen) {
        return BottomNavigationBarItem(
          icon: Icon(screen.icon, color: Colors.green.shade800),
          label: screen.label,
        );
      }).toList(),
    );
  }
}
