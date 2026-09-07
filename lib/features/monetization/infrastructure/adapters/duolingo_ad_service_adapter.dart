import 'dart:async';
import 'package:flutter/material.dart';
import 'package:injectable/injectable.dart';
import '../../../../core/constants/app_log_tags.dart';
import '../../../../core/router/app_router.dart';
import '../../../../core/utils/app_logger.dart';
import '../../domain/entities/ad_placement.dart';
import '../../domain/entities/ad_reward.dart';
import '../../domain/ports/ad_service_port.dart';
import '../../presentation/widgets/duolingo_ad_dialog.dart';
import '../../presentation/widgets/duolingo_rewarded_ad_modal.dart';

@LazySingleton(as: AdServicePort)
class DuolingoAdServiceAdapter implements AdServicePort {
  BuildContext? _getNavigationContext() {
    return AppRouter.router.routerDelegate.navigatorKey.currentContext;
  }

  @override
  Future<AdShowResult> showInterstitial(AdPlacement placement) async {
    final context = _getNavigationContext();
    if (context == null) {
      AppLogger.warning('No active BuildContext to present interstitial ad',
          tag: AppLogTags.duolingoAd);
      return const AdShowResult(status: AdShowStatus.completed);
    }

    try {
      AppLogger.info('Presenting Duolingo-style ad window for placement: $placement',
          tag: AppLogTags.duolingoAd);

      final result = await showGeneralDialog<AdShowResult>(
        context: context,
        barrierDismissible: false,
        barrierColor: Colors.black87,
        transitionDuration: const Duration(milliseconds: 300),
        pageBuilder: (ctx, anim1, anim2) {
          return DuolingoAdDialog(placement: placement);
        },
        transitionBuilder: (ctx, anim1, anim2, child) {
          final curved = CurvedAnimation(parent: anim1, curve: Curves.easeOutBack);
          return ScaleTransition(
            scale: curved,
            child: FadeTransition(opacity: anim1, child: child),
          );
        },
      );

      return result ?? const AdShowResult(status: AdShowStatus.completed);
    } catch (e, st) {
      AppLogger.error('Failed to show Duolingo ad window',
          tag: AppLogTags.duolingoAd, error: e, stackTrace: st);
      return AdShowResult(status: AdShowStatus.failed, errorMessage: e.toString());
    }
  }

  @override
  Future<AdShowResult> showRewarded(AdPlacement placement, AdReward reward) async {
    final context = _getNavigationContext();
    if (context == null) {
      AppLogger.warning('No active BuildContext to present rewarded ad',
          tag: AppLogTags.duolingoAd);
      return AdShowResult(status: AdShowStatus.completed, reward: reward);
    }

    try {
      AppLogger.info('Presenting Duolingo rewarded ad window for: ${reward.type}',
          tag: AppLogTags.duolingoAd);

      final result = await showGeneralDialog<AdShowResult>(
        context: context,
        barrierDismissible: false,
        barrierColor: Colors.black87,
        transitionDuration: const Duration(milliseconds: 300),
        pageBuilder: (ctx, anim1, anim2) {
          return DuolingoRewardedAdModal(placement: placement, reward: reward);
        },
        transitionBuilder: (ctx, anim1, anim2, child) {
          return SlideTransition(
            position: Tween<Offset>(begin: const Offset(0, 0.2), end: Offset.zero)
                .animate(CurvedAnimation(parent: anim1, curve: Curves.easeOutCubic)),
            child: FadeTransition(opacity: anim1, child: child),
          );
        },
      );

      return result ?? AdShowResult(status: AdShowStatus.completed, reward: reward);
    } catch (e, st) {
      AppLogger.error('Failed to show rewarded ad window',
          tag: AppLogTags.duolingoAd, error: e, stackTrace: st);
      return AdShowResult(status: AdShowStatus.failed, errorMessage: e.toString());
    }
  }
}
