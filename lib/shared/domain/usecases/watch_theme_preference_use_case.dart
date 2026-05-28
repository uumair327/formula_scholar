import 'package:injectable/injectable.dart';

import '../../../core/core.dart';

@injectable
class WatchThemePreferenceUseCase {
  const WatchThemePreferenceUseCase(this._repository);
  final ThemePreferenceRepositoryPort _repository;

  Stream<ThemePreference?> call() {
    AppLogger.trace(
      'WatchThemePreferenceUseCase called',
      tag: AppLogTags.themePreferenceUseCase,
    );
    return _repository.watchThemePreference();
  }
}
