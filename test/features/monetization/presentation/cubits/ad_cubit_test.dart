import 'package:flutter_test/flutter_test.dart';
import 'package:formula_scholar/core/config/feature_flag.dart';
import 'package:formula_scholar/core/config/feature_flag_port.dart';
import 'package:formula_scholar/features/monetization/domain/entities/ad_config.dart';
import 'package:formula_scholar/features/monetization/domain/entities/ad_density_level.dart';
import 'package:formula_scholar/features/monetization/domain/entities/ad_placement.dart';
import 'package:formula_scholar/features/monetization/domain/entities/ad_reward.dart';
import 'package:formula_scholar/features/monetization/domain/entities/premium_plan.dart';
import 'package:formula_scholar/features/monetization/domain/entities/premium_tier.dart';
import 'package:formula_scholar/features/monetization/domain/entities/user_entitlements.dart';
import 'package:formula_scholar/features/monetization/domain/ports/ad_repository_port.dart';
import 'package:formula_scholar/features/monetization/domain/ports/ad_service_port.dart';
import 'package:formula_scholar/features/monetization/domain/ports/premium_repository_port.dart';
import 'package:formula_scholar/features/monetization/domain/usecases/get_ad_config_use_case.dart';
import 'package:formula_scholar/features/monetization/domain/usecases/set_ad_density_use_case.dart';
import 'package:formula_scholar/features/monetization/domain/usecases/should_show_ad_use_case.dart';
import 'package:formula_scholar/features/monetization/domain/usecases/show_interstitial_ad_use_case.dart';
import 'package:formula_scholar/features/monetization/domain/usecases/show_rewarded_ad_use_case.dart';
import 'package:formula_scholar/features/monetization/presentation/cubits/ad/ad_cubit.dart';
import 'package:formula_scholar/features/monetization/presentation/cubits/ad/ad_state.dart';

class MockAdRepository implements AdRepositoryPort {
  AdConfig config = const AdConfig(
    densityLevel: AdDensityLevel.standard,
    actionCounter: 0,
  );

  @override
  Future<AdConfig> getAdConfig() async => config;

  @override
  Future<int> incrementActionCount() async {
    config = config.copyWith(actionCounter: config.actionCounter + 1);
    return config.actionCounter;
  }

  @override
  Future<void> recordAdImpression(AdPlacement placement) async {
    config = config.copyWith(
      totalImpressions: config.totalImpressions + 1,
      lastAdShownAt: DateTime.now(),
      actionCounter: 0,
    );
  }

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
  Future<UserEntitlements> purchasePlan(PremiumPlan plan) async => entitlements;

  @override
  Future<UserEntitlements> restorePurchases() async => entitlements;

  @override
  Future<void> updateEntitlements(UserEntitlements updated) async {
    entitlements = updated;
  }
}

class MockAdService implements AdServicePort {
  bool wasInterstitialShown = false;
  bool wasRewardedShown = false;

  @override
  Future<AdShowResult> showInterstitial(AdPlacement placement) async {
    wasInterstitialShown = true;
    return const AdShowResult(status: AdShowStatus.completed);
  }

  @override
  Future<AdShowResult> showRewarded(AdPlacement placement, AdReward reward) async {
    wasRewardedShown = true;
    return AdShowResult(status: AdShowStatus.completed, reward: reward);
  }
}

class MockFeatureFlagService implements FeatureFlagPort {
  @override
  bool isEnabled(FeatureFlag flag) => true;

  @override
  bool isDisabled(FeatureFlag flag) => false;

  @override
  Map<FeatureFlag, bool> getAllFlags() => {};

  @override
  Future<void> setOverride(FeatureFlag flag, bool value) async {}

  @override
  Future<void> clearOverride(FeatureFlag flag) async {}

  @override
  Future<void> clearAllOverrides() async {}

  @override
  Stream<Map<FeatureFlag, bool>> watchFlags() => const Stream.empty();

  @override
  Stream<FeatureFlag> get onFlagChanged => const Stream.empty();

  @override
  Future<bool> refresh() async => true;

  @override
  void dispose() {}
}

void main() {
  late MockAdRepository adRepo;
  late MockPremiumRepository premiumRepo;
  late MockAdService adService;
  late MockFeatureFlagService flagService;
  late AdCubit cubit;

  setUp(() {
    adRepo = MockAdRepository();
    premiumRepo = MockPremiumRepository();
    adService = MockAdService();
    flagService = MockFeatureFlagService();

    final shouldShow = ShouldShowAdUseCase(
      adRepository: adRepo,
      premiumRepository: premiumRepo,
      featureFlagPort: flagService,
    );

    cubit = AdCubit(
      getAdConfig: GetAdConfigUseCase(adRepo),
      setAdDensity: SetAdDensityUseCase(adRepo),
      shouldShowAd: shouldShow,
      showInterstitialAd: ShowInterstitialAdUseCase(
        shouldShowAd: shouldShow,
        adService: adService,
        adRepository: adRepo,
      ),
      showRewardedAd: ShowRewardedAdUseCase(
        shouldShowAd: shouldShow,
        adService: adService,
        adRepository: adRepo,
      ),
      adRepository: adRepo,
      premiumRepository: premiumRepo,
    );
  });

  tearDown(() => cubit.close());

  group('AdCubit State & Action Counter Tests', () {
    test('Initializes with default configuration', () async {
      await Future<void>.delayed(const Duration(milliseconds: 50));
      expect(cubit.state.status, equals(AdStatus.ready));
      expect(cubit.state.densityLevel, equals(AdDensityLevel.standard));
      expect(cubit.state.isBypassedDueToPremium, isFalse);
    });

    test('Updating density level emits new state', () async {
      await cubit.setDensityLevel(AdDensityLevel.minimal);
      expect(cubit.state.densityLevel, equals(AdDensityLevel.minimal));
    });

    test('Study actions increment counter and trigger ad when threshold is reached', () async {
      await cubit.setDensityLevel(AdDensityLevel.maximum); // interval count is 1
      await cubit.notifyStudyActionCompleted(
        potentialPlacement: AdPlacement.postQuizInterstitial,
      );
      expect(adService.wasInterstitialShown, isTrue);
    });
  });
}
