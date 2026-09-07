import 'package:equatable/equatable.dart';
import '../../../domain/entities/premium_plan.dart';
import '../../../domain/entities/premium_tier.dart';
import '../../../domain/entities/user_entitlements.dart';

enum PremiumStatus { initial, loading, ready, purchasing, restoring, success, error }

class PremiumState extends Equatable {
  const PremiumState({
    this.status = PremiumStatus.initial,
    this.entitlements = UserEntitlements.free,
    this.plans = const [],
    this.selectedPlan,
    this.errorMessage,
  });

  final PremiumStatus status;
  final UserEntitlements entitlements;
  final List<PremiumPlan> plans;
  final PremiumPlan? selectedPlan;
  final String? errorMessage;

  bool get isPremium => entitlements.isPremium;
  PremiumTier get tier => entitlements.tier;
  bool get isTrialActive => entitlements.isTrialActive;

  PremiumState copyWith({
    PremiumStatus? status,
    UserEntitlements? entitlements,
    List<PremiumPlan>? plans,
    PremiumPlan? selectedPlan,
    String? errorMessage,
  }) {
    return PremiumState(
      status: status ?? this.status,
      entitlements: entitlements ?? this.entitlements,
      plans: plans ?? this.plans,
      selectedPlan: selectedPlan ?? this.selectedPlan,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }

  @override
  List<Object?> get props => [
    status,
    entitlements,
    plans,
    selectedPlan,
    errorMessage,
  ];
}
