import 'package:flutter/material.dart';
import 'package:lucide_icons/lucide_icons.dart';

import '../../../../core/core.dart';

class QuizSuccessToast extends StatelessWidget {
  const QuizSuccessToast({super.key});

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    return Positioned(
      bottom: AppDimensions.bottomNavPadding + AppDimensions.paddingXL,
      left: AppDimensions.paddingXXL,
      right: AppDimensions.paddingXXL,
      child: Center(
        child: Container(
          padding: const EdgeInsets.symmetric(
            horizontal: AppDimensions.paddingHero,
            vertical: AppDimensions.paddingLG,
          ),
          decoration: BoxDecoration(
            color: colorScheme.secondary,
            borderRadius: BorderRadius.circular(AppDimensions.radiusXXL),
            boxShadow: const [AppShadows.medium],
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                padding: const EdgeInsets.all(AppDimensions.paddingXS),
                decoration: BoxDecoration(
                  color: colorScheme.onSecondary.withValues(
                    alpha: AppDimensions.opacitySubtle,
                  ),
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  LucideIcons.partyPopper,
                  size: AppDimensions.iconMD,
                  color: colorScheme.onSecondary,
                ),
              ),
              const SizedBox(width: AppDimensions.paddingLG),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    '${context.l10n.correct} ${context.l10n.plusPointsTemplate}',
                    style: AppTextStyles.labelLarge.copyWith(
                      color: colorScheme.onSecondary,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  Text(
                    context.l10n.masteryLevelIncreasing,
                    style: AppTextStyles.labelSmall.copyWith(
                      color: colorScheme.onSecondary.withValues(
                        alpha: AppDimensions.opacityHigh,
                      ),
                      fontWeight: FontWeight.w700,
                      letterSpacing: AppDimensions.letterSpacingWide,
                      fontSize: AppDimensions.fontSizeXS,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class QuizWrongAnswerToast extends StatelessWidget {
  const QuizWrongAnswerToast({super.key});

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    return Positioned(
      bottom: AppDimensions.bottomNavPadding + AppDimensions.paddingXL,
      left: AppDimensions.paddingXXL,
      right: AppDimensions.paddingXXL,
      child: Center(
        child: Container(
          padding: const EdgeInsets.symmetric(
            horizontal: AppDimensions.paddingHero,
            vertical: AppDimensions.paddingLG,
          ),
          decoration: BoxDecoration(
            color: colorScheme.error,
            borderRadius: BorderRadius.circular(AppDimensions.radiusXXL),
            boxShadow: const [AppShadows.medium],
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                padding: const EdgeInsets.all(AppDimensions.paddingXS),
                decoration: BoxDecoration(
                  color: colorScheme.onError.withValues(
                    alpha: AppDimensions.opacitySubtle,
                  ),
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  LucideIcons.xCircle,
                  size: AppDimensions.iconMD,
                  color: colorScheme.onError,
                ),
              ),
              const SizedBox(width: AppDimensions.paddingLG),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    context.l10n.wrongAnswer,
                    style: AppTextStyles.labelLarge.copyWith(
                      color: colorScheme.onError,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  Text(
                    context.l10n.tryNextTime,
                    style: AppTextStyles.labelSmall.copyWith(
                      color: colorScheme.onError.withValues(
                        alpha: AppDimensions.opacityHigh,
                      ),
                      fontWeight: FontWeight.w700,
                      letterSpacing: AppDimensions.letterSpacingWide,
                      fontSize: AppDimensions.fontSizeXS,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
