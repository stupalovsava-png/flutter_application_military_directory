import 'package:flutter_application_military_directory/features/settings/presentation/screens/settings_screen.dart';
import 'package:flutter_application_military_directory/features/theory/presentation/screens/theory_screen.dart';
import 'package:go_router/go_router.dart';

import 'package:flutter_application_military_directory/navigation/router/route_names.dart';
import 'package:flutter_application_military_directory/presentation/app_shell.dart';
import 'package:flutter_application_military_directory/presentation/main_screen.dart';
import 'package:flutter_application_military_directory/features/drugs/presentations/screens/drug_screen.dart';
import 'package:flutter_application_military_directory/features/chek_lists/presentation/screens/check_lists_screen.dart';

final GoRouter appRouter = GoRouter(
  initialLocation: RouteNames.main,
  debugLogDiagnostics: true,

  routes: [
    StatefulShellRoute.indexedStack(
      builder: (context, state, navigationShell) {
        return AppShell(navigationShell: navigationShell);
      },
      branches: [
        StatefulShellBranch(
          routes: [
            GoRoute(
              path: RouteNames.main,
              builder: (context, state) => const MainScreen(),
              routes: [
                //  вложенный маршрут
                GoRoute(
                  path: 'settings',
                  builder: (context, state) => const SettingsScreen(),
                ),
                GoRoute(
                  path: 'theory',
                  builder: (context, state) => const TheoryScreen(),
                ),
              ],
            ),
          ],
        ),
        StatefulShellBranch(
          routes: [
            GoRoute(
              path: RouteNames.drugs,
              builder: (context, state) => const DrugScreen(),
            ),
          ],
        ),

        StatefulShellBranch(
          routes: [
            GoRoute(
              path: RouteNames.chekLists,
              builder: (context, state) => const CheckLists(),
            ),
          ],
        ),
      ],
    ),
  ],
);
