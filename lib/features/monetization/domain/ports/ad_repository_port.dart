import '../entities/ad_config.dart';
import '../entities/ad_density_level.dart';
import '../entities/ad_placement.dart';

/// Contract for ad settings and metrics persistence.
///
/// Follows Clean Architecture (Domain port).
abstract interface class AdRepositoryPort {
  /// Loads persisted ad configuration.
  Future<AdConfig> getAdConfig();

  /// Updates ad density level.
  Future<void> setAdDensity(AdDensityLevel density);

  /// Increments action counter and checks if threshold is reached.
  Future<int> incrementActionCount();

  /// Records that a fullscreen ad was successfully presented.
  Future<void> recordAdImpression(AdPlacement placement);

  /// Resets action counter.
  Future<void> resetActionCounter();

  /// Stream of ad config changes.
  Stream<AdConfig> get onConfigChanged;
}
