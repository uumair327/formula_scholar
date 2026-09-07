import 'dart:async';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';
import '../../../../../core/constants/app_log_tags.dart';
import '../../../../../core/utils/app_logger.dart';
import '../../../domain/entities/ad_density_level.dart';
import '../../../domain/entities/ad_placement.dart';
import '../../../domain/entities/ad_reward.dart';
import '../../../domain/ports/ad_repository_port.dart';
import '../../../domain/ports/ad_service_port.dart';
import '../../../domain/ports/premium_repository_port.dart';
import '../../../domain/usecases/get_ad_config_use_case.dart';
import '../../../domain/usecases/set_ad_density_use_case.dart';
import '../../../domain/usecases/should_show_ad_use_case.dart';
import '../../../domain/usecases/show_interstitial_ad_use_case.dart';
import '../../../domain/usecases/show_rewarded_ad_use_case.dart';
import 'ad_state.dart';

@lazySingleton
class AdCubit extends Cubit<AdState> {
  AdCubit({
    required GetAdConfigUseCase getAdConfig,
    required SetAdDensityUseCase setAdDensity,
    required ShouldShowAdUseCase shouldShowAd,
    required ShowInterstitialAdUseCase showInterstitialAd,
    required ShowRewardedAdUseCase showRewardedAd,
    required AdRepositoryPort adRepository,
    required PremiumRepositoryPort premiumRepository,
  })  : _getAdConfig = getAdConfig,
        _setAdDensity = setAdDensity,
        _shouldShowAd = shouldShowAd,
        _showInterstitialAd = showInterstitialAd,
        _showRewardedAd = showRewardedAd,
        _adRepository = adRepository,
        _premiumRepository = premiumRepository,
        super(const AdState()) {
    _init();
  }

  final GetAdConfigUseCase _getAdConfig;
  final SetAdDensityUseCase _setAdDensity;
  final ShouldShowAdUseCase _shouldShowAd;
  final ShowInterstitialAdUseCase _showInterstitialAd;
  final ShowRewardedAdUseCase _showRewardedAd;
  final AdRepositoryPort _adRepository;
  final PremiumRepositoryPort _premiumRepository;

  StreamSubscription? _configSub;
  StreamSubscription? _entitlementSub;

  Future<void> _init() async {
    try {
      emit(state.copyWith(status: AdStatus.loading));
      final config = await _getAdConfig();
      final entitlements = await _premiumRepository.getUserEntitlements();
      emit(state.copyWith(
        status: AdStatus.ready,
        config: config,
        isBypassedDueToPremium: entitlements.shouldBypassAllAds,
      ));

      _configSub = _adRepository.onConfigChanged.listen((updatedConfig) {
        emit(state.copyWith(config: updatedConfig));
      });

      _entitlementSub = _premiumRepository.onEntitlementsChanged.listen((entitlements) {
        emit(state.copyWith(
          isBypassedDueToPremium: entitlements.shouldBypassAllAds,
        ));
      });
    } catch (e, st) {
      AppLogger.error('Failed to initialize AdCubit',
          tag: AppLogTags.adCubit, error: e, stackTrace: st);
      emit(state.copyWith(status: AdStatus.error, errorMessage: e.toString()));
    }
  }

  /// Increments action counter (e.g. quiz completed, formula bookmarked).
  Future<void> notifyStudyActionCompleted({AdPlacement? potentialPlacement}) async {
    if (state.isBypassedDueToPremium) return;

    try {
      await _adRepository.incrementActionCount();
      if (potentialPlacement != null) {
        final shouldShow = await _shouldShowAd(potentialPlacement);
        if (shouldShow) {
          await triggerInterstitialAd(potentialPlacement);
        }
      }
    } catch (e) {
      AppLogger.warning('Error in notifyStudyActionCompleted: $e',
          tag: AppLogTags.adCubit);
    }
  }

  /// Evaluates and shows an interstitial or Duolingo ad window.
  Future<AdShowResult> triggerInterstitialAd(AdPlacement placement) async {
    if (state.isBypassedDueToPremium) {
      return const AdShowResult(status: AdShowStatus.bypassed);
    }

    emit(state.copyWith(status: AdStatus.presenting));
    final result = await _showInterstitialAd(placement);
    emit(state.copyWith(status: AdStatus.ready));
    return result;
  }

  /// Shows a rewarded ad for user incentives (e.g. streak recovery, double XP).
  Future<AdShowResult> triggerRewardedAd({
    required AdPlacement placement,
    required AdReward reward,
  }) async {
    emit(state.copyWith(status: AdStatus.presenting));
    final result = await _showRewardedAd(placement, reward);
    emit(state.copyWith(status: AdStatus.ready));
    return result;
  }

  /// Updates ad density setting (none, minimal, standard, maximum).
  Future<void> setDensityLevel(AdDensityLevel level) async {
    try {
      await _setAdDensity(level);
      final updated = await _getAdConfig();
      emit(state.copyWith(config: updated));
    } catch (e, st) {
      AppLogger.error('Failed to update ad density',
          tag: AppLogTags.adCubit, error: e, stackTrace: st);
    }
  }

  @override
  Future<void> close() {
    _configSub?.cancel();
    _entitlementSub?.cancel();
    return super.close();
  }
}
