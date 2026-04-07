import 'package:equatable/equatable.dart';

/// Base failure class for all domain-level errors.
///
/// Using sealed class for exhaustive pattern matching in cubits:
/// ```dart
/// switch (failure) {
///   case ServerFailure(:final message): ...
///   case CacheFailure(:final message): ...
///   case AuthFailure(:final message): ...
///   case UnexpectedFailure(:final message): ...
/// }
/// ```
sealed class Failure extends Equatable {
  /// Human-readable description of what went wrong.
  final String message;

  /// Original error object for debugging (not exposed to UI).
  final Object? originalError;

  /// Stack trace from the original error for debugging.
  final StackTrace? stackTrace;

  const Failure({required this.message, this.originalError, this.stackTrace});

  @override
  List<Object?> get props => [message];
}

/// Server/network related failures (API errors, timeouts, etc.).
class ServerFailure extends Failure {
  const ServerFailure({
    required super.message,
    super.originalError,
    super.stackTrace,
  });
}

/// Local data/cache related failures (disk errors, parse failures, etc.).
class CacheFailure extends Failure {
  const CacheFailure({
    required super.message,
    super.originalError,
    super.stackTrace,
  });
}

/// Authentication related failures (expired tokens, unauthorized, etc.).
class AuthFailure extends Failure {
  const AuthFailure({
    required super.message,
    super.originalError,
    super.stackTrace,
  });
}

/// Authentication cancellation that should not be surfaced as an error.
class CancelledFailure extends Failure {
  const CancelledFailure({
    required super.message,
    super.originalError,
    super.stackTrace,
  });
}

/// Generic unexpected failure for unclassified errors.
class UnexpectedFailure extends Failure {
  const UnexpectedFailure({
    required super.message,
    super.originalError,
    super.stackTrace,
  });
}
