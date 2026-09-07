import '../entities/ad_placement.dart';
import '../entities/ad_reward.dart';

/// Result status from showing an ad.
enum AdShowStatus {
  /// Ad was completed and dismissed normally.
  completed,

  /// User skipped ad after mandatory timer.
  skipped,

  /// Ad was bypassed because user is premium or density is none.
  bypassed,

  /// User clicked "Go Super / Upgrade" inside the ad window.
  upgradeRequested,

  /// Ad failed to load or show.
  failed,
}

/// Result returned from presenting an ad.
class AdShowResult {
  const AdShowResult({
    required this.status,
    this.reward,
    this.errorMessage,
  });

  final AdShowStatus status;
  final AdReward? reward;
  final String? errorMessage;

  bool get isSuccess =>
      status == AdShowStatus.completed ||
      status == AdShowStatus.skipped ||
      status == AdShowStatus.bypassed;

  bool get hasReward => reward != null;
}

/// Abstract contract for presenting ads.
abstract interface class AdServicePort {
  /// Shows an interstitial ad for the specified placement.
  Future<AdShowResult> showInterstitial(AdPlacement placement);

  /// Shows a rewarded ad for the specified placement with expected reward.
  Future<AdShowResult> showRewarded(AdPlacement placement, AdReward reward);
}
