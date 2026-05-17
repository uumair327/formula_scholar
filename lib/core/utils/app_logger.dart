import 'package:flutter/foundation.dart';
import 'package:logger/logger.dart';

/// Application-wide logger utility.
///
/// Provides structured logging with different severity levels.
/// Logs are suppressed in release builds for security.
///
/// Usage:
/// ```dart
/// AppLogger.info('User logged in', tag: AppLogTags.profileCubit);
/// AppLogger.error('API failed', tag: 'Network', error: e, stackTrace: st);
/// ```
class AppLogger {
  AppLogger._();

  static final Logger _logger = Logger(
    printer: PrettyPrinter(
      methodCount: 0,
      errorMethodCount: 5,
      lineLength: 80,
      colors: true,
      printEmojis: true,
      dateTimeFormat: DateTimeFormat.onlyTimeAndSinceStart,
    ),
    level: kReleaseMode ? Level.error : Level.trace,
  );

  /// Formats the log message with an optional tag prefix.
  static String _format(String message, String? tag) {
    return tag != null ? '[$tag] $message' : message;
  }

  /// Lowest-level verbose log for granular tracing.
  ///
  /// Use for step-by-step data flow traces (e.g. "entering method X",
  /// "parameter Y = Z"). Suppressed in production.
  static void trace(String message, {String? tag}) {
    _logger.t(_format(message, tag));
  }

  /// Debug-level log for development diagnostics.
  ///
  /// Use for UI interaction events, navigation, and internal state
  /// that is useful only during development.
  static void debug(String message, {String? tag}) {
    _logger.d(_format(message, tag));
  }

  /// Informational log for normal operational events.
  ///
  /// Use for meaningful business events like "data loaded",
  /// "user navigated to screen X", "cubit emitted state Y".
  static void info(String message, {String? tag}) {
    _logger.i(_format(message, tag));
  }

  /// Warning log for recoverable but unexpected situations.
  ///
  /// Use when something surprising happens but the app can continue
  /// (e.g. missing optional data, deprecated API usage, fallback paths).
  static void warning(String message, {String? tag}) {
    _logger.w(_format(message, tag));
  }

  /// Error log for failures that need attention.
  ///
  /// Use for caught exceptions, failed API calls, and data processing
  /// errors. Always include [error] and [stackTrace] when available.
  static void error(
    String message, {
    String? tag,
    Object? error,
    StackTrace? stackTrace,
  }) {
    _logger.e(_format(message, tag), error: error, stackTrace: stackTrace);
  }

  /// Fatal log for critical, unrecoverable failures.
  ///
  /// Use for situations where the app cannot continue meaningfully
  /// (e.g. missing critical configuration, corrupt data, uncaught zone errors).
  static void fatal(
    String message, {
    String? tag,
    Object? error,
    StackTrace? stackTrace,
  }) {
    _logger.f(_format(message, tag), error: error, stackTrace: stackTrace);
  }
}
