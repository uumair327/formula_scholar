import 'package:flutter/material.dart';

import '../../core/core.dart';

/// User-controlled localization preferences split by concern:
/// 1) app labels/navigation locale
/// 2) backend content locale
class LocalizationState {
  const LocalizationState({
    this.appLabelLocalizationEnabled = true,
    this.useSystemAppLabelLocale = true,
    this.appLabelLanguageCode = AppLocales.defaultAppLabelLanguageCode,
    this.contentLocalizationEnabled = true,
    this.contentLocaleCode = AppLocales.defaultContentLocaleCode,
  });

  final bool appLabelLocalizationEnabled;
  final bool useSystemAppLabelLocale;
  final String appLabelLanguageCode;
  final bool contentLocalizationEnabled;
  final String contentLocaleCode;

  LocalizationState copyWith({
    bool? appLabelLocalizationEnabled,
    bool? useSystemAppLabelLocale,
    String? appLabelLanguageCode,
    bool? contentLocalizationEnabled,
    String? contentLocaleCode,
  }) {
    return LocalizationState(
      appLabelLocalizationEnabled:
          appLabelLocalizationEnabled ?? this.appLabelLocalizationEnabled,
      useSystemAppLabelLocale:
          useSystemAppLabelLocale ?? this.useSystemAppLabelLocale,
      appLabelLanguageCode: appLabelLanguageCode ?? this.appLabelLanguageCode,
      contentLocalizationEnabled:
          contentLocalizationEnabled ?? this.contentLocalizationEnabled,
      contentLocaleCode: contentLocaleCode ?? this.contentLocaleCode,
    );
  }

  Locale effectiveAppLocale(Locale systemLocale) {
    if (!appLabelLocalizationEnabled) {
      return AppLocales.defaultAppLabelLocale;
    }

    if (useSystemAppLabelLocale) {
      return AppLocales.resolveAppLabelLocale(systemLocale.languageCode);
    }

    return AppLocales.resolveAppLabelLocale(appLabelLanguageCode);
  }

  String get effectiveContentLocaleCode {
    if (!contentLocalizationEnabled) {
      return AppLocales.defaultContentLocaleCode;
    }
    return AppLocales.normalizeContentLocaleCode(contentLocaleCode);
  }

  Map<String, dynamic> toJson() {
    return <String, dynamic>{
      'appLabelLocalizationEnabled': appLabelLocalizationEnabled,
      'useSystemAppLabelLocale': useSystemAppLabelLocale,
      'appLabelLanguageCode': appLabelLanguageCode,
      'contentLocalizationEnabled': contentLocalizationEnabled,
      'contentLocaleCode': contentLocaleCode,
    };
  }

  static LocalizationState fromJson(Map<String, dynamic> json) {
    final appLabelEnabled =
        json['appLabelLocalizationEnabled'] as bool? ?? true;
    final useSystemAppLabelLocale =
        json['useSystemAppLabelLocale'] as bool? ?? true;
    final appLabelLanguageCode = AppLocales.resolveAppLabelLocale(
      (json['appLabelLanguageCode'] as String?) ??
          AppLocales.defaultAppLabelLanguageCode,
    ).languageCode;

    return LocalizationState(
      appLabelLocalizationEnabled: appLabelEnabled,
      useSystemAppLabelLocale: useSystemAppLabelLocale,
      appLabelLanguageCode: appLabelLanguageCode,
      contentLocalizationEnabled:
          json['contentLocalizationEnabled'] as bool? ?? true,
      contentLocaleCode: AppLocales.normalizeContentLocaleCode(
        json['contentLocaleCode'] as String?,
      ),
    );
  }
}
