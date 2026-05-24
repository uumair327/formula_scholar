library;

/// Centralized, type-safe feature flag keys.
///
/// Every feature flag in the app is defined here. No magic strings.
/// Add new flags here, provide a sensible [defaultEnabled] value,
/// and optionally register a remote config key via [remoteKey].
///
/// Follows Golden Rule #19 (Feature Toggle Ready) and #7 (No Magic Values).
enum FeatureFlag {
  // ──────────────────────── Observability ─────────────────────
  /// Master switch for all [AppLogger] output.
  /// When disabled, only fatal errors are logged regardless of severity.
  loggerEnabled(defaultEnabled: false),

  /// Firebase Analytics event tracking.
  analyticsEnabled(defaultEnabled: true),

  /// Crashlytics / Sentry error reporting.
  crashReportingEnabled(defaultEnabled: true),

  // ──────────────────────── Security ──────────────────────────
  /// Enforces role-based access checks at UseCase level.
  rbacEnforcementEnabled(defaultEnabled: true),

  /// Validates user permissions before every protected action.
  permissionCheckingEnabled(defaultEnabled: true),

  // ──────────────────────── Performance ───────────────────────
  /// Enables local caching via Hive / HydratedBloc.
  cacheEnabled(defaultEnabled: true),

  /// Pre-fetches data (subjects, formulas) on app launch.
  preloadingEnabled(defaultEnabled: true),

  // ──────────────────────── Connectivity ──────────────────────
  /// Allows the app to show cached content when offline.
  offlineModeEnabled(defaultEnabled: true),

  /// Enables automatic retry with exponential backoff on network failures.
  retryEnabled(defaultEnabled: true),

  // ──────────────────────── App Control ───────────────────────
  /// When enabled, shows a maintenance screen to all users.
  maintenanceMode(defaultEnabled: false),

  /// Forces the user to update the app before continuing.
  forceUpdateRequired(defaultEnabled: false),

  // ──────────────────────── Feature Gates ─────────────────────
  /// New 3D visualizer with enhanced rendering.
  newVisualizerEnabled(defaultEnabled: true),

  /// Formula comparison tool.
  comparisonEnabled(defaultEnabled: true),

  /// Achievement system.
  achievementsEnabled(defaultEnabled: true),

  /// Study planner with scheduling.
  studyPlannerEnabled(defaultEnabled: true),

  /// Flashcards study mode.
  flashcardsEnabled(defaultEnabled: true),

  /// AI-powered formula suggestions.
  aiSuggestionsEnabled(defaultEnabled: false);

  // ──────────────────────── Constructor ───────────────────────
  const FeatureFlag({required this.defaultEnabled});

  /// The default value used when no remote config override exists.
  final bool defaultEnabled;

  /// Optional key for Firebase Remote Config or other remote source.
  /// Defaults to the enum name in camelCase.
  String get remoteKey {
    return switch (this) {
      FeatureFlag.loggerEnabled => 'logger_enabled',
      FeatureFlag.analyticsEnabled => 'analytics_enabled',
      FeatureFlag.crashReportingEnabled => 'crash_reporting_enabled',
      FeatureFlag.rbacEnforcementEnabled => 'rbac_enforcement_enabled',
      FeatureFlag.permissionCheckingEnabled => 'permission_checking_enabled',
      FeatureFlag.cacheEnabled => 'cache_enabled',
      FeatureFlag.preloadingEnabled => 'preloading_enabled',
      FeatureFlag.offlineModeEnabled => 'offline_mode_enabled',
      FeatureFlag.retryEnabled => 'retry_enabled',
      FeatureFlag.maintenanceMode => 'maintenance_mode',
      FeatureFlag.forceUpdateRequired => 'force_update_required',
      FeatureFlag.newVisualizerEnabled => 'new_visualizer_enabled',
      FeatureFlag.comparisonEnabled => 'comparison_enabled',
      FeatureFlag.achievementsEnabled => 'achievements_enabled',
      FeatureFlag.studyPlannerEnabled => 'study_planner_enabled',
      FeatureFlag.flashcardsEnabled => 'flashcards_enabled',
      FeatureFlag.aiSuggestionsEnabled => 'ai_suggestions_enabled',
    };
  }
}
