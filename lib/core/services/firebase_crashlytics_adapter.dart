import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:flutter/foundation.dart';
import 'package:injectable/injectable.dart';

import 'crashlytics_service_port.dart';

/// Concrete implementation of [CrashlyticsServicePort] using Firebase.
///
/// Registered as a LazySingleton via get_it.
@LazySingleton(as: CrashlyticsServicePort)
class FirebaseCrashlyticsAdapter implements CrashlyticsServicePort {

  FirebaseCrashlyticsAdapter() : _crashlytics = FirebaseCrashlytics.instance {
    // Automatically catch all uncaught Flutter framework errors
    FlutterError.onError = _crashlytics.recordFlutterFatalError;
    
    // Automatically catch asynchronous errors
    PlatformDispatcher.instance.onError = (error, stack) {
      _crashlytics.recordError(error, stack, fatal: true);
      return true;
    };
  }
  final FirebaseCrashlytics _crashlytics;

  @override
  Future<void> recordError(
    Object error,
    StackTrace? stack, {
    dynamic reason,
    Iterable<DiagnosticsNode> information = const [],
    bool? printDetails,
    bool fatal = false,
  }) async {
    await _crashlytics.recordError(
      error,
      stack,
      reason: reason,
      information: information,
      printDetails: printDetails,
      fatal: fatal,
    );
  }

  @override
  Future<void> recordFatalError(
    Object error,
    StackTrace? stack, {
    dynamic reason,
    Iterable<DiagnosticsNode> information = const [],
    bool? printDetails,
  }) async {
    await _crashlytics.recordError(
      error,
      stack,
      reason: reason,
      information: information,
      printDetails: printDetails,
      fatal: true,
    );
  }

  @override
  Future<void> log(String message) async {
    await _crashlytics.log(message);
  }

  @override
  Future<void> setUserIdentifier(String identifier) async {
    await _crashlytics.setUserIdentifier(identifier);
  }
}
