import 'package:injectable/injectable.dart';

import '../../../core/core.dart';
import '../entities/theme_preference.dart';
import '../ports/theme_preference_repository_port.dart';

@injectable
class WatchThemePreferenceUseCase {
  final ThemePreferenceRepositoryPort _repository;

  const WatchThemePreferenceUseCase(this._repository);

  Stream<ThemePreference?> call() {
    AppLogger.trace(
      'WatchThemePreferenceUseCase called',
      tag: AppLogTags.themePreferenceUseCase,
    );
    return _repository.watchThemePreference();
  }
}
