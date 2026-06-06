import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:injectable/injectable.dart';

import '../constants/app_log_tags.dart';
import '../utils/app_logger.dart';

/// Enterprise-grade analytics and crash reporting service.
/// Wraps Firebase Analytics and Crashlytics for usage throughout the app.
@lazySingleton
class AnalyticsService {
  AnalyticsService(this._analytics, this._crashlytics);

  final FirebaseAnalytics _analytics;
  final FirebaseCrashlytics _crashlytics;

  /// Log a screen view
  Future<void> logScreenView(String screenName, {String? screenClass}) async {
    try {
      await _analytics.logScreenView(
        screenName: screenName,
        screenClass: screenClass ?? screenName,
      );
      AppLogger.trace(
        'Screen view logged: $screenName',
        tag: AppLogTags.analytics,
      );
    } catch (e, st) {
      AppLogger.error(
        'Failed to log screen view',
        tag: AppLogTags.analytics,
        error: e,
        stackTrace: st,
      );
    }
  }

  /// Log a custom event
  Future<void> logEvent(String name, {Map<String, Object>? parameters}) async {
    try {
      await _analytics.logEvent(name: name, parameters: parameters);
      AppLogger.trace('Event logged: $name', tag: AppLogTags.analytics);
    } catch (e, st) {
      AppLogger.error(
        'Failed to log event',
        tag: AppLogTags.analytics,
        error: e,
        stackTrace: st,
      );
    }
  }

  /// Set the user's ID
  Future<void> setUserId(String? userId) async {
    try {
      await _analytics.setUserId(id: userId);
      await _crashlytics.setUserIdentifier(userId ?? '');
      AppLogger.trace('User ID set in Analytics', tag: AppLogTags.analytics);
    } catch (e, st) {
      AppLogger.error(
        'Failed to set user ID',
        tag: AppLogTags.analytics,
        error: e,
        stackTrace: st,
      );
    }
  }

  /// Set a user property
  Future<void> setUserProperty(String name, String value) async {
    try {
      await _analytics.setUserProperty(name: name, value: value);
      AppLogger.trace('User property set: $name', tag: AppLogTags.analytics);
    } catch (e, st) {
      AppLogger.error(
        'Failed to set user property',
        tag: AppLogTags.analytics,
        error: e,
        stackTrace: st,
      );
    }
  }

  /// Record an error manually to Crashlytics
  Future<void> recordError(
    dynamic error,
    StackTrace? stackTrace, {
    bool fatal = false,
    String? reason,
  }) async {
    try {
      await _crashlytics.recordError(
        error,
        stackTrace,
        fatal: fatal,
        reason: reason,
      );
      AppLogger.trace(
        'Error recorded to Crashlytics',
        tag: AppLogTags.analytics,
      );
    } catch (e, st) {
      AppLogger.error(
        'Failed to record error to Crashlytics',
        tag: AppLogTags.analytics,
        error: e,
        stackTrace: st,
      );
    }
  }

  /// Record a non-fatal message/log to Crashlytics
  Future<void> logMessage(String message) async {
    try {
      await _crashlytics.log(message);
    } catch (e, st) {
      AppLogger.error(
        'Failed to log message to Crashlytics',
        tag: AppLogTags.analytics,
        error: e,
        stackTrace: st,
      );
    }
  }
}
