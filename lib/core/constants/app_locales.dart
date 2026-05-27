import 'package:flutter/material.dart';

/// Centralized locale configuration for the application.
///
/// Defines all supported locales for RTL support and localisation.
/// Add new locales here to enable them throughout the app.
///
/// Follows Golden Rule #7 (No Magic Values) and #19 (Feature Toggle Ready).
abstract final class AppLocales {
  /// App-label locales supported by Flutter localizations.
  /// The first entry is the default fallback.
  static const List<Locale> appLabelSupportedLocales = [
    Locale('en', 'US'),
    Locale('ar'), // Arabic — RTL
    Locale('ur'), // Urdu — RTL
  ];

  /// MaterialApp uses this list.
  static const List<Locale> supportedLocales = appLabelSupportedLocales;

  static const String defaultAppLabelLanguageCode = 'en';
  static const Locale defaultAppLabelLocale = Locale('en', 'US');

  /// Locale codes used for dashboard-driven backend content.
  static const List<String> contentSupportedLocaleCodes = [
    'en-IN',
    'ur-IN',
    'mr-IN',
  ];

  static const String defaultContentLocaleCode = 'en-IN';

  /// Returns `true` if the given locale is an RTL language.
  static bool isRtl(Locale locale) {
    return switch (locale.languageCode) {
      'ar' || 'ur' || 'he' || 'fa' || 'ku' || 'ps' => true,
      _ => false,
    };
  }

  /// Returns the first matching supported locale for a language code,
  /// or the default (English) if unsupported.
  static Locale resolve(String languageCode) {
    return resolveAppLabelLocale(languageCode);
  }

  static Locale resolveAppLabelLocale(String languageCode) {
    for (final locale in supportedLocales) {
      if (locale.languageCode == languageCode) {
        return locale;
      }
    }
    return defaultAppLabelLocale;
  }

  static String normalizeContentLocaleCode(String? localeCode) {
    if (localeCode == null || localeCode.trim().isEmpty) {
      return defaultContentLocaleCode;
    }

    final normalized = localeCode.trim();
    if (contentSupportedLocaleCodes.contains(normalized)) {
      return normalized;
    }

    // Allow callers to pass only language code (for example "ur").
    return switch (normalized.toLowerCase()) {
      'en' => 'en-IN',
      'ur' => 'ur-IN',
      'mr' => 'mr-IN',
      _ => defaultContentLocaleCode,
    };
  }
}
