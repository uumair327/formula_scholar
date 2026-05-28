import 'package:injectable/injectable.dart';
import '../../../core/core.dart';

@injectable
class LoadThemePreferenceUseCase {
  const LoadThemePreferenceUseCase(this._repository);
  final ThemePreferenceRepositoryPort _repository;

  Future<ThemePreference?> call() {
    AppLogger.trace(
      'LoadThemePreferenceUseCase called',
      tag: AppLogTags.themePreferenceUseCase,
    );
    return _repository.loadThemePreference();
  }
}
