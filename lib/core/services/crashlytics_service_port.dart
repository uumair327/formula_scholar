import 'package:flutter/foundation.dart';

/// Defines the contract for the application's crash reporting engine.
///
/// By depending on this port instead of FirebaseCrashlytics directly,
/// the app remains decoupled from the specific provider
/// (Golden Rule #4: API Layer Must Be Swappable).
abstract class CrashlyticsServicePort {
  /// Records a non-fatal error.
  Future<void> recordError(
    Object error,
    StackTrace? stack, {
    dynamic reason,
    Iterable<DiagnosticsNode> information = const [],
    bool? printDetails,
    bool fatal = false,
  });

  /// Records a critical fatal error.
  Future<void> recordFatalError(
    Object error,
    StackTrace? stack, {
    dynamic reason,
    Iterable<DiagnosticsNode> information = const [],
    bool? printDetails,
  });

  /// Adds a custom log message to the crash report context.
  Future<void> log(String message);

  /// Sets the user identifier for crash reports.
  Future<void> setUserIdentifier(String identifier);
}
