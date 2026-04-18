import 'package:flutter_bloc/flutter_bloc.dart';

import '../core.dart';

/// Mixin providing a reusable [logFailure] method for cubits.
///
/// Eliminates the duplicated `_logFailure` pattern found in
/// [DashboardCubit] and [ProfileCubit]. DRY + SRP compliance.
///
/// Usage:
/// ```dart
/// class MyCubit extends Cubit<MyState> with CubitFailureLogger {
///   @override
///   String get logTag => AppLogTags.myFeature;
/// }
/// ```
mixin CubitFailureLogger<T> on Cubit<T> {
  /// The log tag used by this cubit. Override in the concrete class.
  String get logTag;

  /// Logs a failure and returns `null` — designed for use with
  /// `Result` pattern matching where `null` signals "failed".
  // ignore: prefer_void_to_null
  Null logFailure(String operation, Failure failure) {
    AppLogger.error(
      'Failed to load $operation: ${failure.message}',
      tag: logTag,
      error: failure.originalError,
      stackTrace: failure.stackTrace,
    );
    return null;
  }
}
