import 'dart:convert';

import 'package:http/http.dart' as http;

import '../../../../core/core.dart';
import '../../domain/domain.dart';

class OpenAiProviderClient implements AiProviderClientPort {
  OpenAiProviderClient({
    required http.Client httpClient,
    required AiResponseParser parser,
  }) : _httpClient = httpClient,
       _parser = parser;

  final http.Client _httpClient;
  final AiResponseParser _parser;

  @override
  AiProviderType get provider => AiProviderType.openai;

  @override
  Future<AiProviderResponse> complete(AiProviderRequest request) async {
    final response = await _httpClient.post(
      Uri.parse('https://api.openai.com/v1/chat/completions'),
      headers: {
        'Authorization': 'Bearer ${request.apiKey}',
        'Content-Type': 'application/json',
      },
      body: jsonEncode({
        'model': request.model,
        'temperature': 0.2,
        'response_format': {'type': 'json_object'},
        'messages': [
          {'role': 'system', 'content': request.systemPrompt},
          for (final message in request.messages)
            {
              'role': message.role == AiMessageRole.user ? 'user' : 'assistant',
              'content': message.content,
            },
        ],
      }),
    );

    _ensureSuccess(response);
    final decoded = jsonDecode(response.body) as Map<String, dynamic>;
    final choices = decoded['choices'] as List<dynamic>? ?? [];
    final first = choices.isEmpty ? null : choices.first;
    final message = first is Map<String, dynamic>
        ? first['message'] as Map<String, dynamic>?
        : null;
    final content = (message?['content'] ?? '').toString();
    return _parser.parse(content);
  }

  @override
  Future<AiValidationResult> validateApiKey(String apiKey) async {
    final response = await _httpClient.get(
      Uri.parse('https://api.openai.com/v1/models'),
      headers: {'Authorization': 'Bearer $apiKey'},
    );
    if (response.statusCode == 200) {
      return const AiValidationResult(
        isValid: true,
        message: 'OpenAI key validated successfully.',
      );
    }
    return const AiValidationResult(
      isValid: false,
      message: 'OpenAI rejected this API key.',
    );
  }

  void _ensureSuccess(http.Response response) {
    if (response.statusCode >= 200 && response.statusCode < 300) return;
    throw StateError(
      SecretRedactor.redact(
        'OpenAI request failed with ${response.statusCode}: ${response.body}',
      ),
    );
  }
}
