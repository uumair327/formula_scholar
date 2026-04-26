import 'package:injectable/injectable.dart';

import '../../../core/core.dart';
import '../../domain/domain.dart';

@LazySingleton(as: ThemePreferenceRepositoryPort)
class ThemePreferenceRepositoryImpl implements ThemePreferenceRepositoryPort {
  const ThemePreferenceRepositoryImpl(this._dataSource);
  final ThemePreferenceDataSourcePort _dataSource;

  @override
  Future<ThemePreference?> loadThemePreference() async {
    try {
      final preference = await _dataSource.loadThemePreference();
      AppLogger.info(
        'Theme preference loaded: ${preference?.isDarkMode ?? false}',
        tag: AppLogTags.themePreferenceRepo,
      );
      return preference;
    } on Exception catch (error, stackTrace) {
      AppLogger.error(
        'Failed to load theme preference in repository',
        tag: AppLogTags.themePreferenceRepo,
        error: error,
        stackTrace: stackTrace,
      );
      throw const ServerException(message: 'Failed to load theme preference');
    }
  }

  @override
  Future<void> saveThemePreference(ThemePreference preference) async {
    try {
      await _dataSource.saveThemePreference(preference);
      AppLogger.info(
        'Theme preference saved: ${preference.isDarkMode}',
        tag: AppLogTags.themePreferenceRepo,
      );
    } on Exception catch (error, stackTrace) {
      AppLogger.error(
        'Failed to save theme preference in repository',
        tag: AppLogTags.themePreferenceRepo,
        error: error,
        stackTrace: stackTrace,
      );
      throw const ServerException(message: 'Failed to save theme preference');
    }
  }

  @override
  Stream<ThemePreference?> watchThemePreference() {
    return _dataSource.watchThemePreference().map((preference) {
      AppLogger.trace(
        'Theme preference stream event: ${preference?.isDarkMode ?? false}',
        tag: AppLogTags.themePreferenceRepo,
      );
      return preference;
    });
  }
}
