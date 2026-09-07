import 'dart:async';
import 'package:flutter_test/flutter_test.dart';
import 'package:formula_scholar/core/config/feature_flag.dart';
import 'package:formula_scholar/core/config/feature_flag_port.dart';
import 'package:formula_scholar/features/monetization/domain/entities/ad_config.dart';
import 'package:formula_scholar/features/monetization/domain/entities/ad_density_level.dart';
import 'package:formula_scholar/features/monetization/domain/entities/ad_placement.dart';
import 'package:formula_scholar/features/monetization/domain/entities/premium_plan.dart';
import 'package:formula_scholar/features/monetization/domain/entities/premium_tier.dart';
import 'package:formula_scholar/features/monetization/domain/entities/user_entitlements.dart';
import 'package:formula_scholar/features/monetization/domain/ports/ad_repository_port.dart';
import 'package:formula_scholar/features/monetization/domain/ports/premium_repository_port.dart';
import 'package:formula_scholar/features/monetization/domain/usecases/should_show_ad_use_case.dart';

class MockAdRepository implements AdRepositoryPort {
  AdConfig config = const AdConfig(
    densityLevel: AdDensityLevel.standard,
    actionCounter: 5,
  );

  @override
  Future<AdConfig> getAdConfig() async => config;

  @override
  Future<int> incrementActionCount() async {
    config = config.copyWith(actionCounter: config.actionCounter + 1);
    return config.actionCounter;
  }

  @override
  Future<void> recordAdImpression(AdPlacement placement) async {}

  @override
  Future<void> resetActionCounter() async {
    config = config.copyWith(actionCounter: 0);
  }

  @override
  Future<void> setAdDensity(AdDensityLevel density) async {
    config = config.copyWith(densityLevel: density);
  }

  @override
  Stream<AdConfig> get onConfigChanged => Stream.value(config);
}

class MockPremiumRepository implements PremiumRepositoryPort {
  UserEntitlements entitlements = UserEntitlements.free;

  @override
  Future<List<PremiumPlan>> getAvailablePlans() async => [];

  @override
  Future<UserEntitlements> getUserEntitlements() async => entitlements;

  @override
  Stream<UserEntitlements> get onEntitlementsChanged => Stream.value(entitlements);

  @override
  Future<UserEntitlements> purchasePlan(PremiumPlan plan) async {
    entitlements = UserEntitlements(tier: plan.tier, isLifetime: true);
    return entitlements;
  }

  @override
  Future<UserEntitlements> restorePurchases() async => entitlements;

  @override
  Future<void> updateEntitlements(UserEntitlements updated) async {
    entitlements = updated;
  }
}

class MockFeatureFlagService implements FeatureFlagPort {
  Map<FeatureFlag, bool> flags = {
    FeatureFlag.adsMasterEnabled: true,
    FeatureFlag.bannerAdsEnabled: true,
    FeatureFlag.interstitialAdsEnabled: true,
    FeatureFlag.rewardedAdsEnabled: true,
  };

  @override
  bool isEnabled(FeatureFlag flag) => flags[flag] ?? false;

  @override
  bool isDisabled(FeatureFlag flag) => !isEnabled(flag);

  @override
  Map<FeatureFlag, bool> getAllFlags() => flags;

  @override
  Future<void> setOverride(FeatureFlag flag, bool value) async {
    flags[flag] = value;
  }

  @override
  Future<void> clearOverride(FeatureFlag flag) async {}

  @override
  Future<void> clearAllOverrides() async {}

  @override
  Stream<Map<FeatureFlag, bool>> watchFlags() => Stream.value(flags);

  @override
  Stream<FeatureFlag> get onFlagChanged => const Stream.empty();

  @override
  Future<bool> refresh() async => true;

  @override
  void dispose() {}
}

void main() {
  late MockAdRepository mockAdRepo;
  late MockPremiumRepository mockPremiumRepo;
  late MockFeatureFlagService mockFlags;
  late ShouldShowAdUseCase useCase;

  setUp(() {
    mockAdRepo = MockAdRepository();
    mockPremiumRepo = MockPremiumRepository();
    mockFlags = MockFeatureFlagService();
    useCase = ShouldShowAdUseCase(
      adRepository: mockAdRepo,
      premiumRepository: mockPremiumRepo,
      featureFlagPort: mockFlags,
    );
  });

  group('ShouldShowAdUseCase - Zero-Ad Policy & Feature Flag Enforcements', () {
    test('Returns FALSE for all ad placements when user is Premium (Zero-Ad guarantee)', () async {
      mockPremiumRepo.entitlements = const UserEntitlements(
        tier: PremiumTier.scholarPlus,
        isLifetime: true,
      );

      final bannerResult = await useCase(AdPlacement.dashboardBanner);
      final interstitialResult = await useCase(AdPlacement.postQuizInterstitial);

      expect(bannerResult, isFalse);
      expect(interstitialResult, isFalse);
    });

    test('Returns FALSE when adsMasterEnabled feature flag is false', () async {
      mockFlags.flags[FeatureFlag.adsMasterEnabled] = false;

      final result = await useCase(AdPlacement.dashboardBanner);
      expect(result, isFalse);
    });

    test('Returns TRUE for banner ad on standard density for free user', () async {
      mockPremiumRepo.entitlements = UserEntitlements.free;
      mockAdRepo.config = const AdConfig(densityLevel: AdDensityLevel.standard);

      final result = await useCase(AdPlacement.dashboardBanner);
      expect(result, isTrue);
    });

    test('Returns FALSE for banner when density is NONE', () async {
      mockAdRepo.config = const AdConfig(densityLevel: AdDensityLevel.none);

      final result = await useCase(AdPlacement.dashboardBanner);
      expect(result, isFalse);
    });
  });
}
