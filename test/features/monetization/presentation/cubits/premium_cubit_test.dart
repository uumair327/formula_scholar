import 'package:flutter_test/flutter_test.dart';
import 'package:formula_scholar/features/monetization/domain/entities/premium_plan.dart';
import 'package:formula_scholar/features/monetization/domain/entities/premium_tier.dart';
import 'package:formula_scholar/features/monetization/domain/entities/user_entitlements.dart';
import 'package:formula_scholar/features/monetization/domain/ports/premium_repository_port.dart';
import 'package:formula_scholar/features/monetization/domain/usecases/get_user_entitlements_use_case.dart';
import 'package:formula_scholar/features/monetization/domain/usecases/restore_purchases_use_case.dart';
import 'package:formula_scholar/features/monetization/domain/usecases/upgrade_to_premium_use_case.dart';
import 'package:formula_scholar/features/monetization/presentation/cubits/premium/premium_cubit.dart';
import 'package:formula_scholar/features/monetization/presentation/cubits/premium/premium_state.dart';

class MockPremiumRepository implements PremiumRepositoryPort {
  UserEntitlements entitlements = UserEntitlements.free;
  final List<PremiumPlan> plans = const [
    PremiumPlan(
      id: 'fs_annual_test',
      tier: PremiumTier.scholarPlus,
      interval: BillingInterval.annual,
      title: 'Annual Super Scholar',
      priceFormatted: '₹1,999/yr',
      pricePerMonthFormatted: '₹166/mo',
      currencyCode: 'INR',
      isBestValue: true,
    ),
  ];

  @override
  Future<List<PremiumPlan>> getAvailablePlans() async => plans;

  @override
  Future<UserEntitlements> getUserEntitlements() async => entitlements;

  @override
  Stream<UserEntitlements> get onEntitlementsChanged => Stream.value(entitlements);

  @override
  Future<UserEntitlements> purchasePlan(PremiumPlan plan) async {
    entitlements = UserEntitlements(
      tier: plan.tier,
      isLifetime: plan.interval == BillingInterval.lifetime,
    );
    return entitlements;
  }

  @override
  Future<UserEntitlements> restorePurchases() async => entitlements;

  @override
  Future<void> updateEntitlements(UserEntitlements updated) async {
    entitlements = updated;
  }
}

void main() {
  late MockPremiumRepository repo;
  late PremiumCubit cubit;

  setUp(() {
    repo = MockPremiumRepository();
    cubit = PremiumCubit(
      getUserEntitlements: GetUserEntitlementsUseCase(repo),
      upgradeToPremium: UpgradeToPremiumUseCase(repo),
      restorePurchases: RestorePurchasesUseCase(repo),
      premiumRepository: repo,
    );
  });

  tearDown(() => cubit.close());

  group('PremiumCubit Store & Entitlements Tests', () {
    test('Initializes with free tier and loads store plans', () async {
      await Future<void>.delayed(const Duration(milliseconds: 50));
      expect(cubit.state.status, equals(PremiumStatus.ready));
      expect(cubit.state.isPremium, isFalse);
      expect(cubit.state.plans.length, equals(1));
      expect(cubit.state.selectedPlan?.id, equals('fs_annual_test'));
    });

    test('Purchasing selected plan upgrades user to Premium (Zero Ads)', () async {
      await Future<void>.delayed(const Duration(milliseconds: 50));
      final success = await cubit.purchaseSelectedPlan();

      expect(success, isTrue);
      expect(cubit.state.isPremium, isTrue);
      expect(cubit.state.tier, equals(PremiumTier.scholarPlus));
    });

    test('Mock premium toggle instantly switches entitlement for dev/QA', () async {
      await cubit.toggleMockPremium(true);
      expect(cubit.state.isPremium, isTrue);

      await cubit.toggleMockPremium(false);
      expect(cubit.state.isPremium, isFalse);
    });
  });
}
