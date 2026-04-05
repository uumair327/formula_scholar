import 'package:dio/dio.dart';
import 'package:injectable/injectable.dart';
import '../utils/app_logger.dart';

/// Logging interceptor to capture API requests, responses, and errors.
///
/// Satisfies Golden Rule 8: Logging is Mandatory (Not Optional)
/// "API requests/responses, Errors... should tell you WHY in 10 seconds".
@injectable
class ApiInterceptor extends Interceptor {
  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) {
    AppLogger.trace(
      'REQ [${options.method}] => PATH: ${options.path} \nDATA: ${options.data}',
      tag: 'API',
    );
    super.onRequest(options, handler);
  }

  @override
  void onResponse(Response response, ResponseInterceptorHandler handler) {
    AppLogger.trace(
      'RES [${response.statusCode}] <= PATH: ${response.requestOptions.path} \nDATA: ${response.data}',
      tag: 'API',
    );
    super.onResponse(response, handler);
  }

  @override
  void onError(DioException err, ErrorInterceptorHandler handler) {
    AppLogger.error(
      'ERR [${err.response?.statusCode}] <= PATH: ${err.requestOptions.path}',
      error: err,
      tag: 'API',
    );
    super.onError(err, handler);
  }
}
