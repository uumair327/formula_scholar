import 'package:injectable/injectable.dart';
import '../entities/ad_placement.dart';
import '../entities/ad_reward.dart';
import '../ports/ad_repository_port.dart';
import '../ports/ad_service_port.dart';
import 'should_show_ad_use_case.dart';

@injectable
class ShowRewardedAdUseCase {
  const ShowRewardedAdUseCase({
    required ShouldShowAdUseCase shouldShowAd,
    required AdServicePort adService,
    required AdRepositoryPort adRepository,
  })  : _shouldShowAd = shouldShowAd,
        _adService = adService,
        _adRepository = adRepository;

  final ShouldShowAdUseCase _shouldShowAd;
  final AdServicePort _adService;
  final AdRepositoryPort _adRepository;

  Future<AdShowResult> call(AdPlacement placement, AdReward reward) async {
    final canShow = await _shouldShowAd(placement);
    if (!canShow) {
      // For premium users or bypassed cases, reward is granted directly!
      return AdShowResult(
        status: AdShowStatus.bypassed,
        reward: reward,
      );
    }

    final result = await _adService.showRewarded(placement, reward);
    if (result.status == AdShowStatus.completed) {
      await _adRepository.recordAdImpression(placement);
    }
    return result;
  }
}
