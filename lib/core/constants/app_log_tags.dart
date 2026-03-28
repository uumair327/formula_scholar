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

  // ──────────────────────── Dashboard ─────────────────────────
  // Presentation
  static const String dashboardPage = 'DashboardPage';
  static const String dashboardCubit = 'DashboardCubit';
  // Data
  static const String dashboardRepo = 'DashboardRepo';
  static const String dashboardDataSource = 'DashboardDataSource';

  // ──────────────────────── Geometry ──────────────────────────
  // Presentation
  static const String geometryPage = 'GeometryPage';
  static const String geometryCubit = 'GeometryCubit';
  // Data
  static const String geometryRepo = 'GeometryRepo';
  static const String geometryDataSource = 'GeometryDataSource';

  // ──────────────────────── Algebra ───────────────────────────
  // Presentation
  static const String algebraPage = 'AlgebraPage';
  static const String algebraCubit = 'AlgebraCubit';
  // Data
  static const String algebraRepo = 'AlgebraRepo';
  static const String algebraDataSource = 'AlgebraDataSource';

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
}
