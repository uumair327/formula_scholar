import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../constants/constants.dart';
import '../di/injection.dart';
import '../utils/utils.dart';
import '../../features/auth/auth.dart';
import '../../shared/shared.dart';
import 'app_router_observer.dart';
import 'route_builders.dart';

class _AuthRouterNotifier extends ChangeNotifier {
  final GetCurrentAuthUserUseCase _getCurrentAuthUser;
  final WatchAuthStateUseCase _watchAuthState;
  late final StreamSubscription<AuthUser?> _subscription;
  AuthUser? _currentUser;

  _AuthRouterNotifier(this._getCurrentAuthUser, this._watchAuthState) {
    _currentUser = _getCurrentAuthUser();
    _subscription = _watchAuthState().listen((user) {
      _currentUser = user;
      notifyListeners();
    });
  }

  bool get isLoggedIn => _currentUser != null;

  @override
  void dispose() {
    _subscription.cancel();
    super.dispose();
  }
}

/// Application router configuration using [GoRouter].
///
/// Route definitions are delegated to [RouteBuilders] to keep this file
/// focused on routing infrastructure (guards, observers, error handling).
///
/// Satisfies Golden Rule 14: Small files (< 200 lines).
abstract final class AppRouter {
  /// Root navigator key shared with [GoRouter] and [StatefulShellRoute].
  static final GlobalKey<NavigatorState> _rootNavigatorKey =
      GlobalKey<NavigatorState>(debugLabel: 'root');

  /// Auth pages that unauthenticated users are allowed to access.
  static const _authPaths = {AppRoutes.loginPath, AppRoutes.signupPath};

  /// Onboarding paths – authenticated users are allowed here even
  /// without a curriculum selection.
  static const _onboardingPaths = {
    AppRoutes.onboardingPath,
    AppRoutes.onboardingStep2Path,
    AppRoutes.onboardingStep3Path,
    AppRoutes.onboardingStep4Path,
  };

  static final _authNotifier = _AuthRouterNotifier(
    getIt<GetCurrentAuthUserUseCase>(),
    getIt<WatchAuthStateUseCase>(),
  );

  /// The singleton [GoRouter] instance consumed by [MaterialApp.router].
  static final GoRouter router = GoRouter(
    navigatorKey: _rootNavigatorKey,
    initialLocation: AppRoutes.dashboardPath,
    debugLogDiagnostics: kDebugMode,
    observers: [AppRouterObserver()],
    refreshListenable: _authNotifier,

    // ───────────── Error / Not-Found ─────────────
    errorBuilder: (context, state) {
      AppLogger.warning('Unknown route: ${state.uri}', tag: AppLogTags.router);
      return NotFoundPage(state: state);
    },

    // ───────────── Redirect Guard ────────────────
    redirect: (BuildContext context, GoRouterState state) {
      AppLogger.trace('Redirect check: ${state.uri}', tag: AppLogTags.router);

      final isLoggedIn = _authNotifier.isLoggedIn;
      final isAuthPage = _authPaths.contains(state.matchedLocation);
      final isOnboardingPage = _onboardingPaths.contains(
        state.matchedLocation,
      );

      // If not logged in and NOT on auth page → redirect to login.
      if (!isLoggedIn && !isAuthPage) {
        AppLogger.info(
          'Unauthenticated user redirected to login from ${state.uri}',
          tag: AppLogTags.router,
        );
        return AppRoutes.loginPath;
      }

      // If logged in and on auth page → redirect to dashboard.
      if (isLoggedIn && isAuthPage) {
        AppLogger.info(
          'Authenticated user redirected to dashboard from ${state.uri}',
          tag: AppLogTags.router,
        );
        return AppRoutes.dashboardPath;
      }

      // If logged in but no curriculum set and NOT on onboarding →
      // redirect to onboarding so the user completes setup first.
      if (isLoggedIn && !isOnboardingPage && !isAuthPage) {
        final curriculumCubit = getIt<CurriculumCubit>();
        if (curriculumCubit.state.isInitialized &&
            !curriculumCubit.state.hasSelection) {
          AppLogger.info(
            'User without curriculum redirected to onboarding from ${state.uri}',
            tag: AppLogTags.router,
          );
          return AppRoutes.onboardingPath;
        }
      }

      return null;
    },

    // ───────────── Route Tree (delegated to RouteBuilders) ───────
    routes: [
      ...RouteBuilders.authRoutes(),
      ...RouteBuilders.profileSubRoutes(),
      ...RouteBuilders.legalRoutes(),
      RouteBuilders.onboardingRoutes(),
      RouteBuilders.mainShellRoute(),
    ],
  );
}
