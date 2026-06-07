import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:firebase_analytics/firebase_analytics.dart';

import '../constants/constants.dart';
import '../di/injection.dart';
import '../utils/utils.dart';
import '../../features/auth/auth.dart';
import '../../shared/shared.dart';
import '../../features/widget_viewer/presentation/pages/widget_preview_page.dart';
import 'app_router_observer.dart';
import 'route_builders/route_builders.dart';

class _AuthRouterListenable implements Listenable {
  _AuthRouterListenable(
    this._getCurrentAuthUser,
    this._watchAuthState,
    this._curriculumCubit,
  ) {
    _currentUser = _getCurrentAuthUser();
    _authSubscription = _watchAuthState().listen((user) {
      _currentUser = user;
      notifyListeners();
    });
    _curriculumSubscription = _curriculumCubit.stream.listen((_) {
      notifyListeners();
    });
  }

  final GetCurrentAuthUserUseCase _getCurrentAuthUser;
  final WatchAuthStateUseCase _watchAuthState;
  final CurriculumCubit _curriculumCubit;
  late final StreamSubscription<AuthUser?> _authSubscription;
  late final StreamSubscription<CurriculumState> _curriculumSubscription;
  AuthUser? _currentUser;
  final List<VoidCallback> _listeners = <VoidCallback>[];

  bool get isLoggedIn => _currentUser != null;

  @override
  void addListener(VoidCallback listener) {
    _listeners.add(listener);
  }

  @override
  void removeListener(VoidCallback listener) {
    _listeners.remove(listener);
  }

  void notifyListeners() {
    for (final listener in List<VoidCallback>.from(_listeners)) {
      listener();
    }
  }

  void dispose() {
    _authSubscription.cancel();
    _curriculumSubscription.cancel();
    _listeners.clear();
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
  static const _authPaths = {
    AppRoutes.loginPath,
    AppRoutes.signupPath,
    AppRoutes.widgetPreviewPath,
  };

  /// Onboarding paths – authenticated users are allowed here even
  /// without a curriculum selection.
  static const _onboardingPaths = {
    AppRoutes.onboardingPath,
    AppRoutes.onboardingStep2Path,
    AppRoutes.onboardingStep3Path,
    AppRoutes.onboardingStep4Path,
  };

  static final _authRefreshListenable = _AuthRouterListenable(
    getIt<GetCurrentAuthUserUseCase>(),
    getIt<WatchAuthStateUseCase>(),
    getIt<CurriculumCubit>(),
  );

  /// The singleton [GoRouter] instance consumed by [MaterialApp.router].
  static final GoRouter router = GoRouter(
    navigatorKey: _rootNavigatorKey,
    initialLocation: AppRoutes.dashboardPath,
    debugLogDiagnostics: kDebugMode,
    observers: [
      AppRouterObserver(),
      FirebaseAnalyticsObserver(analytics: FirebaseAnalytics.instance),
    ],
    refreshListenable: _authRefreshListenable,

    // ───────────── Error / Not-Found ─────────────
    errorBuilder: (context, state) {
      AppLogger.warning('Unknown route: ${state.uri}', tag: AppLogTags.router);
      return NotFoundPage(state: state);
    },

    // ───────────── Redirect Guard ────────────────
    redirect: (BuildContext context, GoRouterState state) {
      AppLogger.trace('Redirect check: ${state.uri}', tag: AppLogTags.router);

      final isLoggedIn = _authRefreshListenable.isLoggedIn;
      final isAuthPage = _authPaths.contains(state.matchedLocation);
      final isOnboardingPage = _onboardingPaths.contains(state.matchedLocation);

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
            !curriculumCubit.state.isLoading &&
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
      ...authRoutes(),
      ...aiRoutes(),
      ...profileSubRoutes(),
      ...searchRoutes(),
      ...analyticsRoutes(),
      ...achievementsRoutes(),
      ...cheatSheetRoutes(),
      ...comparisonRoutes(),
      ...flashcardRoutes(),
      ...visualizer3dRoutes(),
      ...studyPlannerRoutes(),
      ...legalRoutes(),
      ...practiceHistoryRoutes(),
      ...streakRoutes(),
      onboardingRoutes(),
      mainShellRoute(),
      GoRoute(
        path: AppRoutes.widgetPreviewPath,
        name: AppRoutes.widgetPreviewName,
        builder: (context, state) {
          final configB64 = state.uri.queryParameters['config'];
          return WidgetPreviewScreen(configB64: configB64);
        },
      ),
    ],
  );
}
