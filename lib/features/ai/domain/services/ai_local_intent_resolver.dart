import '../entities/entities.dart';

class AiLocalIntentResolver {
  AiProviderResponse resolve(String prompt) {
    final value = prompt.toLowerCase();

    if (_containsAny(value, ['profile', 'account'])) {
      return _action('Opening your profile.', 'OPEN_PROFILE');
    }
    if (_containsAny(value, ['ai setting', 'api key', 'provider'])) {
      return _action('Opening AI settings.', 'OPEN_AI_SETTINGS');
    }
    if (_containsAny(value, ['practice', 'quiz', 'test'])) {
      return _action('Opening practice.', 'OPEN_PRACTICE');
    }
    if (_containsAny(value, ['saved', 'bookmark', 'bookmarks'])) {
      return _action('Opening saved formulas.', 'OPEN_SAVED');
    }
    if (_containsAny(value, ['subject', 'chapter', 'formula'])) {
      return _action('Opening subjects.', 'OPEN_SUBJECTS');
    }
    if (_containsAny(value, ['analytics', 'progress', 'performance'])) {
      return _action('Opening analytics.', 'OPEN_ANALYTICS');
    }
    if (_containsAny(value, ['planner', 'schedule', 'study plan'])) {
      return _action('Opening study planner.', 'OPEN_STUDY_PLANNER');
    }
    if (_containsAny(value, ['flashcard', 'flash card'])) {
      return _action('Opening flashcards.', 'OPEN_FLASHCARDS');
    }
    if (_containsAny(value, ['cheat sheet', 'revision sheet'])) {
      return _action('Opening the cheat sheet.', 'OPEN_CHEAT_SHEET');
    }
    if (_containsAny(value, ['help', 'support', 'ticket'])) {
      return _action('Opening Help and Support.', 'OPEN_HELP_SUPPORT');
    }
    if (_containsAny(value, ['home', 'dashboard'])) {
      return _action('Opening the dashboard.', 'OPEN_DASHBOARD');
    }
    if (_containsAny(value, ['go back', 'back'])) {
      return _action('Going back.', 'GO_BACK');
    }

    if (_containsAny(value, ['attendance', 'orders', 'menu', 'student'])) {
      return const AiProviderResponse(
        message:
            'That module is not available in Formula Scholar yet. I can help with subjects, formulas, practice, saved items, analytics, study planner, profile, and support.',
      );
    }

    return const AiProviderResponse(
      message:
          'I can still help offline with navigation. Try "open practice", "show saved formulas", or "open AI settings".',
    );
  }

  bool _containsAny(String value, List<String> terms) {
    return terms.any(value.contains);
  }

  AiProviderResponse _action(String message, String actionId) {
    return AiProviderResponse(
      message: message,
      actionRequest: AiActionRequest(action: actionId),
    );
  }
}
