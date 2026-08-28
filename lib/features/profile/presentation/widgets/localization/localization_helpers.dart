import 'package:flutter/material.dart';
import '../../../../../core/core.dart';

class LocalizationHelpers {
  static String displayLabelLanguageName(BuildContext context, String code) {
    final l10n = context.l10n;
    return switch (code) {
      'en' => l10n.languageEnglish,
      'ar' => l10n.languageArabic,
      'ur' => l10n.languageUrdu,
      'mr' => l10n.languageMarathi,
      _ => l10n.languageEnglish,
    };
  }

  static String displayContentLanguageName(BuildContext context, String code) {
    final l10n = context.l10n;
    final localName = switch (code) {
      'ar-IN' => l10n.languageArabic,
      'en-IN' => l10n.languageEnglishIndia,
      'ur-IN' => l10n.languageUrdu,
      'mr-IN' => l10n.languageMarathi,
      _ => null,
    };
    if (localName != null) {
      return localName;
    }
    for (final loc in AppLocales.contentSupportedLocales) {
      if (loc.code == code) {
        return loc.name;
      }
    }
    return code;
  }

  static String languageAbbreviation(String code) {
    if (code.isEmpty) return '';
    return code.split('-').first.toUpperCase();
  }
}
