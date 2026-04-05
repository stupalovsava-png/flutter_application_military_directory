import 'package:go_router/go_router.dart';

import 'package:flutter_application_military_directory/core/router/route_names.dart';
import 'package:flutter_application_military_directory/presentation/app_shell.dart';
import 'package:flutter_application_military_directory/presentation/main_screen.dart';
import 'package:flutter_application_military_directory/presentation/drugs/drug_screen.dart';
import 'package:flutter_application_military_directory/presentation/chek_list/check_lists_screen.dart';

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
