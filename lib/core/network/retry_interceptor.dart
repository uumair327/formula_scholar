import 'dart:math';

import 'package:dio/dio.dart';
import 'package:injectable/injectable.dart';

import '../utils/app_logger.dart';

/// Interceptor providing automatic retry with exponential backoff.
///
/// Satisfies Golden Rule 4: "Use interceptors (auth, retry, logging)."
///
/// Retries are only attempted for:
/// - Connection timeouts
/// - Receive timeouts
/// - Network-level errors (no internet, DNS failure)
///
/// Non-retryable errors (4xx, business logic errors) are passed through.
@injectable
class RetryInterceptor extends Interceptor {
  /// Maximum number of retry attempts.
  final int maxRetries;

  /// Base delay before first retry (doubles each attempt).
  final Duration baseDelay;

  RetryInterceptor({
    this.maxRetries = 3,
    this.baseDelay = const Duration(milliseconds: 500),
  });

  @override
  Future<void> onError(
    DioException err,
    ErrorInterceptorHandler handler,
  ) async {
    if (!_shouldRetry(err)) {
      return super.onError(err, handler);
    }

    final dio = Dio(err.requestOptions.toBaseOptions());
    int attempt = 0;

    while (attempt < maxRetries) {
      attempt++;
      final delay = baseDelay * pow(2, attempt - 1);

      AppLogger.warning(
        'Retrying request [${err.requestOptions.method}] '
        '${err.requestOptions.path} — attempt $attempt/$maxRetries '
        '(waiting ${delay.inMilliseconds}ms)',
        tag: 'RetryInterceptor',
      );

      await Future<void>.delayed(delay);

      try {
        final response = await dio.fetch(err.requestOptions);
        return handler.resolve(response);
      } on DioException catch (retryError) {
        if (attempt == maxRetries || !_shouldRetry(retryError)) {
          return super.onError(retryError, handler);
        }
      }
    }

    return super.onError(err, handler);
  }

  bool _shouldRetry(DioException err) {
    return err.type == DioExceptionType.connectionTimeout ||
        err.type == DioExceptionType.receiveTimeout ||
        err.type == DioExceptionType.sendTimeout ||
        err.type == DioExceptionType.connectionError;
  }
}

extension _RequestOptionsToBaseOptions on RequestOptions {
  BaseOptions toBaseOptions() {
    return BaseOptions(
      baseUrl: baseUrl,
      connectTimeout: connectTimeout,
      receiveTimeout: receiveTimeout,
      headers: headers,
      contentType: contentType,
    );
  }
}
