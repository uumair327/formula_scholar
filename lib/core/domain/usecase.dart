/// Base interface for all Use Cases in the application.
///
/// Enforces a consistent `call()` contract across all features, making
/// the codebase predictable and every use case testable in isolation.
///
/// **Type parameters:**
/// - [Params] – The input type (use [NoParams] when none are needed).
/// - [ReturnType] – The output type (typically `Result<T>` or `Future<Result<T>>`).
///
/// Usage:
/// ```dart
/// class GetSubjectsUseCase extends UseCase<(String, String), Future<Result<List<Subject>>>> {
///   @override
///   Future<Result<List<Subject>>> call((String, String) params) => ...;
/// }
/// ```
// ignore: one_member_abstracts
abstract class UseCase<Params, ReturnType> {
  /// Executes this use case with the given [params].
  ReturnType call(Params params);
}

/// Marker class for Use Cases that require no parameters.
///
/// ```dart
/// class SignOutUseCase extends UseCase<NoParams, Future<Result<void>>> {
///   @override
///   Future<Result<void>> call(NoParams _) => _repo.signOut();
/// }
/// ```
class NoParams {
  const NoParams();
}
