import 'package:flutter_application_military_directory/features/manuals/presentation/screens/manual_screen.dart';
import 'package:go_router/go_router.dart';

import 'package:flutter_application_military_directory/navigation/router/route_names.dart';
import 'package:flutter_application_military_directory/presentation/widgets/app_shell.dart';
import 'package:flutter_application_military_directory/presentation/main_screen.dart';

import 'package:flutter_application_military_directory/features/drugs/presentations/screens/drug_screen.dart';
import 'package:flutter_application_military_directory/features/chek_lists/presentation/screens/check_lists_screen.dart';
import 'package:flutter_application_military_directory/features/anylysis/presentation/analysis_screen.dart';
import 'package:flutter_application_military_directory/features/calculators/presentation/formulae_screen.dart';
import 'package:flutter_application_military_directory/features/settings/presentation/screens/settings_screen.dart';
import 'package:flutter_application_military_directory/features/theory/presentation/screens/theory_screen.dart';

final GoRouter appRouter = GoRouter(
  initialLocation: RouteNames.main,
  debugLogDiagnostics: true,

  routes: [
    // ==================== StatefulShellRoute (только для Bottom Navigation) ====================
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
                //  вложенный маршруты
                GoRoute(
                  path: 'manipulation',
                  builder: (context, state) => const ManipulationScreen(),
                ),
                GoRoute(
                  path: 'settings',
                  builder: (context, state) => const SettingsScreen(),
                ),
                GoRoute(
                  path: 'theory',
                  builder: (context, state) => const TheoryScreen(),
                ),
                GoRoute(
                  path: 'analysis',
                  builder: (context, state) => AnalysisScreen(),
                ),
              ],
            ),
          ],
        ),

        // Branch 1 — Препараты
        StatefulShellBranch(
          routes: [
            GoRoute(
              path: RouteNames.drugs,
              name: RouteNames.drugs,
              builder: (context, state) => const DrugScreen(),
            ),
          ],
        ),

        // Branch 2 — Чек-листы
        StatefulShellBranch(
          routes: [
            GoRoute(
              path: RouteNames.chekLists,
              name: RouteNames.chekLists,
              builder: (context, state) => const CheckLists(),
            ),
          ],
        ),

        // Branch 3 — Медицинские расчёты
        StatefulShellBranch(
          routes: [
            GoRoute(
              path: RouteNames.formula,
              name: RouteNames.formula,
              builder: (context, state) => const FormulaeScreen(),
            ),
          ],
        ),
      ],
    ),

    // ==================== Отдельные ветки (открываются поверх Shell) ====================
    // Анализы
    GoRoute(
      path: RouteNames.analysis,
      name: RouteNames.analysis,
      builder: (context, state) => const AnalysisScreen(),
    ),

    // Теория
    GoRoute(
      path: RouteNames.theory,
      name: RouteNames.theory,
      builder: (context, state) => const TheoryScreen(),
    ),

    // Настройки
    GoRoute(
      path: RouteNames.settings,
      name: RouteNames.settings,
      builder: (context, state) => const SettingsScreen(),
    ),
  ],
);
