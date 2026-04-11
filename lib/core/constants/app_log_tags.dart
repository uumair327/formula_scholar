/// Centralized logger tag constants.
///
/// Prevents typos in log tags and provides a quick overview of
/// all logging scopes in the application.
///
/// Tags are organized by hexagonal architecture layer:
/// - **Presentation**: Pages, Cubits, Widgets
/// - **Infrastructure**: Repositories, Adapters (DataSources)
/// - **Core**: Router, Shell, App-level
abstract final class AppLogTags {
  // ──────────────────────── Core / App-level ─────────────────
  static const String main = 'Main';
  static const String router = 'Router';
  static const String bloc = 'Bloc';
  static const String mainShellPage = 'MainShellPage';
  static const String subjectSelection = 'SubjectSelection';
  static const String curriculumCubit = 'CurriculumCubit';
  static const String curriculumRepo = 'CurriculumRepo';
  static const String curriculumDataSource = 'CurriculumDataSource';
  static const String curriculumUseCase = 'CurriculumUseCase';

  // ──────────────────────── Auth ──────────────────────────────
  static const String loginPage = 'LoginPage';
  static const String signupPage = 'SignupPage';
  static const String authCubit = 'AuthCubit';
  static const String authRepo = 'AuthRepo';
  static const String authDataSource = 'AuthDataSource';

  // ──────────────────────── Onboarding ─────────────────────────
  // Presentation
  static const String onboardingPage = 'OnboardingPage';
  static const String onboardingCubit = 'OnboardingCubit';
  static const String onboardingStep1Page = 'OnboardingStep1Page';
  static const String onboardingStep2Page = 'OnboardingStep2Page';
  static const String onboardingStep3Page = 'OnboardingStep3Page';
  static const String onboardingStep4Page = 'OnboardingStep4Page';
  // Data
  static const String onboardingRepo = 'OnboardingRepo';
  static const String onboardingDataSource = 'OnboardingDataSource';

  // ──────────────────────── Dashboard ─────────────────────────
  // Presentation
  static const String dashboardPage = 'DashboardPage';
  static const String dashboardCubit = 'DashboardCubit';
  // Data
  static const String dashboardRepo = 'DashboardRepo';
  static const String dashboardDataSource = 'DashboardDataSource';
  static const String dashboardUseCase = 'DashboardUseCase';

  // ──────────────────────── Chapters (generic) ─────────────────
  // Presentation
  static const String chaptersPage = 'ChaptersPage';
  static const String chaptersCubit = 'ChaptersCubit';
  // Data
  static const String chaptersRepo = 'ChaptersRepo';
  static const String chaptersDataSource = 'ChaptersDataSource';
  static const String chaptersUseCase = 'ChaptersUseCase';
  static const String formulasUseCase = 'FormulasUseCase';

  // ──────────────────────── Formulas ────────────────────────────
  // Presentation
  static const String formulasPage = 'FormulasPage';
  static const String formulasCubit = 'FormulasCubit';
  // Data
  static const String formulasRepo = 'FormulasRepo';
  static const String formulasDataSource = 'FormulasDataSource';

  // ──────────────────────── Profile ───────────────────────────
  // Presentation
  static const String profilePage = 'ProfilePage';
  static const String profileCubit = 'ProfileCubit';
  static const String settingsListWidget = 'SettingsListWidget';
  static const String profileHeroWidget = 'ProfileHeroWidget';
  static const String progressStatsWidget = 'ProgressStatsWidget';
  static const String encouragementCardWidget = 'EncouragementCard';
  // Data
  static const String profileRepo = 'ProfileRepo';
  static const String profileDataSource = 'ProfileDataSource';
  static const String profileUseCase = 'ProfileUseCase';

  // ──────────────────────── Practice ───────────────────────────
  // Presentation
  static const String practicePage = 'PracticePage';
  static const String practiceCubit = 'PracticeCubit';
  // Data
  static const String practiceRepo = 'PracticeRepo';
  static const String practiceDataSource = 'PracticeDataSource';
  static const String practiceUseCase = 'PracticeUseCase';

  // ──────────────────────── Saved ──────────────────────────────
  // Presentation
  static const String savedPage = 'SavedPage';
  static const String savedCubit = 'SavedCubit';
  // Data
  static const String savedRepo = 'SavedRepo';
  static const String savedDataSource = 'SavedDataSource';
  static const String savedUseCase = 'SavedUseCase';
}
