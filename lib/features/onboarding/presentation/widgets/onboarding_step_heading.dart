import 'package:flutter/material.dart';

import '../../../../core/core.dart';

class OnboardingStepHeading extends StatelessWidget {
  const OnboardingStepHeading({
    super.key,
    required this.tag,
    required this.title,
    this.subtitle,
  });
  final String tag;
  final String title;
  final String? subtitle;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          tag.toUpperCase(),
          style: AppTextStyles.overline.copyWith(
            color: AppColors.primary,
            fontWeight: FontWeight.w700,
            letterSpacing: AppDimensions.letterSpacingWide,
          ),
        ),
        const SizedBox(height: AppDimensions.paddingXS),
        Text(
          title,
          style: AppTextStyles.headlineMedium.copyWith(
            fontWeight: FontWeight.w900,
            letterSpacing: AppDimensions.letterSpacingTight,
            height: AppDimensions.lineHeightTight,
          ),
        ),
        if (subtitle != null) ...[
          const SizedBox(height: AppDimensions.paddingSM),
          Text(
            subtitle!,
            style: AppTextStyles.bodyLarge.copyWith(
              color: colorScheme.onSurfaceVariant,
            ),
          ),
        ],
      ],
    );
  }
}
