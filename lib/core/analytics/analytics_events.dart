import 'package:injectable/injectable.dart';

import 'analytics_service.dart';

abstract final class AnalyticsEvents {
  static const String appLaunch = 'app_launch';
  static const String userSignUp = 'user_sign_up';
  static const String userLogin = 'user_login';
  static const String userLogout = 'user_logout';
  static const String onboardingStarted = 'onboarding_started';
  static const String onboardingCompleted = 'onboarding_completed';
  static const String onboardingStep = 'onboarding_step';

  static const String dashboardView = 'dashboard_view';
  static const String dashboardRefresh = 'dashboard_refresh';
  static const String subjectView = 'subject_view';
  static const String subjectSelect = 'subject_select';
  static const String chapterView = 'chapter_view';
  static const String formulaView = 'formula_view';
  static const String formulaBookmark = 'formula_bookmark';
  static const String formulaUnbookmark = 'formula_unbookmark';
  static const String formulaMasteryUpdate = 'formula_mastery_update';

  static const String practiceStart = 'practice_start';
  static const String practiceQuestion = 'practice_question';
  static const String practiceComplete = 'practice_complete';
  static const String practiceResult = 'practice_result';

  static const String quizStart = 'quiz_start';
  static const String quizComplete = 'quiz_complete';
  static const String quizQuestion = 'quiz_question_answer';

  static const String analyticsView = 'analytics_view';
  static const String analyticsPeriodChange = 'analytics_period_change';
  static const String analyticsSubjectFilter = 'analytics_subject_filter';
  static const String analyticsRefresh = 'analytics_refresh';
  static const String analyticsExport = 'analytics_export';

  static const String flashcardReview = 'flashcard_review';
  static const String flashcardSessionStart = 'flashcard_session_start';
  static const String flashcardSessionComplete = 'flashcard_session_complete';

  static const String achievementUnlocked = 'achievement_unlocked';
  static const String achievementView = 'achievement_view';

  static const String searchQuery = 'search_query';
  static const String searchResultTap = 'search_result_tap';

  static const String studyPlanCreate = 'study_plan_create';
  static const String studyPlanComplete = 'study_plan_complete';
  static const String aiAssistantQuery = 'ai_assistant_query';

  static const String profileView = 'profile_view';
  static const String profileEdit = 'profile_edit';
  static const String settingsChange = 'settings_change';

  static const String curriculumChange = 'curriculum_change';
  static const String performanceView = 'performance_view';
  static const String growthMetricsView = 'growth_metrics_view';
}

abstract final class AnalyticsParams {
  static const String screen = 'screen';
  static const String screenClass = 'screen_class';
  static const String userId = 'user_id';
  static const String subjectId = 'subject_id';
  static const String subjectName = 'subject_name';
  static const String chapterId = 'chapter_id';
  static const String chapterName = 'chapter_name';
  static const String formulaId = 'formula_id';
  static const String formulaTitle = 'formula_title';
  static const String category = 'category';
  static const String questionId = 'question_id';
  static const String totalQuestions = 'total_questions';
  static const String correctCount = 'correct_count';
  static const String accuracy = 'accuracy';
  static const String duration = 'duration_seconds';
  static const String difficulty = 'difficulty';
  static const String score = 'score';
  static const String step = 'step';
  static const String method = 'method';
  static const String query = 'query';
  static const String resultCount = 'result_count';
  static const String period = 'period';
  static const String board = 'board';
  static const String grade = 'grade';
  static const String locale = 'locale';
  static const String feature = 'feature';
  static const String action = 'action';
  static const String source = 'source';
  static const String value = 'value';
  static const String enabled = 'enabled';
  static const String progress = 'progress';
  static const String level = 'level';
  static const String count = 'count';
  static const String tier = 'tier';
  static const String status = 'status';
  static const String errorMessage = 'error_message';
  static const String masteryLevel = 'mastery_level';
  static const String streak = 'streak';
  static const String formulasCount = 'formulas_count';
  static const String sessionsCount = 'sessions_count';
  static const String daysActive = 'days_active';
  static const String label = 'label';
  static const String itemId = 'item_id';
}

@injectable
class AnalyticsEventTracker {
  const AnalyticsEventTracker(this._analyticsService);

  final AnalyticsService _analyticsService;

  Future<void> trackEvent(
    String name, {
    Map<String, Object>? parameters,
  }) {
    return _analyticsService.logEvent(name, parameters: parameters);
  }

  Future<void> trackScreen(String screenName, {String? screenClass}) {
    return _analyticsService.logScreenView(
      screenName,
      screenClass: screenClass,
    );
  }

  Future<void> trackDashboardView() => trackEvent(AnalyticsEvents.dashboardView);

  Future<void> trackSubjectView(String subjectId, String subjectName) {
    return trackEvent(AnalyticsEvents.subjectView, parameters: {
      AnalyticsParams.subjectId: subjectId,
      AnalyticsParams.subjectName: subjectName,
    });
  }

  Future<void> trackChapterView(String chapterId, String chapterName) {
    return trackEvent(AnalyticsEvents.chapterView, parameters: {
      AnalyticsParams.chapterId: chapterId,
      AnalyticsParams.chapterName: chapterName,
    });
  }

  Future<void> trackFormulaView(String formulaId, String formulaTitle) {
    return trackEvent(AnalyticsEvents.formulaView, parameters: {
      AnalyticsParams.formulaId: formulaId,
      AnalyticsParams.formulaTitle: formulaTitle,
    });
  }

  Future<void> trackPracticeStart({
    required int totalQuestions,
    required String difficulty,
  }) {
    return trackEvent(AnalyticsEvents.practiceStart, parameters: {
      AnalyticsParams.totalQuestions: totalQuestions,
      AnalyticsParams.difficulty: difficulty,
    });
  }

  Future<void> trackPracticeComplete({
    required int totalQuestions,
    required int correctCount,
    required double accuracy,
    required int durationSeconds,
    required String difficulty,
  }) {
    return trackEvent(AnalyticsEvents.practiceComplete, parameters: {
      AnalyticsParams.totalQuestions: totalQuestions,
      AnalyticsParams.correctCount: correctCount,
      AnalyticsParams.accuracy: accuracy,
      AnalyticsParams.duration: durationSeconds,
      AnalyticsParams.difficulty: difficulty,
    });
  }

  Future<void> trackAnalyticsView() =>
      trackEvent(AnalyticsEvents.analyticsView);

  Future<void> trackGrowthMetricsView() =>
      trackEvent(AnalyticsEvents.growthMetricsView);

  Future<void> trackAchievementUnlocked(String tier, String itemId) {
    return trackEvent(AnalyticsEvents.achievementUnlocked, parameters: {
      AnalyticsParams.tier: tier,
      AnalyticsParams.itemId: itemId,
    });
  }

  Future<void> trackSearchQuery(String query, int resultCount) {
    return trackEvent(AnalyticsEvents.searchQuery, parameters: {
      AnalyticsParams.query: query,
      AnalyticsParams.resultCount: resultCount,
    });
  }

  Future<void> trackCurriculumChange(String board, String grade) {
    return trackEvent(AnalyticsEvents.curriculumChange, parameters: {
      AnalyticsParams.board: board,
      AnalyticsParams.grade: grade,
    });
  }

  Future<void> setUserProperties({
    String? board,
    String? grade,
    String? locale,
    String? level,
    int? streak,
    int? formulasCount,
  }) async {
    if (board != null) await _analyticsService.setUserProperty('board', board);
    if (grade != null) await _analyticsService.setUserProperty('grade', grade);
    if (locale != null) await _analyticsService.setUserProperty('locale', locale);
    if (level != null) await _analyticsService.setUserProperty('level', level);
    if (streak != null) await _analyticsService.setUserProperty('streak', streak.toString());
    if (formulasCount != null) {
      await _analyticsService.setUserProperty('formulas', formulasCount.toString());
    }
  }
}
