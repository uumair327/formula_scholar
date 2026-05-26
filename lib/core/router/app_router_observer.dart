import 'package:flutter/material.dart';

import '../utils/utils.dart';
import '../constants/constants.dart';

import '../di/injection.dart';
import '../services/services.dart';

/// [NavigatorObserver] that logs all route lifecycle events.
///
/// Extracted from [AppRouter] to follow the Single Responsibility Principle.
/// Registered in [GoRouter.observers] for automatic invocation.
class AppRouterObserver extends NavigatorObserver {
  void _trackScreen(Route<dynamic>? route) {
    if (route != null && route.settings.name != null) {
      try {
        getIt<AnalyticsServicePort>().setCurrentScreen(
          screenName: route.settings.name!,
        );
      } catch (_) {
        // DI not ready or analytics disabled
      }
    }
  }

  @override
  void didPush(Route<dynamic> route, Route<dynamic>? previousRoute) {
    AppLogger.info(
      'Route pushed: ${route.settings.name} '
      '(from: ${previousRoute?.settings.name ?? 'none'})',
      tag: AppLogTags.router,
    );
    _trackScreen(route);
  }

  @override
  void didPop(Route<dynamic> route, Route<dynamic>? previousRoute) {
    AppLogger.info(
      'Route popped: ${route.settings.name} '
      '(back to: ${previousRoute?.settings.name ?? 'none'})',
      tag: AppLogTags.router,
    );
    _trackScreen(previousRoute);
  }

  @override
  void didReplace({Route<dynamic>? newRoute, Route<dynamic>? oldRoute}) {
    AppLogger.info(
      'Route replaced: ${oldRoute?.settings.name ?? 'none'} '
      '→ ${newRoute?.settings.name ?? 'none'}',
      tag: AppLogTags.router,
    );
    _trackScreen(newRoute);
  }

  @override
  void didRemove(Route<dynamic> route, Route<dynamic>? previousRoute) {
    AppLogger.info(
      'Route removed: ${route.settings.name}',
      tag: AppLogTags.router,
    );
    _trackScreen(previousRoute);
  }
}
