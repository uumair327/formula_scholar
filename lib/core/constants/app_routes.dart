/// Centralized route path and route name constants.
///
/// Prevents typos and enforces consistency when navigating
/// with [go_router]. All route paths and names are defined once here.
///
/// **Naming Convention:**
/// - **Paths**: URL segments prefixed with `/` (e.g. `/geometry`).
/// - **Names**: Lowercase identifiers for [GoRouter.goNamed] (e.g. `geometry`).
///
/// **Usage:**
/// ```dart
/// // Navigate by name (preferred – decoupled from URL structure):
/// context.goNamed(AppRoutes.geometryName);
///
/// // Navigate by path (when URL is needed directly):
/// context.go(AppRoutes.geometryPath);
/// ```
abstract final class AppRoutes {
  // ──────────────────────── Shell Tab Paths ───────────────────
  /// Dashboard (Home) – the initial landing screen.
  static const String dashboardPath = '/';

  /// Geometry chapters screen.
  static const String geometryPath = '/geometry';

  /// Algebra cheat sheet screen.
  static const String algebraPath = '/algebra';

  /// User profile / settings screen.
  static const String profilePath = '/profile';

  // ──────────────────────── Shell Tab Names ───────────────────
  /// Dashboard route name for [GoRouter.goNamed].
  static const String dashboardName = 'dashboard';

  /// Geometry route name for [GoRouter.goNamed].
  static const String geometryName = 'geometry';

  /// Algebra route name for [GoRouter.goNamed].
  static const String algebraName = 'algebra';

  /// Profile route name for [GoRouter.goNamed].
  static const String profileName = 'profile';

  // ──────────────────────── Sub-Route Paths ──────────────────
  // Define sub-routes as relative paths (without leading `/`)
  // so they nest correctly under their parent branch.
  //
  // Example:
  // static const String topicDetailPath = 'topic/:topicId';
  // static const String topicDetailName = 'topicDetail';
  //
  // static const String formulaDetailPath = 'formula/:formulaId';
  // static const String formulaDetailName = 'formulaDetail';
}
