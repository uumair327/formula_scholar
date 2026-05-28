import 'package:flutter/widgets.dart';

import '../l10n/l10n.dart';

extension LocalizedErrorExtensions on BuildContext {
  String localizedError({String? errorKey, String? fallback}) {
    if (errorKey != null) {
      switch (errorKey) {
        case 'profile.load_failed':
          return l10n.failedToLoadProfile;
        case 'profile.update_failed':
          return l10n.failedToUpdateProfile;
        case 'dashboard.curriculum.options.load_failed':
          return l10n.dashboardCurriculumOptionsLoadFailed;
        case 'chapters.formulas.load_failed':
          return l10n.chaptersFormulasLoadFailed;
        case 'chapters.toggle_mastery_failed':
          return l10n.chaptersToggleMasteryFailed;
        case 'chapters.toggle_bookmark_failed':
          return l10n.chaptersToggleBookmarkFailed;
        case 'chapters.toggle_chapter_bookmark_failed':
          return l10n.chaptersToggleChapterBookmarkFailed;
        case 'dashboard.curriculum.required':
          return l10n.dashboardCurriculumRequired;
        case 'dashboard.load_failed':
          return l10n.failedToLoadDashboard;
        default:
          break;
      }
    }

    if (fallback != null && fallback.isNotEmpty) return fallback;
    return l10n.somethingWentWrong;
  }
}
