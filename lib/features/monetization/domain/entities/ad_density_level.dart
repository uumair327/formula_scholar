/// Represents ad frequency & density levels in Formula Scholar.
///
/// Follows Golden Rule #7 (No Magic Values) & Clean Architecture.
enum AdDensityLevel {
  /// No ads shown at all (used for tests or ad-free promotions).
  none(
    actionIntervalCount: 999999,
    cooldownSeconds: 999999,
    bannerAllowed: false,
    interstitialAllowed: false,
    rewardedAllowed: true,
  ),

  /// Minimal density: Least intrusive mode for high-focus studying.
  /// - Interstitials trigger only after every 6 completed study actions.
  /// - 5-minute cooldown between fullscreen ad encounters.
  /// - Banners shown only on secondary screens.
  minimal(
    actionIntervalCount: 6,
    cooldownSeconds: 300,
    bannerAllowed: false,
    interstitialAllowed: true,
    rewardedAllowed: true,
  ),

  /// Standard density: Balanced Duolingo-style cadence.
  /// - Interstitials trigger after every 3 completed study actions / quizzes.
  /// - 2-minute cooldown between fullscreen ad encounters.
  /// - Banners allowed on dashboard & formula collections.
  standard(
    actionIntervalCount: 3,
    cooldownSeconds: 120,
    bannerAllowed: true,
    interstitialAllowed: true,
    rewardedAllowed: true,
  ),

  /// Maximum density: High monetization mode.
  /// - Interstitials trigger after every 1-2 completed study actions.
  /// - 30-second cooldown between fullscreen ad encounters.
  /// - Banners allowed on all non-reader screens.
  maximum(
    actionIntervalCount: 1,
    cooldownSeconds: 30,
    bannerAllowed: true,
    interstitialAllowed: true,
    rewardedAllowed: true,
  );

  const AdDensityLevel({
    required this.actionIntervalCount,
    required this.cooldownSeconds,
    required this.bannerAllowed,
    required this.interstitialAllowed,
    required this.rewardedAllowed,
  });

  /// The number of completed study actions before eligible for an ad.
  final int actionIntervalCount;

  /// Minimum seconds required between consecutive fullscreen ads.
  final int cooldownSeconds;

  /// Whether banner ads are permitted under this density.
  final bool bannerAllowed;

  /// Whether interstitial ads are permitted under this density.
  final bool interstitialAllowed;

  /// Whether rewarded ads (user opt-in) are permitted under this density.
  final bool rewardedAllowed;

  /// User-friendly display title.
  String get displayName {
    return switch (this) {
      AdDensityLevel.none => 'None (Ad-Free)',
      AdDensityLevel.minimal => 'Minimal (Focus Mode)',
      AdDensityLevel.standard => 'Standard (Balanced)',
      AdDensityLevel.maximum => 'Maximum (Ad Supported)',
    };
  }
}
