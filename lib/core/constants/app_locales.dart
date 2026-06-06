import 'package:flutter/material.dart';

/// Configuration for a content locale dynamically managed via backend.
class ContentLocaleConfig {
  const ContentLocaleConfig({
    required this.code,
    required this.name,
    required this.isRtl,
  });

  final String code;
  final String name;
  final bool isRtl;
}

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
    Locale('mr'), // Marathi
  ];

  /// MaterialApp uses this list.
  static const List<Locale> supportedLocales = appLabelSupportedLocales;

  static const String defaultAppLabelLanguageCode = 'en';
  static const Locale defaultAppLabelLocale = Locale('en', 'US');

  /// List of supported content locales with display name and RTL info.
  static List<ContentLocaleConfig> contentSupportedLocales = [
    const ContentLocaleConfig(
      code: 'en-IN',
      name: 'English (India)',
      isRtl: false,
    ),
    const ContentLocaleConfig(code: 'ar-IN', name: 'Arabic', isRtl: true),
    const ContentLocaleConfig(code: 'ur-IN', name: 'Urdu', isRtl: true),
    const ContentLocaleConfig(code: 'mr-IN', name: 'Marathi', isRtl: false),
  ];

  /// Locale codes used for dashboard-driven backend content.
  static List<String> contentSupportedLocaleCodes = [
    'en-IN',
    'ar-IN',
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
      'ar' => 'ar-IN',
      'en' => 'en-IN',
      'ur' => 'ur-IN',
      'mr' => 'mr-IN',
      _ => defaultContentLocaleCode,
    };
  }

  /// Holds the currently selected content locale code for runtime adapters
  /// to read. This is updated by `LocalizationCubit` when user switches
  /// content language at runtime.
  static String currentLocaleCode = defaultContentLocaleCode;

  /// Whether backend-managed content localization is enabled.
  /// When `false`, adapters should skip the `localized` map and always
  /// return the top-level default fields.
  static bool contentLocalizationEnabled = true;

  static List<String> contentLocaleFallbacks(String? localeCode) {
    final normalized = normalizeContentLocaleCode(localeCode);
    final languageCode = normalized.split('-').first;

    final fallbacks = <String>[normalized];
    if (!fallbacks.contains(languageCode)) {
      fallbacks.add(languageCode);
    }
    if (!fallbacks.contains(defaultContentLocaleCode)) {
      fallbacks.add(defaultContentLocaleCode);
    }
    return fallbacks;
  }
}
