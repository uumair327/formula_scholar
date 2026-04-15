/// Centralized feature flags for runtime and release toggles.
abstract final class AppFeatureFlags {
  /// If true, all chapter cards are accessible even when backend marks locked.
  static const bool unlockAllChapters = true;
}
