import '../../../../core/core.dart';

class AiSanitizer {
  String sanitizeUserInput(String value) {
    final trimmed = SecretRedactor.redact(value.trim());
    if (trimmed.length <= 4000) return trimmed;
    return trimmed.substring(0, 4000);
  }

  String sanitizeAssistantOutput(String value) {
    return SecretRedactor.redact(value.trim());
  }
}
