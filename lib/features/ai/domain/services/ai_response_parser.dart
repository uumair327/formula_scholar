import 'dart:convert';

import '../entities/entities.dart';

class AiResponseParser {
  AiProviderResponse parse(String rawText) {
    final trimmed = rawText.trim();
    final jsonText = _extractJson(trimmed);
    if (jsonText == null) {
      return AiProviderResponse(message: trimmed);
    }

    final decoded = jsonDecode(jsonText);
    if (decoded is! Map<String, dynamic>) {
      return AiProviderResponse(message: trimmed);
    }

    final message = (decoded['message'] ?? '').toString().trim();
    final action = (decoded['action'] ?? 'NONE').toString().trim();
    final requiresClarification = decoded['requires_clarification'] == true;
    final widgetConfig = decoded['widget'] as Map<String, dynamic>?;

    return AiProviderResponse(
      message: message.isEmpty ? _fallbackMessage(action) : message,
      actionRequest: action.isNotEmpty && action.toUpperCase() != 'NONE'
          ? AiActionRequest.fromJson(decoded)
          : null,
      widgetConfig: widgetConfig,
      requiresClarification: requiresClarification,
    );
  }

  String? _extractJson(String value) {
    if (value.startsWith('{') && value.endsWith('}')) return value;

    final fenceStart = value.indexOf('```');
    if (fenceStart >= 0) {
      final openBrace = value.indexOf('{', fenceStart);
      final closeFence = value.lastIndexOf('```');
      if (openBrace >= 0 && closeFence > openBrace) {
        return value.substring(openBrace, closeFence).trim();
      }
    }

    final start = value.indexOf('{');
    final end = value.lastIndexOf('}');
    if (start >= 0 && end > start) {
      return value.substring(start, end + 1);
    }

    return null;
  }

  String _fallbackMessage(String action) {
    if (action.isEmpty || action.toUpperCase() == 'NONE') {
      return 'I can help with Formula Scholar actions and study guidance.';
    }
    return 'I found an app action for that.';
  }
}
