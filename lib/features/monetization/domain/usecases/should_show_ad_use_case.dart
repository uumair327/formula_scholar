import 'package:injectable/injectable.dart';
import '../../../../core/config/feature_flag.dart';
import '../../../../core/config/feature_flag_port.dart';
import '../entities/ad_density_level.dart';
import '../entities/ad_placement.dart';
import '../ports/ad_repository_port.dart';
import '../ports/premium_repository_port.dart';

/// Evaluates whether an ad should be presented for a given placement.
///
/// Enforces:
/// 1. Premium User Bypass (Zero ads for premium subscribers).
/// 2. Feature Flags (`adsMasterEnabled`, `bannerAdsEnabled`, `interstitialAdsEnabled`).
/// 3. Ad Density Level (`none`, `minimal`, `standard`, `maximum`).
/// 4. Cooldown time windows and action counters.
@injectable
class ShouldShowAdUseCase {
  const ShouldShowAdUseCase({
    required AdRepositoryPort adRepository,
    required PremiumRepositoryPort premiumRepository,
    required FeatureFlagPort featureFlagPort,
  })  : _adRepository = adRepository,
        _premiumRepository = premiumRepository,
        _featureFlagPort = featureFlagPort;

  final AdRepositoryPort _adRepository;
  final PremiumRepositoryPort _premiumRepository;
  final FeatureFlagPort _featureFlagPort;

  Future<bool> call(AdPlacement placement) async {
    // 1. Premium Check: Premium users NEVER see ads.
    final entitlements = await _premiumRepository.getUserEntitlements();
    if (entitlements.shouldBypassAllAds) {
      return false;
    }

    // 2. Feature Flag Master Switch
    if (_featureFlagPort.isDisabled(FeatureFlag.adsMasterEnabled)) {
      return false;
    }

    // 3. Format Specific Feature Flags
    if (placement.isBanner &&
        _featureFlagPort.isDisabled(FeatureFlag.bannerAdsEnabled)) {
      return false;
    }
    if (placement.isInterstitial &&
        _featureFlagPort.isDisabled(FeatureFlag.interstitialAdsEnabled)) {
      return false;
    }
    if (placement.isRewarded &&
        _featureFlagPort.isDisabled(FeatureFlag.rewardedAdsEnabled)) {
      return false;
    }

    // 4. Ad Density & Cooldown Evaluation
    final config = await _adRepository.getAdConfig();
    if (config.densityLevel == AdDensityLevel.none) {
      return placement.isRewarded; // Rewarded ads are user-initiated
    }

    if (placement.isBanner) {
      return config.densityLevel.bannerAllowed;
    }

    if (placement.isInterstitial) {
      if (!config.densityLevel.interstitialAllowed) return false;
      if (config.isCooldownActive) return false;
      return config.hasReachedActionThreshold;
    }

    // Rewarded ads are always allowed if enabled
    return true;
  }
}
