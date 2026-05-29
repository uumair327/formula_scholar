import '../entities/entities.dart';
import '../ports/ports.dart';

class LoadAiSettingsUseCase {
  const LoadAiSettingsUseCase(this._repository);

  final AiSettingsRepositoryPort _repository;

  Future<AiSettings> call() {
    return _repository.loadSettings();
  }
}
