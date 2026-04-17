import '../entities/theme_preference.dart';

abstract interface class ThemePreferenceRepositoryPort {
  Future<ThemePreference?> loadThemePreference();

  Future<void> saveThemePreference(ThemePreference preference);

  Stream<ThemePreference?> watchThemePreference();
}
