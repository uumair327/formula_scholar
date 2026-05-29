import '../entities/entities.dart';
import '../ports/ports.dart';

class SaveAiSettingsUseCase {
  const SaveAiSettingsUseCase(this._repository);

  final AiSettingsRepositoryPort _repository;

  Future<void> saveProvider(AiProviderType provider) {
    return _repository.saveProvider(provider);
  }

  Future<void> saveModel(String? model) {
    return _repository.saveModel(model);
  }

  Future<void> saveApiKey({
    required AiProviderType provider,
    required String apiKey,
  }) {
    return _repository.saveApiKey(provider: provider, apiKey: apiKey);
  }

  Future<void> deleteApiKey(AiProviderType provider) {
    return _repository.deleteApiKey(provider);
  }
}
