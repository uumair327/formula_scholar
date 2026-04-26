import '../error/failures.dart';
import '../error/result.dart';
import '../utils/app_logger.dart';

/// Eliminates the duplicated try/catch/log/wrap-failure boilerplate
/// found in every repository implementation.
///
/// Before (repeated in every method of every repository):
/// ```dart
/// try {
///   final result = await _dataSource.getData();
///   AppLogger.info('succeeded', tag: tag);
///   return Success(result);
/// } catch (e, st) {
///   AppLogger.error('failed', tag: tag, error: e, stackTrace: st);
///   return Error(ServerFailure(message: '...', originalError: e, stackTrace: st));
/// }
/// ```
///
/// After:
/// ```dart
/// return safeOperation(
///   tag: AppLogTags.dashboardRepo,
///   operation: 'getStudyProgress',
///   execute: () => _dataSource.getStudyProgress(),
/// );
/// ```
Future<Result<T>> safeOperation<T>({
  required String tag,
  required String operation,
  required Future<T> Function() execute,
  Failure Function(Object error, StackTrace stackTrace)? onError,
  Future<T?> Function()? fallback,
}) async {
  try {
    final result = await execute();
    AppLogger.info('$operation() succeeded', tag: tag);
    return Success(result);
  } catch (e, stackTrace) {
    // Try fallback (e.g. cached data) before reporting failure.
    if (fallback != null) {
      final fallbackResult = await fallback();
      if (fallbackResult != null) {
        AppLogger.warning(
          '$operation() remote failed, using fallback',
          tag: tag,
        );
        return Success(fallbackResult);
      }
    }

    AppLogger.error(
      '$operation() failed',
      tag: tag,
      error: e,
      stackTrace: stackTrace,
    );

    final failure =
        onError?.call(e, stackTrace) ??
        ServerFailure(
          message: 'Failed to $operation',
          originalError: e,
          stackTrace: stackTrace,
        );

    return Error(failure);
  }
}
