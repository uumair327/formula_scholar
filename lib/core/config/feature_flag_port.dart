import 'feature_flag.dart';

/// Abstract interface for feature flag resolution.
///
/// Follows Golden Rule #4 (Swappable API Layer): the entire feature flag
/// system can be swapped from local defaults to Firebase Remote Config
/// (or any other provider) by changing a single DI registration.
///
/// Use cases:
/// ```dart
/// class MyUseCase {
///   MyUseCase(this._flags);
///   final FeatureFlagPort _flags;
///
///   Future<Result> call() async {
///     if (_flags.isDisabled(FeatureFlag.rbacEnforcementEnabled)) {
///       return Result.failure('Feature disabled');
///     }
///     // ...
///   }
/// }
/// ```
abstract class FeatureFlagPort {
  /// Returns `true` if [flag] is enabled.
  ///
  /// Resolution order:
  /// 1. Remote config override (if fetched)
  /// 2. Local override (set at runtime)
  /// 3. [FeatureFlag.defaultEnabled]
  bool isEnabled(FeatureFlag flag);

  /// Convenience: negation of [isEnabled].
  bool isDisabled(FeatureFlag flag);

  /// Override a flag at runtime (local scope only).
  ///
  /// Useful for A/B testing, developer menu toggles, or E2E test setup.
  void setOverride(FeatureFlag flag, bool value);

  /// Remove a local override; reverts to default/remote value.
  void clearOverride(FeatureFlag flag);

  /// Remove all local overrides.
  void clearAllOverrides();

  /// Fetches the latest flag values from the remote config provider.
  ///
  /// Returns `true` if remote values were successfully applied.
  Future<bool> refresh();

  /// Stream that emits a flag's key whenever its effective value changes.
  ///
  /// Listeners should re-evaluate whatever depends on that flag.
  Stream<FeatureFlag> get onFlagChanged;

  /// Release resources held by this port.
  void dispose();
}
