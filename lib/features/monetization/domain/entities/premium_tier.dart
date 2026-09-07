/// Subscription & entitlement tiers in Formula Scholar.
enum PremiumTier {
  /// Standard free user with minimal/standard ad sponsorship.
  free,

  /// Scholar Plus: 0 Ads + Unlimited Quiz Attempts + Streak Freeze Protection.
  scholarPlus,

  /// Scholar Max: Everything in Plus + Unlimited AI Derivation Tutor + Offline 3D Models.
  scholarMax;

  /// Whether this tier grants zero-ad status.
  bool get isAdFree => this != PremiumTier.free;

  /// Display title for the tier.
  String get displayName => switch (this) {
    PremiumTier.free => 'Free Scholar',
    PremiumTier.scholarPlus => 'Super Scholar',
    PremiumTier.scholarMax => 'Scholar Max',
  };
}
