import 'package:flutter/material.dart';

import '../utils/utils.dart';
import '../constants/constants.dart';

/// [NavigatorObserver] that logs all route lifecycle events.
///
/// Extracted from [AppRouter] to follow the Single Responsibility Principle.
/// Registered in [GoRouter.observers] for automatic invocation.
class AppRouterObserver extends NavigatorObserver {
  @override
  void didPush(Route<dynamic> route, Route<dynamic>? previousRoute) {
    AppLogger.info(
      'Route pushed: ${route.settings.name} '
      '(from: ${previousRoute?.settings.name ?? 'none'})',
      tag: AppLogTags.router,
    );
  }

  @override
  void didPop(Route<dynamic> route, Route<dynamic>? previousRoute) {
    AppLogger.info(
      'Route popped: ${route.settings.name} '
      '(back to: ${previousRoute?.settings.name ?? 'none'})',
      tag: AppLogTags.router,
    );
  }

  @override
  void didReplace({Route<dynamic>? newRoute, Route<dynamic>? oldRoute}) {
    AppLogger.info(
      'Route replaced: ${oldRoute?.settings.name ?? 'none'} '
      '→ ${newRoute?.settings.name ?? 'none'}',
      tag: AppLogTags.router,
    );
  }

  @override
  void didRemove(Route<dynamic> route, Route<dynamic>? previousRoute) {
    AppLogger.info(
      'Route removed: ${route.settings.name}',
      tag: AppLogTags.router,
    );
  }
}
