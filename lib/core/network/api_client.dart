import 'package:dio/dio.dart';
import 'package:injectable/injectable.dart';

import 'api_interceptor.dart';
import 'retry_interceptor.dart';

/// Centralized API Client wrapper around Dio.
///
/// Satisfies Golden Rule 4: API Layer Must Be Replaceable
/// "Use: ApiClient (Dio wrapper)... Never call Dio directly outside data layer".
///
/// Interceptor order: RetryInterceptor → ApiInterceptor (logging).
/// Retries resolve before the logger sees the final outcome.
@lazySingleton
class ApiClient {
  ApiClient(ApiInterceptor interceptor, RetryInterceptor retryInterceptor) {
    _dio = Dio(
      BaseOptions(
        // TODO: Replace with actual Firebase Functions URL when deployed.
        // This is a placeholder — no feature currently uses ApiClient.
        // All data access goes through Firebase (Firestore, Auth).
        baseUrl: 'https://api.example.com/v1',
        connectTimeout: const Duration(seconds: 15),
        receiveTimeout: const Duration(seconds: 15),
        contentType: 'application/json',
      ),
    );

    // Retry interceptor runs first, then logging interceptor.
    _dio.interceptors.addAll([retryInterceptor, interceptor]);
  }
  late final Dio _dio;

  /// Exposes standard GET
  Future<Response> get(
    String path, {
    Map<String, dynamic>? queryParameters,
    Options? options,
  }) async {
    return _dio.get(path, queryParameters: queryParameters, options: options);
  }

  /// Exposes standard POST
  Future<Response> post(
    String path, {
    dynamic data,
    Map<String, dynamic>? queryParameters,
    Options? options,
  }) async {
    return _dio.post(
      path,
      data: data,
      queryParameters: queryParameters,
      options: options,
    );
  }

  /// Exposes standard PUT
  Future<Response> put(
    String path, {
    dynamic data,
    Map<String, dynamic>? queryParameters,
    Options? options,
  }) async {
    return _dio.put(
      path,
      data: data,
      queryParameters: queryParameters,
      options: options,
    );
  }

  /// Exposes standard DELETE
  Future<Response> delete(
    String path, {
    dynamic data,
    Map<String, dynamic>? queryParameters,
    Options? options,
  }) async {
    return _dio.delete(
      path,
      data: data,
      queryParameters: queryParameters,
      options: options,
    );
  }
}
