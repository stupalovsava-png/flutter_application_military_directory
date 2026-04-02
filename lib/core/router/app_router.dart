import 'package:flutter_application_military_directory/core/router/route_names.dart';
import 'package:flutter_application_military_directory/presentation/main_screen.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

final goRouterProvider = Provider<GoRouter>((ref) {
  return GoRouter(
    initialLocation: RouteNames.home,
    debugLogDiagnostics: true,

    routes: [
      GoRoute(
        path: RouteNames.home,
        builder: (contex, state) => const MainScreen(),
      ),
    ],
  );
});
