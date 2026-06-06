import 'package:flutter/foundation.dart';
import 'package:logger/logger.dart';

import '../config/feature_flag.dart';
import '../config/feature_flag_port.dart';
import '../di/injection.dart';
import '../services/services.dart';

/// Application-wide logger utility.
///
/// Provides structured logging with different severity levels.
/// Respects [FeatureFlag.loggerEnabled] — when disabled, only
/// [fatal] messages are recorded.
///
/// Usage:
/// ```dart
/// AppLogger.info('User logged in', tag: AppLogTags.profileCubit);
/// AppLogger.error('API failed', tag: 'Network', error: e, stackTrace: st);
/// ```
class AppLogger {
  AppLogger._();

  static Logger? _logger;
  static FeatureFlagPort? _flags;
  static CrashlyticsServicePort? _crashlytics;

  /// Lazily initializes the underlying [Logger] and resolves the
  /// [FeatureFlagPort] and [CrashlyticsServicePort] from DI.
  static void _ensureInitialized() {
    if (_logger != null) return;
    try {
      _flags = getIt<FeatureFlagPort>();
      _crashlytics = getIt<CrashlyticsServicePort>();
    } catch (_) {
      // DI not yet configured — use build-mode defaults.
    }
    _logger = Logger(
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
  }

  /// Returns `true` if the caller should proceed with logging.
  ///
  /// In release mode, only fatal logs are emitted regardless of flags.
  /// In debug/profile, the [FeatureFlag.loggerEnabled] gate applies.
  static bool _shouldLog(Level level) {
    if (kReleaseMode && level != Level.fatal && level != Level.error) {
      return false;
    }
    try {
      _ensureInitialized();
      if (_flags != null && _flags!.isDisabled(FeatureFlag.loggerEnabled)) {
        return level == Level.fatal || level == Level.error;
      }
    } catch (_) {
      // Fall through — proceed with logging.
    }
    return true;
  }

  static String _format(String message, String? tag) {
    return tag != null ? '[$tag] $message' : message;
  }

  static void _recordCrashlyticsLog(String formattedMessage) {
    try {
      _ensureInitialized();
      _crashlytics?.log(formattedMessage);
    } catch (_) {
      // Ignore DI errors
    }
  }

  /// Verbose trace logging. Suppressed when [FeatureFlag.loggerEnabled]
  /// is false (except fatal-only release mode).
  static void trace(String message, {String? tag}) {
    if (!_shouldLog(Level.trace)) return;
    final msg = _format(message, tag);
    _logger!.t(msg);
    _recordCrashlyticsLog(msg);
  }

  /// Development diagnostics. Respects [FeatureFlag.loggerEnabled].
  static void debug(String message, {String? tag}) {
    if (!_shouldLog(Level.debug)) return;
    final msg = _format(message, tag);
    _logger!.d(msg);
    _recordCrashlyticsLog(msg);
  }

  /// Normal operational events. Respects [FeatureFlag.loggerEnabled].
  static void info(String message, {String? tag}) {
    if (!_shouldLog(Level.info)) return;
    final msg = _format(message, tag);
    _logger!.i(msg);
    _recordCrashlyticsLog(msg);
  }

  /// Recoverable warnings. Respects [FeatureFlag.loggerEnabled].
  static void warning(String message, {String? tag}) {
    if (!_shouldLog(Level.warning)) return;
    final msg = _format(message, tag);
    _logger!.w(msg);
    _recordCrashlyticsLog(msg);
  }

  /// Non-fatal errors. Respects [FeatureFlag.loggerEnabled].
  static void error(
    String message, {
    String? tag,
    Object? error,
    StackTrace? stackTrace,
  }) {
    if (!_shouldLog(Level.error)) return;
    final msg = _format(message, tag);
    _logger!.e(msg, error: error, stackTrace: stackTrace);

    try {
      _ensureInitialized();
      _crashlytics?.recordError(error ?? msg, stackTrace, reason: msg);
    } catch (_) {}
  }

  /// Critical unrecoverable failures. **Always** logged regardless of flags.
  static void fatal(
    String message, {
    String? tag,
    Object? error,
    StackTrace? stackTrace,
  }) {
    _ensureInitialized();
    final msg = _format(message, tag);
    _logger!.f(msg, error: error, stackTrace: stackTrace);

    try {
      _crashlytics?.recordFatalError(error ?? msg, stackTrace, reason: msg);
    } catch (_) {}
  }
}
