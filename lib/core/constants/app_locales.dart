import 'package:flutter/material.dart';

/// Centralized locale configuration for the application.
///
/// Defines all supported locales for RTL support and localisation.
/// Add new locales here to enable them throughout the app.
///
/// Follows Golden Rule #7 (No Magic Values) and #19 (Feature Toggle Ready).
abstract final class AppLocales {
  /// All locales the app supports. The first entry is the default fallback.
  static const List<Locale> supportedLocales = [
    Locale('en', 'US'),
    Locale('ar'), // Arabic — RTL
    Locale('ur'), // Urdu — RTL
  ];

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
    for (final locale in supportedLocales) {
      if (locale.languageCode == languageCode) {
        return locale;
      }
    }
    return supportedLocales.first;
  }
}
