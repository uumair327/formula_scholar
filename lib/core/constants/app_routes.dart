/// Centralized route path and route name constants.
///
/// Prevents typos and enforces consistency when navigating
/// with [go_router]. All route paths and names are defined once here.
///
/// **Naming Convention:**
/// - **Paths**: URL segments prefixed with `/` (e.g. `/chapters`).
/// - **Names**: Lowercase identifiers for [GoRouter.goNamed] (e.g. `chapters`).
///
/// **Usage:**
/// ```dart
/// // Navigate by name (preferred – decoupled from URL structure):
/// context.goNamed(AppRoutes.chaptersName);
///
/// // Navigate by path (when URL is needed directly):
/// context.go(AppRoutes.chaptersPath);
/// ```
abstract final class AppRoutes {
  // ──────────────────────── Auth ──────────────────────────────
  /// Login screen — entry point before onboarding.
  static const String loginPath = '/login';
  static const String loginName = 'login';

  /// Sign-up screen.
  static const String signupPath = '/signup';
  static const String signupName = 'signup';

  // ──────────────────────── Onboarding ────────────────────────
  /// Onboarding – step 1: Location/Country preference.
  static const String onboardingPath = '/onboarding';
  static const String onboardingName = 'onboarding';

  /// Onboarding – step 2: Curriculum/Board selection.
  static const String onboardingStep2Path = '/onboarding/2';
  static const String onboardingStep2Name = 'onboarding-step2';

  /// Onboarding – step 3: Subject focus areas.
  static const String onboardingStep3Path = '/onboarding/3';
  static const String onboardingStep3Name = 'onboarding-step3';

  /// Onboarding – step 4: Weekly study goal.
  static const String onboardingStep4Path = '/onboarding/4';
  static const String onboardingStep4Name = 'onboarding-step4';

  // ──────────────────────── Shell Tab Paths ───────────────────
  /// Dashboard (Home) – the initial landing screen.
  static const String dashboardPath = '/';

  /// Chapters screen – shows chapters for the selected subject.
  static const String chaptersPath = '/chapters';

  /// Practice quiz screen.
  static const String practicePath = '/practice';

  /// Saved bookmarks screen.
  static const String savedPath = '/saved';

  /// User profile / settings screen.
  static const String profilePath = '/profile';

  // ──────────────────────── Shell Tab Names ───────────────────
  /// Dashboard route name for [GoRouter.goNamed].
  static const String dashboardName = 'dashboard';

  /// Chapters route name for [GoRouter.goNamed].
  static const String chaptersName = 'chapters';

  /// Practice route name for [GoRouter.goNamed].
  static const String practiceName = 'practice';

  /// Saved route name for [GoRouter.goNamed].
  static const String savedName = 'saved';

  /// Profile route name for [GoRouter.goNamed].
  static const String profileName = 'profile';

  // ──────────────────────── Sub-Route Paths ──────────────────
  // Define sub-routes as relative paths (without leading `/`)
  // so they nest correctly under their parent branch.
  //
  // Example:
  // static const String topicDetailPath = 'topic/:topicId';
  // static const String topicDetailName = 'topicDetail';

  /// Formula detail page — shows formulas for a chapter.
  /// Used as a sub-route inside the Chapters shell branch.
  static const String formulaDetailPath = 'formulas/:subjectId/:chapterId';
  static const String formulaDetailName = 'formulaDetail';
}
