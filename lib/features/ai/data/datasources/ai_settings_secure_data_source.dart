import 'package:flutter_secure_storage/flutter_secure_storage.dart';

import '../../../../core/core.dart';
import '../../domain/domain.dart';

class AiSettingsSecureDataSource {
  const AiSettingsSecureDataSource(this._storage);

  final FlutterSecureStorage _storage;

  static const String _providerKey = 'ai.selected_provider';
  static const String _modelKey = 'ai.selected_model';

  Future<AiProviderType> readProvider() async {
    final value = await _storage.read(key: _providerKey);
    return AiProviderType.fromId(value);
  }

  Future<void> writeProvider(AiProviderType provider) {
    return _storage.write(key: _providerKey, value: provider.id);
  }

  Future<String?> readModel() {
    return _storage.read(key: _modelKey);
  }

  Future<void> writeModel(String? model) {
    final sanitized = model?.trim();
    if (sanitized == null || sanitized.isEmpty) {
      return _storage.delete(key: _modelKey);
    }
    return _storage.write(key: _modelKey, value: sanitized);
  }

  Future<String?> readApiKey(AiProviderType provider) {
    return _storage.read(key: _apiKeyStorageKey(provider));
  }

  Future<void> writeApiKey({
    required AiProviderType provider,
    required String apiKey,
  }) {
    final sanitized = SecretRedactor.redact(apiKey.trim());
    return _storage.write(key: _apiKeyStorageKey(provider), value: sanitized);
  }

  Future<void> deleteApiKey(AiProviderType provider) {
    return _storage.delete(key: _apiKeyStorageKey(provider));
  }

  String _apiKeyStorageKey(AiProviderType provider) {
    return 'ai.${provider.id}.api_key';
  }
}
