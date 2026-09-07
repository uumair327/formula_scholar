import 'package:injectable/injectable.dart';
import '../entities/ad_placement.dart';
import '../ports/ad_repository_port.dart';
import '../ports/ad_service_port.dart';
import 'should_show_ad_use_case.dart';

@injectable
class ShowInterstitialAdUseCase {
  const ShowInterstitialAdUseCase({
    required ShouldShowAdUseCase shouldShowAd,
    required AdServicePort adService,
    required AdRepositoryPort adRepository,
  })  : _shouldShowAd = shouldShowAd,
        _adService = adService,
        _adRepository = adRepository;

  final ShouldShowAdUseCase _shouldShowAd;
  final AdServicePort _adService;
  final AdRepositoryPort _adRepository;

  Future<AdShowResult> call(AdPlacement placement) async {
    final canShow = await _shouldShowAd(placement);
    if (!canShow) {
      return const AdShowResult(status: AdShowStatus.bypassed);
    }

    final result = await _adService.showInterstitial(placement);
    if (result.status == AdShowStatus.completed ||
        result.status == AdShowStatus.skipped) {
      await _adRepository.recordAdImpression(placement);
      await _adRepository.resetActionCounter();
    }
    return result;
  }
}
