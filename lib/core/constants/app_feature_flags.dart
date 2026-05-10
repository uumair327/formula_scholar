/// Centralized feature flags for runtime and release toggles.
abstract final class AppFeatureFlags {
  /// If true, all chapter cards are accessible even when backend marks locked.
  /// Toggle to false for production release to respect backend lock status.
  static const bool unlockAllChapters = false;

  /// Minimum required app build version for client-side enforcement.
  static const int minSupportedBuild = 1;

  /// Current release channel.
  static const String releaseChannel = 'stable';
}
