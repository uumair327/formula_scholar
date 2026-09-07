import 'package:equatable/equatable.dart';

/// Reward types delivered when a user finishes a rewarded ad.
enum AdRewardType {
  /// Daily streak freeze or recovery.
  streakFreeze,

  /// Double XP bonus points.
  doubleXp,

  /// Unlock deep AI derivation & formula proofs.
  aiDerivation,

  /// Bonus quiz attempts or formula hints.
  formulaHint,
}

/// Represents a rewarded ad completion payload.
class AdReward extends Equatable {
  const AdReward({
    required this.type,
    required this.amount,
    required this.rewardId,
    this.label,
  });

  final AdRewardType type;
  final int amount;
  final String rewardId;
  final String? label;

  @override
  List<Object?> get props => [type, amount, rewardId, label];
}
