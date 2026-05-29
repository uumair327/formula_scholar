import 'dart:convert';

import 'package:http/http.dart' as http;

import '../../../../core/core.dart';
import '../../domain/domain.dart';

class ClaudeProviderClient implements AiProviderClientPort {
  ClaudeProviderClient({
    required http.Client httpClient,
    required AiResponseParser parser,
  }) : _httpClient = httpClient,
       _parser = parser;

  final http.Client _httpClient;
  final AiResponseParser _parser;

  @override
  AiProviderType get provider => AiProviderType.claude;

  @override
  Future<AiProviderResponse> complete(AiProviderRequest request) async {
    final response = await _httpClient.post(
      Uri.parse('https://api.anthropic.com/v1/messages'),
      headers: {
        'x-api-key': request.apiKey,
        'anthropic-version': '2023-06-01',
        'Content-Type': 'application/json',
      },
      body: jsonEncode({
        'model': request.model,
        'max_tokens': 800,
        'temperature': 0.2,
        'system': request.systemPrompt,
        'messages': [
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
    final blocks = decoded['content'] as List<dynamic>? ?? [];
    final buffer = StringBuffer();
    for (final block in blocks) {
      if (block is Map<String, dynamic> && block['type'] == 'text') {
        buffer.write(block['text']);
      }
    }
    return _parser.parse(buffer.toString());
  }

  @override
  Future<AiValidationResult> validateApiKey(String apiKey) async {
    final response = await _httpClient.get(
      Uri.parse('https://api.anthropic.com/v1/models'),
      headers: {'x-api-key': apiKey, 'anthropic-version': '2023-06-01'},
    );
    if (response.statusCode == 200) {
      return const AiValidationResult(
        isValid: true,
        message: 'Claude key validated successfully.',
      );
    }
    return const AiValidationResult(
      isValid: false,
      message: 'Claude rejected this API key.',
    );
  }

  void _ensureSuccess(http.Response response) {
    if (response.statusCode >= 200 && response.statusCode < 300) return;
    throw StateError(
      SecretRedactor.redact(
        'Claude request failed with ${response.statusCode}: ${response.body}',
      ),
    );
  }
}
