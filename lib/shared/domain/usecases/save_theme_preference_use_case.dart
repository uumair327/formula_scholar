import 'package:injectable/injectable.dart';

import '../../../core/core.dart';

@injectable
class SaveThemePreferenceUseCase {
  const SaveThemePreferenceUseCase(this._repository);
  final ThemePreferenceRepositoryPort _repository;

  Future<void> call(ThemePreference preference) {
    AppLogger.trace(
      'SaveThemePreferenceUseCase called',
      tag: AppLogTags.themePreferenceUseCase,
    );
    return _repository.saveThemePreference(preference);
  }
}
