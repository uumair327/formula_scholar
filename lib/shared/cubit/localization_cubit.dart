import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:hydrated_bloc/hydrated_bloc.dart';

import '../../core/core.dart';

class LocalizationCubit extends HydratedCubit<LocalizationState> {
  LocalizationCubit() : super(const LocalizationState()) {
    // Sync AppLocales globals from hydrated (restored) state so adapters
    // respect the persisted toggle immediately, without user interaction.
    AppLocales.contentLocalizationEnabled = state.contentLocalizationEnabled;
    AppLocales.currentLocaleCode = state.effectiveContentLocaleCode;
  }

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
    // publish to AppLocales so adapters can read current content locale
    AppLocales.contentLocalizationEnabled = enabled;
    AppLocales.currentLocaleCode = state
        .copyWith(
          contentLocalizationEnabled: enabled,
          contentLocaleCode: AppLocales.normalizeContentLocaleCode(nextCode),
        )
        .contentLocaleCode;
  }

  void setContentLocaleCode(String localeCode) {
    final normalized = AppLocales.normalizeContentLocaleCode(localeCode);
    AppLogger.info(
      'Content locale selected: $normalized',
      tag: AppLogTags.localizationCubit,
    );
    emit(state.copyWith(contentLocaleCode: normalized));
    AppLocales.currentLocaleCode = normalized;
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

  StreamSubscription<DocumentSnapshot<Map<String, dynamic>>>?
  _configSubscription;

  void listenToBackendConfig() {
    _configSubscription?.cancel();
    _configSubscription = FirebaseFirestore.instance
        .collection('runtime_settings')
        .doc('global')
        .snapshots()
        .listen(
          (snap) {
            if (snap.exists) {
              final data = snap.data();
              if (data != null) {
                final enabled =
                    data['contentLocalizationEnabled'] as bool? ?? true;
                if (enabled != state.contentLocalizationEnabled) {
                  setContentLocalizationEnabled(enabled);
                }

                final localesRaw = data['supportedLocales'] as List<dynamic>?;
                if (localesRaw != null) {
                  final List<ContentLocaleConfig> loadedLocales = [];
                  for (final raw in localesRaw) {
                    if (raw is Map) {
                      final code = raw['code'] as String?;
                      final name = raw['name'] as String?;
                      final isRtl = raw['isRtl'] as bool? ?? false;
                      if (code != null && name != null) {
                        loadedLocales.add(
                          ContentLocaleConfig(
                            code: code,
                            name: name,
                            isRtl: isRtl,
                          ),
                        );
                      }
                    }
                  }
                  if (loadedLocales.isNotEmpty) {
                    AppLocales.contentSupportedLocales = loadedLocales;
                    AppLocales.contentSupportedLocaleCodes = loadedLocales
                        .map((e) => e.code)
                        .toList();
                  }
                }
              }
            }
          },
          onError: (Object error, [StackTrace? stackTrace]) {
            if (error is FirebaseException &&
                error.code == 'permission-denied') {
              AppLogger.warning(
                'Permission denied while listening to localization runtime settings; keeping defaults',
                tag: AppLogTags.localizationCubit,
              );
              _configSubscription?.cancel();
              _configSubscription = null;
              return;
            }

            AppLogger.error(
              'Error listening to localization runtime settings',
              tag: AppLogTags.localizationCubit,
              error: error,
              stackTrace: stackTrace,
            );
          },
        );
  }

  @override
  Future<void> close() {
    _configSubscription?.cancel();
    return super.close();
  }
}
