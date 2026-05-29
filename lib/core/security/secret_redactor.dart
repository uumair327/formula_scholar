abstract final class SecretRedactor {
  static final RegExp _apiKeyPattern = RegExp(
    r"""(api[_-]?key|token|secret|authorization)\s*[:=]\s*["']?[^,\s"'}]+""",
    caseSensitive: false,
  );

  static final RegExp _bearerPattern = RegExp(
    r'bearer\s+[a-z0-9._-]{12,}',
    caseSensitive: false,
  );

  static String redact(String value) {
    return value
        .replaceAllMapped(_apiKeyPattern, (match) {
          final label = match.group(1) ?? 'secret';
          return '$label: [redacted]';
        })
        .replaceAll(_bearerPattern, 'Bearer [redacted]');
  }

  static String maskSecret(String? value) {
    if (value == null || value.isEmpty) return '';
    if (value.length <= 8) return '********';
    return '${value.substring(0, 4)}...${value.substring(value.length - 4)}';
  }

  static Map<String, dynamic> redactMap(Map<String, dynamic> value) {
    return value.map((key, mapValue) {
      final keyLower = key.toLowerCase();
      if (keyLower.contains('key') ||
          keyLower.contains('token') ||
          keyLower.contains('secret') ||
          keyLower.contains('authorization')) {
        return MapEntry(key, '[redacted]');
      }
      if (mapValue is String) {
        return MapEntry(key, redact(mapValue));
      }
      if (mapValue is Map<String, dynamic>) {
        return MapEntry(key, redactMap(mapValue));
      }
      return MapEntry(key, mapValue);
    });
  }
}
