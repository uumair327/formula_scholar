import 'package:equatable/equatable.dart';
import 'premium_tier.dart';

/// Billing intervals for subscription plans.
enum BillingInterval { monthly, annual, lifetime }

/// Represents a subscription or purchase plan.
class PremiumPlan extends Equatable {
  const PremiumPlan({
    required this.id,
    required this.tier,
    required this.interval,
    required this.title,
    required this.priceFormatted,
    required this.pricePerMonthFormatted,
    required this.currencyCode,
    this.badgeText,
    this.hasTrial = false,
    this.trialPeriodDays = 7,
    this.isBestValue = false,
    this.features = const [],
  });

  final String id;
  final PremiumTier tier;
  final BillingInterval interval;
  final String title;
  final String priceFormatted;
  final String pricePerMonthFormatted;
  final String currencyCode;
  final String? badgeText;
  final bool hasTrial;
  final int trialPeriodDays;
  final bool isBestValue;
  final List<String> features;

  @override
  List<Object?> get props => [
    id,
    tier,
    interval,
    title,
    priceFormatted,
    pricePerMonthFormatted,
    currencyCode,
    badgeText,
    hasTrial,
    trialPeriodDays,
    isBestValue,
    features,
  ];
}
