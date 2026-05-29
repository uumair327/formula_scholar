import '../entities/entities.dart';
import '../ports/ports.dart';

class ValidateAiKeyUseCase {
  const ValidateAiKeyUseCase(this._repository);

  final AiSettingsRepositoryPort _repository;

  Future<AiValidationResult> call(AiProviderType provider) {
    return _repository.validateApiKey(provider);
  }
}
