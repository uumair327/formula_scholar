import 'failures.dart';

/// A Result type that represents either success or failure.
///
/// This replaces raw try/catch patterns at port boundaries,
/// enabling exhaustive pattern matching in cubits:
///
/// ```dart
/// final result = await getStudyProgressUseCase();
/// switch (result) {
///   case Success(:final data):
///     emit(state.copyWith(progress: data));
///   case Error(:final failure):
///     emit(state.copyWith(errorMessage: failure.message));
/// }
/// ```
sealed class Result<T> {
  const Result();
}

/// Represents a successful operation with the resulting [data].
class Success<T> extends Result<T> {
  final T data;
  const Success(this.data);
}

/// Represents a failed operation with a typed [failure].
class Error<T> extends Result<T> {
  final Failure failure;
  const Error(this.failure);
}
