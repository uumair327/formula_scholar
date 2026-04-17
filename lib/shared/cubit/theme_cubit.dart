import 'dart:async';

import 'package:hydrated_bloc/hydrated_bloc.dart';
import 'package:injectable/injectable.dart';

import '../../core/core.dart';
import '../domain/domain.dart';
import 'theme_state.dart';

@lazySingleton
class ThemeCubit extends HydratedCubit<ThemeState> {
  final LoadThemePreferenceUseCase _loadThemePreference;
  final SaveThemePreferenceUseCase _saveThemePreference;
  final WatchThemePreferenceUseCase _watchThemePreference;
  late final StreamSubscription<ThemePreference?> _themeSubscription;

  ThemeCubit({
    required LoadThemePreferenceUseCase loadThemePreference,
    required SaveThemePreferenceUseCase saveThemePreference,
    required WatchThemePreferenceUseCase watchThemePreference,
  }) : _loadThemePreference = loadThemePreference,
       _saveThemePreference = saveThemePreference,
       _watchThemePreference = watchThemePreference,
       super(const ThemeState()) {
    _themeSubscription = _watchThemePreference().listen(
      _syncThemeFromStream,
      onError: (Object error, StackTrace stackTrace) {
        AppLogger.error(
          'Theme preference stream failed',
          tag: AppLogTags.themePreferenceCubit,
          error: error,
          stackTrace: stackTrace,
        );
      },
    );

    Future.microtask(refresh);
  }

  Future<void> refresh() async {
    AppLogger.info(
      'Refreshing theme preference from repository',
      tag: AppLogTags.themePreferenceCubit,
    );

    try {
      final preference = await _loadThemePreference();
      _syncThemeFromStream(preference);
    } catch (error, stackTrace) {
      AppLogger.error(
        'Failed to load theme preference from repository',
        tag: AppLogTags.themePreferenceCubit,
        error: error,
        stackTrace: stackTrace,
      );
    }
  }

  Future<void> toggleTheme() async {
    final newValue = !state.isDarkMode;
    final previous = state;

    emit(state.copyWith(isDarkMode: newValue));

    try {
      await _saveThemePreference(ThemePreference(isDarkMode: newValue));
    } catch (error, stackTrace) {
      AppLogger.error(
        'Failed to persist theme preference',
        tag: AppLogTags.themePreferenceCubit,
        error: error,
        stackTrace: stackTrace,
      );
      emit(previous);
    }
  }

  void _syncThemeFromStream(ThemePreference? preference) {
    if (preference == null) {
      return;
    }

    final nextValue = preference.isDarkMode;
    if (nextValue == state.isDarkMode) {
      return;
    }

    AppLogger.info(
      'Applying synced theme preference: $nextValue',
      tag: AppLogTags.themePreferenceCubit,
    );
    emit(state.copyWith(isDarkMode: nextValue));
  }

  @override
  ThemeState? fromJson(Map<String, dynamic> json) {
    return ThemeState(isDarkMode: json['isDarkMode'] as bool? ?? false);
  }

  @override
  Map<String, dynamic>? toJson(ThemeState state) {
    return {'isDarkMode': state.isDarkMode};
  }

  @override
  Future<void> close() async {
    await _themeSubscription.cancel();
    return super.close();
  }
}
