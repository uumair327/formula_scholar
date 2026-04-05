import 'package:dio/dio.dart';
import 'package:injectable/injectable.dart';

import 'api_interceptor.dart';

/// Centralized API Client wrapper around Dio.
///
/// Satisfies Golden Rule 4: API Layer Must Be Replaceable
/// "Use: ApiClient (Dio wrapper)... Never call Dio directly outside data layer".
@lazySingleton
class ApiClient {
  late final Dio _dio;

  ApiClient(ApiInterceptor interceptor) {
    _dio = Dio(
      BaseOptions(
        // Replace with actual production URL (or via env variables)
        baseUrl: 'https://api.example.com/v1',
        connectTimeout: const Duration(seconds: 15),
        receiveTimeout: const Duration(seconds: 15),
        contentType: 'application/json',
      ),
    );

    _dio.interceptors.add(interceptor);
  }

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
    return _dio.post(path, data: data, queryParameters: queryParameters, options: options);
  }

  /// Exposes standard PUT
  Future<Response> put(
    String path, {
    dynamic data,
    Map<String, dynamic>? queryParameters,
    Options? options,
  }) async {
    return _dio.put(path, data: data, queryParameters: queryParameters, options: options);
  }

  /// Exposes standard DELETE
  Future<Response> delete(
    String path, {
    dynamic data,
    Map<String, dynamic>? queryParameters,
    Options? options,
  }) async {
    return _dio.delete(path, data: data, queryParameters: queryParameters, options: options);
  }
}
