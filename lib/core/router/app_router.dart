import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../constants/constants.dart';
import '../di/injection.dart';
import '../utils/utils.dart';
import '../../features/algebra/algebra.dart';
import '../../features/dashboard/dashboard.dart';
import '../../features/geometry/geometry.dart';
import '../../features/profile/profile.dart';
import '../../shared/shared.dart';
import 'app_page_transitions.dart';
import 'app_router_observer.dart';

/// Application router configuration using [GoRouter].
///
/// Responsibilities:
/// - Defines the complete route tree (shell + branches + sub-routes).
/// - Provides [CustomTransitionPage] for polished transitions.
/// - Registers [AppRouterObserver] for navigation logging.
/// - Supplies an [errorBuilder] for 404 / not-found scenarios.
/// - Guards debug diagnostics behind [kDebugMode].
///
/// **Dependency Injection:** Cubits are resolved from [getIt] (via
/// `injectable`) instead of being manually constructed. This decouples
/// the router from concrete DataSource/Repository implementations
/// and follows the Dependency Inversion Principle.
abstract final class AppRouter {
  /// Root navigator key shared with [GoRouter] and [StatefulShellRoute].
  static final GlobalKey<NavigatorState> _rootNavigatorKey =
      GlobalKey<NavigatorState>(debugLabel: 'root');

  /// The singleton [GoRouter] instance consumed by [MaterialApp.router].
  static final GoRouter router = GoRouter(
    navigatorKey: _rootNavigatorKey,
    initialLocation: AppRoutes.dashboardPath,
    debugLogDiagnostics: kDebugMode,
    observers: [AppRouterObserver()],

    // ───────────── Error / Not-Found ─────────────
    errorBuilder: (context, state) {
      AppLogger.warning(
        'Unknown route: ${state.uri}',
        tag: AppLogTags.router,
      );
      return NotFoundPage(state: state);
    },

    // ───────────── Redirect Guard ────────────────
    redirect: (BuildContext context, GoRouterState state) {
      AppLogger.trace(
        'Redirect check: ${state.uri}',
        tag: AppLogTags.router,
      );
      // TODO: Add auth / onboarding redirect logic here.
      return null;
    },

    // ───────────── Route Tree ────────────────────
    routes: [
      StatefulShellRoute.indexedStack(
        builder: (context, state, navigationShell) {
          return MainShellPage(navigationShell: navigationShell);
        },
        branches: [
          // ─── Home Tab (Dashboard) ───
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: AppRoutes.dashboardPath,
                name: AppRoutes.dashboardName,
                pageBuilder: (context, state) {
                  return AppPageTransitions.fadeTransition(
                    state: state,
                    child: BlocProvider(
                      create: (_) => getIt<DashboardCubit>()..loadDashboard(),
                      child: const DashboardPage(),
                    ),
                  );
                },
              ),
            ],
          ),

          // ─── Chapters Tab (Geometry) ───
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: AppRoutes.geometryPath,
                name: AppRoutes.geometryName,
                pageBuilder: (context, state) {
                  return AppPageTransitions.fadeTransition(
                    state: state,
                    child: BlocProvider(
                      create: (_) => getIt<GeometryCubit>()..loadTopics(),
                      child: const GeometryPage(),
                    ),
                  );
                },
              ),
            ],
          ),

          // ─── Cheat Sheet Tab (Algebra) ───
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: AppRoutes.algebraPath,
                name: AppRoutes.algebraName,
                pageBuilder: (context, state) {
                  return AppPageTransitions.fadeTransition(
                    state: state,
                    child: BlocProvider(
                      create: (_) => getIt<AlgebraCubit>()..loadFormulas(),
                      child: const AlgebraPage(),
                    ),
                  );
                },
              ),
            ],
          ),

          // ─── Profile Tab ───
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: AppRoutes.profilePath,
                name: AppRoutes.profileName,
                pageBuilder: (context, state) {
                  return AppPageTransitions.fadeTransition(
                    state: state,
                    child: BlocProvider(
                      create: (_) => getIt<ProfileCubit>()..loadProfile(),
                      child: const ProfilePage(),
                    ),
                  );
                },
              ),
            ],
          ),
        ],
      ),
    ],
  );
}
