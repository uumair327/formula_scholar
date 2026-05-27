import 'package:flutter/material.dart';
import 'package:hydrated_bloc/hydrated_bloc.dart';

import '../../core/core.dart';
import 'localization_state.dart';

class LocalizationCubit extends HydratedCubit<LocalizationState> {
  LocalizationCubit() : super(const LocalizationState());

  void setAppLabelLocalizationEnabled(bool enabled) {
    final nextState = state.copyWith(
      appLabelLocalizationEnabled: enabled,
      useSystemAppLabelLocale: enabled ? state.useSystemAppLabelLocale : false,
      appLabelLanguageCode: enabled
          ? state.appLabelLanguageCode
          : AppLocales.defaultAppLabelLanguageCode,
    );

    AppLogger.info(
      'App label localization set to: $enabled',
      tag: AppLogTags.localizationCubit,
    );
    emit(nextState);
  }

  void setUseSystemAppLabelLocale(bool useSystem) {
    AppLogger.info(
      'Use system app label locale: $useSystem',
      tag: AppLogTags.localizationCubit,
    );
    emit(state.copyWith(useSystemAppLabelLocale: useSystem));
  }

  void setAppLabelLanguageCode(String languageCode) {
    final resolved = AppLocales.resolveAppLabelLocale(
      languageCode,
    ).languageCode;
    AppLogger.info(
      'App label language selected: $resolved',
      tag: AppLogTags.localizationCubit,
    );
    emit(state.copyWith(appLabelLanguageCode: resolved));
  }

  void setContentLocalizationEnabled(bool enabled) {
    final nextCode = enabled
        ? state.contentLocaleCode
        : AppLocales.defaultContentLocaleCode;

    AppLogger.info(
      'Content localization set to: $enabled',
      tag: AppLogTags.localizationCubit,
    );
    emit(
      state.copyWith(
        contentLocalizationEnabled: enabled,
        contentLocaleCode: AppLocales.normalizeContentLocaleCode(nextCode),
      ),
    );
  }

  void setContentLocaleCode(String localeCode) {
    final normalized = AppLocales.normalizeContentLocaleCode(localeCode);
    AppLogger.info(
      'Content locale selected: $normalized',
      tag: AppLogTags.localizationCubit,
    );
    emit(state.copyWith(contentLocaleCode: normalized));
  }

  @override
  LocalizationState? fromJson(Map<String, dynamic> json) {
    try {
      return LocalizationState.fromJson(json);
    } catch (_) {
      return const LocalizationState();
    }
  }

  @override
  Map<String, dynamic>? toJson(LocalizationState state) {
    return state.toJson();
  }

  Locale effectiveAppLocale(Locale systemLocale) {
    return state.effectiveAppLocale(systemLocale);
  }

  String effectiveContentLocaleCode() {
    return state.effectiveContentLocaleCode;
  }
}
