import '../entities/entities.dart';

abstract class AiSettingsRepositoryPort {
  Future<AiSettings> loadSettings();

  Future<void> saveProvider(AiProviderType provider);

  Future<void> saveModel(String? model);

  Future<void> saveApiKey({
    required AiProviderType provider,
    required String apiKey,
  });

  Future<void> deleteApiKey(AiProviderType provider);

  Future<String?> readApiKey(AiProviderType provider);

  Future<AiValidationResult> validateApiKey(AiProviderType provider);
}
