import 'package:injectable/injectable.dart';
import '../../domain/entities/premium_plan.dart';
import '../../domain/entities/premium_tier.dart';

abstract interface class PremiumServiceAdapter {
  Future<List<PremiumPlan>> fetchStorePlans();
  Future<bool> executePurchase(PremiumPlan plan);
}

@LazySingleton(as: PremiumServiceAdapter)
class PremiumServiceAdapterImpl implements PremiumServiceAdapter {
  @override
  Future<List<PremiumPlan>> fetchStorePlans() async {
    // Simulated catalog of competitive Duolingo-style plans
    return const [
      PremiumPlan(
        id: 'fs_scholar_super_annual',
        tier: PremiumTier.scholarPlus,
        interval: BillingInterval.annual,
        title: 'Annual Super Scholar',
        priceFormatted: '₹1,999/yr',
        pricePerMonthFormatted: '₹166/mo',
        currencyCode: 'INR',
        badgeText: 'SAVE 60%',
        hasTrial: true,
        trialPeriodDays: 7,
        isBestValue: true,
        features: [
          '🚫 100% Zero Advertisements & Zero Distractions',
          '⚡ Unlimited Quiz Hearts & Practice Attempts',
          '🧊 Daily Streak Protection & Auto Freeze',
          '🧠 Step-by-Step AI Derivation Proofs',
          '📦 Offline 3D Models & Formula Downloads',
        ],
      ),
      PremiumPlan(
        id: 'fs_scholar_super_monthly',
        tier: PremiumTier.scholarPlus,
        interval: BillingInterval.monthly,
        title: 'Monthly Super Scholar',
        priceFormatted: '₹399/mo',
        pricePerMonthFormatted: '₹399/mo',
        currencyCode: 'INR',
        hasTrial: false,
        isBestValue: false,
        features: [
          '🚫 100% Zero Advertisements',
          '⚡ Unlimited Quiz Attempts',
          '🧊 Streak Freeze Recovery',
          '🧠 Sigma AI Formula Tutor',
        ],
      ),
      PremiumPlan(
        id: 'fs_scholar_max_lifetime',
        tier: PremiumTier.scholarMax,
        interval: BillingInterval.lifetime,
        title: 'Lifetime Scholar VIP',
        priceFormatted: '₹4,999',
        pricePerMonthFormatted: 'One-Time',
        currencyCode: 'INR',
        badgeText: 'LIFETIME ACCESS',
        hasTrial: false,
        isBestValue: false,
        features: [
          '👑 Everything in Super Scholar Forever',
          '🚀 Priority Access to New 3D Formula Visualizers',
          '🎓 Multi-board Syllabus Access (CBSE, ICSE, JEE, NEET)',
          '✨ VIP Discord / Community Badge',
        ],
      ),
    ];
  }

  @override
  Future<bool> executePurchase(PremiumPlan plan) async {
    // Simulate real in-app billing latency
    await Future<void>.delayed(const Duration(milliseconds: 600));
    return true;
  }
}
