import 'dart:convert';

import 'package:http/http.dart' as http;

import '../../../../core/core.dart';
import '../../domain/domain.dart';

class GeminiProviderClient implements AiProviderClientPort {
  GeminiProviderClient({
    required http.Client httpClient,
    required AiResponseParser parser,
  }) : _httpClient = httpClient,
       _parser = parser;

  final http.Client _httpClient;
  final AiResponseParser _parser;

  @override
  AiProviderType get provider => AiProviderType.gemini;

  @override
  Future<AiProviderResponse> complete(AiProviderRequest request) async {
    final response = await _httpClient.post(
      Uri.parse(
        'https://generativelanguage.googleapis.com/v1beta/models/${request.model}:generateContent?key=${request.apiKey}',
      ),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({
        'systemInstruction': {
          'parts': [
            {'text': request.systemPrompt},
          ],
        },
        'contents': [
          for (final message in request.messages)
            {
              'role': message.role == AiMessageRole.user ? 'user' : 'model',
              'parts': [
                {'text': message.content},
              ],
            },
        ],
        'generationConfig': {
          'temperature': 0.2,
          'responseMimeType': 'application/json',
        },
      }),
    );

    _ensureSuccess(response);
    final decoded = jsonDecode(response.body) as Map<String, dynamic>;
    final candidates = decoded['candidates'] as List<dynamic>? ?? [];
    final first = candidates.isEmpty ? null : candidates.first;
    final content = first is Map<String, dynamic>
        ? first['content'] as Map<String, dynamic>?
        : null;
    final parts = content?['parts'] as List<dynamic>? ?? [];
    final buffer = StringBuffer();
    for (final part in parts) {
      if (part is Map<String, dynamic>) {
        buffer.write(part['text'] ?? '');
      }
    }
    return _parser.parse(buffer.toString());
  }

  @override
  Future<AiValidationResult> validateApiKey(String apiKey) async {
    final response = await _httpClient.get(
      Uri.parse(
        'https://generativelanguage.googleapis.com/v1beta/models?key=$apiKey',
      ),
    );
    if (response.statusCode == 200) {
      return const AiValidationResult(
        isValid: true,
        message: 'Gemini key validated successfully.',
      );
    }
    return const AiValidationResult(
      isValid: false,
      message: 'Gemini rejected this API key.',
    );
  }

  void _ensureSuccess(http.Response response) {
    if (response.statusCode >= 200 && response.statusCode < 300) return;
    throw StateError(
      SecretRedactor.redact(
        'Gemini request failed with ${response.statusCode}: ${response.body}',
      ),
    );
  }
}
