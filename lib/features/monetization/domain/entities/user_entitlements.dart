import 'package:equatable/equatable.dart';
import 'premium_tier.dart';

/// Represents user monetization entitlements and active subscription status.
class UserEntitlements extends Equatable {
  const UserEntitlements({
    this.tier = PremiumTier.free,
    this.expiresAt,
    this.isLifetime = false,
    this.isTrialActive = false,
    this.unlockedPerks = const [],
  });

  /// The active premium tier.
  final PremiumTier tier;

  /// Expiry timestamp for subscription or trial.
  final DateTime? expiresAt;

  /// Whether the user purchased a lifetime license.
  final bool isLifetime;

  /// Whether the user is currently in a free trial period.
  final bool isTrialActive;

  /// Specific feature IDs unlocked.
  final List<String> unlockedPerks;

  /// Whether the user is considered premium (no ads).
  bool get isPremium {
    if (tier == PremiumTier.free) return false;
    if (isLifetime) return true;
    if (expiresAt == null) return true;
    return expiresAt!.isAfter(DateTime.now());
  }

  /// Whether all ads should be bypassed.
  bool get shouldBypassAllAds => isPremium;

  UserEntitlements copyWith({
    PremiumTier? tier,
    DateTime? expiresAt,
    bool? isLifetime,
    bool? isTrialActive,
    List<String>? unlockedPerks,
  }) {
    return UserEntitlements(
      tier: tier ?? this.tier,
      expiresAt: expiresAt ?? this.expiresAt,
      isLifetime: isLifetime ?? this.isLifetime,
      isTrialActive: isTrialActive ?? this.isTrialActive,
      unlockedPerks: unlockedPerks ?? this.unlockedPerks,
    );
  }

  /// Sentinel for free default entitlements.
  static const UserEntitlements free = UserEntitlements();

  @override
  List<Object?> get props => [
    tier,
    expiresAt,
    isLifetime,
    isTrialActive,
    unlockedPerks,
  ];
}
