import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:injectable/injectable.dart';
import '../core.dart';
import '../../core/utils/app_logger.dart';

@lazySingleton
class ApiClient {
  final http.Client _client;
  final String _baseUrl;

  ApiClient({http.Client? client, String baseUrl = 'http://localhost:3000/api'})
      : _client = client ?? http.Client(),
        _baseUrl = baseUrl;

  Future<Map<String, String>> _getHeaders() async {
    // TODO: Integrate with Auth adapter to get Bearer token
    final token = 'DUMMY_TOKEN';
    return {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer $token',
    };
  }

  Future<dynamic> get(String path) async {
    try {
      final headers = await _getHeaders();
      final response = await _client.get(Uri.parse('$_baseUrl$path'), headers: headers);
      return _processResponse(response);
    } catch (e) {
      AppLogger.error('GET request failed', error: e);
      throw Exception(e.toString());
    }
  }

  Future<dynamic> post(String path, {Map<String, dynamic>? body}) async {
    try {
      final headers = await _getHeaders();
      final response = await _client.post(
        Uri.parse('$_baseUrl$path'),
        headers: headers,
        body: body != null ? jsonEncode(body) : null,
      );
      return _processResponse(response);
    } catch (e) {
      AppLogger.error('POST request failed', error: e);
      throw Exception(e.toString());
    }
  }

  dynamic _processResponse(http.Response response) {
    if (response.statusCode >= 200 && response.statusCode < 300) {
      if (response.body.isEmpty) return null;
      return jsonDecode(response.body);
    } else {
      AppLogger.error('API Error: ${response.statusCode} - ${response.body}');
      throw Exception('HTTP ${response.statusCode}');
    }
  }
}
