abstract final class AppFirestoreCollections {
  static const String users = 'users';
  static const String subjects = 'subjects';
  static const String chapters = 'chapters';
  static const String formulas = 'formulas';
  static const String bookmarks = 'bookmarks';
  static const String savedChapters = 'saved_chapters';
  static const String progress = 'progress';
  static const String progressSummary = 'progress_summary';
  static const String recentStudies = 'recent_studies';
  static const String formulaNotes = 'formula_notes';
  static const String practiceQuestions = 'practice_questions';
  static const String quizResults = 'quiz_results';
  static const String quizAnswers = 'quiz_answers';
  static const String savedNotes = 'saved_notes';
  static const String stats = 'stats';
  static const String current = 'current';
  static const String streak = 'streak';
  static const String countries = 'countries';
  static const String states = 'states';
  static const String boards = 'boards';
  static const String classes = 'classes';
  static const String grades = 'grades';
  static const String masteryTools = 'mastery_tools';
  static const String appBanners = 'app_banners';
  static const String announcements = 'announcements';
  static const String flashcardReviews = 'flashcard_reviews';
  static const String studyPlans = 'study_plans';
  static const String dashboardCurriculumRegistry =
      'dashboard_curriculum_registry';
  static const String dashboardContentRegistry = 'dashboard_content_registry';
  static const String dashboardContentValues = 'dashboard_content_values';

  static String userDoc(String uid) => 'users/$uid';
  static String userBookmarks(String uid) => '${userDoc(uid)}/bookmarks';
  static String userSavedChapters(String uid) =>
      '${userDoc(uid)}/saved_chapters';
  static String userProgress(String uid) => '${userDoc(uid)}/progress';
  static String userProgressSummary(String uid) =>
      '${userDoc(uid)}/progress_summary';
  static String userRecentStudies(String uid) =>
      '${userDoc(uid)}/recent_studies';
  static String userFormulaNotes(String uid) => '${userDoc(uid)}/formula_notes';
  static String userQuizResults(String uid) => '${userDoc(uid)}/quiz_results';
  static String userQuizAnswers(String uid) => '${userDoc(uid)}/quiz_answers';
  static String userSavedNotes(String uid) => '${userDoc(uid)}/saved_notes';
  static String userStats(String uid) => '${userDoc(uid)}/stats';
  static String userStatsCurrent(String uid) => '${userStats(uid)}/current';
  static String userStatsStreak(String uid) => '${userStats(uid)}/streak';
  static String userFlashcardReviews(String uid) =>
      '${userDoc(uid)}/flashcard_reviews';
  static String userStudyPlans(String uid) => '${userDoc(uid)}/study_plans';

  static String savedChapterSubjects(String uid, String curriculumKey) =>
      '${userSavedChapters(uid)}/$curriculumKey/subjects';
  static String userProgressSubject(String uid, String subjectId) =>
      '${userProgress(uid)}/$subjectId/chapters';
  static String userProgressChapter(
    String uid,
    String subjectId,
    String chapterId,
  ) => '${userProgressSubject(uid, subjectId)}/$chapterId';
  static String userProgressChapterFormulas(
    String uid,
    String subjectId,
    String chapterId,
  ) => '${userProgressChapter(uid, subjectId, chapterId)}/formulas';

  static String subjectChapters(String subjectId) =>
      'subjects/$subjectId/chapters';
  static String chapterFormulas(String subjectId, String chapterId) =>
      '${subjectChapters(subjectId)}/$chapterId/formulas';
  static String subjectMasteryTools(String subjectId) =>
      'subjects/$subjectId/mastery_tools';

  static String countryStates(String countryId) =>
      'countries/$countryId/states';
  static String boardClasses(String boardId) => 'boards/$boardId/classes';
  static String boardGrades(String boardId) => 'boards/$boardId/grades';
}
