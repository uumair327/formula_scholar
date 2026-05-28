import 'package:flutter/material.dart';

import '../../../../../core/core.dart';

class SignupBrandColumn extends StatelessWidget {
  const SignupBrandColumn({super.key});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final l10n = context.l10n;
    return Container(
      padding: const EdgeInsets.all(AppDimensions.paddingHero),
      decoration: BoxDecoration(
        gradient: isDark ? AppColors.darkHeroGradient : AppColors.heroGradient,
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            l10n.signupBrandTitle,
            style: AppTextStyles.headlineLarge.copyWith(
              color: AppColors.onPrimary,
              fontWeight: FontWeight.w900,
              letterSpacing: AppDimensions.letterSpacingTight,
            ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                l10n.signupBrandHeadline,
                style: AppTextStyles.headlineMedium.copyWith(
                  color: AppColors.onPrimary,
                  fontWeight: FontWeight.w900,
                  height: AppDimensions.lineHeightTight,
                  letterSpacing: AppDimensions.letterSpacingTight,
                ),
              ),
              const SizedBox(height: AppDimensions.paddingMD),
              Text(
                l10n.signupBrandDesc,
                style: AppTextStyles.bodyLarge.copyWith(
                  color: AppColors.primaryFixed.withValues(
                    alpha: AppDimensions.opacityHigh,
                  ),
                  height: AppDimensions.lineHeightRelaxed,
                ),
              ),
            ],
          ),
          _TestimonialCard(),
        ],
      ),
    );
  }
}

class _TestimonialCard extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    return Container(
      padding: const EdgeInsets.all(AppDimensions.paddingLG),
      decoration: BoxDecoration(
        color: AppColors.onPrimary.withValues(
          alpha: AppDimensions.opacitySubtle,
        ),
        borderRadius: BorderRadius.circular(AppDimensions.radiusMD),
        border: Border.all(
          color: AppColors.onPrimary.withValues(
            alpha: AppDimensions.opacityFaint,
          ),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: AppDimensions.avatarMD,
                height: AppDimensions.avatarMD,
                decoration: const BoxDecoration(
                  shape: BoxShape.circle,
                  color: AppColors.primaryFixed,
                ),
                child: Center(
                  child: Text(
                    'IS',
                    style: AppTextStyles.labelSmall.copyWith(
                      color: AppColors.onPrimaryFixed,
                      fontWeight: FontWeight.w900,
                    ),
                  ),
                ),
              ),
              const SizedBox(width: AppDimensions.paddingMD),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    l10n.signupTestimonialName,
                    style: AppTextStyles.labelLarge.copyWith(
                      color: AppColors.onPrimary,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  Text(
                    l10n.signupTestimonialRole,
                    style: AppTextStyles.bodySmall.copyWith(
                      color: AppColors.onPrimary.withValues(
                        alpha: AppDimensions.opacityMedium,
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
          const SizedBox(height: AppDimensions.paddingMD),
          Text(
            l10n.signupTestimonial,
            style: AppTextStyles.bodyMedium.copyWith(
              color: AppColors.onPrimary.withValues(
                alpha: AppDimensions.opacityNearOpaque,
              ),
              fontStyle: FontStyle.italic,
            ),
          ),
        ],
      ),
    );
  }
}
