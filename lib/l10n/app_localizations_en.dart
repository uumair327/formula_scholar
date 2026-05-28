// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for English (`en`).
class AppLocalizationsEn extends AppLocalizations {
  AppLocalizationsEn([String locale = 'en']) : super(locale);

  @override
  String get appName => 'Formula Scholar';

  @override
  String get dashboardHeroBadge => 'CBSE Syllabus • Grade 9';

  @override
  String get dashboardHeroTitle => 'Mastering Motion &\\nLaws of Forces';

  @override
  String dashboardHeroDescription(Object progress) {
    return 'Continue your journey through Physics. You\'re $progress% through the current chapter.';
  }

  @override
  String get dashboardResumeLesson => 'Resume Lesson';

  @override
  String get dashboardResumeSemantic => 'Resume learning';

  @override
  String get quickActionsTitle => 'Explore Tools';

  @override
  String get studyPlanner => 'Study Planner';

  @override
  String get viewAnalytics => 'View Analytics';

  @override
  String get flashcards => 'Flashcards';
}
