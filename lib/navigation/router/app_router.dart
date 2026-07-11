import 'package:flutter_application_military_directory/features/abaout/about_screen.dart';
import 'package:flutter_application_military_directory/features/chek_lists/data/chek_list_data.dart';
import 'package:flutter_application_military_directory/features/chek_lists/presentation/screens/check_list_detail_screen.dart';
import 'package:flutter_application_military_directory/features/drugs/data/drugs_data.dart';
import 'package:flutter_application_military_directory/features/drugs/presentations/screens/drugs_detail_screen.dart';
import 'package:flutter_application_military_directory/features/manuals/presentation/screens/manual_screen.dart';
import 'package:flutter_application_military_directory/features/medical_help/presentation/screens/medical_screen.dart';
import 'package:flutter_application_military_directory/features/medical_protocoles/presentation/protocol_list_screen.dart';
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
                // GoRoute(
                //   path: 'medical_help',
                //   builder: (context, state) => MedicalScreen(),
                // ),
                GoRoute(
                  path: 'about',
                  builder: (context, state) => const AboutScreen(),
                ),
                GoRoute(
                  path: 'protocoles',
                  builder: (context, state) => ProtocolListScreen(),
                ),
              ],
            ),
          ],
        ),

        StatefulShellBranch(
          routes: [
            GoRoute(
              path: RouteNames.drugs,
              name: RouteNames.drugs,
              builder: (context, state) => const DrugScreen(),
              routes: [
                GoRoute(
                  path: ':id',
                  builder: (context, state) {
                    final id = int.parse(state.pathParameters['id']!);
                    final drug = drugList.firstWhere((d) => d.id == id);
                    return DrugDetailScreen(drug: drug);
                  },
                ),
              ],
            ),
          ],
        ),

        // Branch 2 — Чек-листы
        StatefulShellBranch(
          routes: [
            GoRoute(
              path: RouteNames.medicalHelp,
              name: RouteNames.medicalHelp,
              builder: (context, state) => const MedicalScreen(),
              // routes: [
              //   GoRoute(
              //     path: ':id',
              //     builder: (context, state) {
              //       final id = int.parse(state.pathParameters['id']!);
              //       final check = checkLists.firstWhere((c) => c.id == id);
              //       return ActionsProgressScreen(check: check);
              //     },
              //   ),
              // ],
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
