import 'package:injectable/injectable.dart';

import '../../../core/core.dart';
import '../entities/theme_preference.dart';
import '../ports/theme_preference_repository_port.dart';

@injectable
class LoadThemePreferenceUseCase {
  final ThemePreferenceRepositoryPort _repository;

  const LoadThemePreferenceUseCase(this._repository);

  Future<ThemePreference?> call() {
    AppLogger.trace(
      'LoadThemePreferenceUseCase called',
      tag: AppLogTags.themePreferenceUseCase,
    );
    return _repository.loadThemePreference();
  }
}
