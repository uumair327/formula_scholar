import 'package:flutter/material.dart';
import 'package:lucide_icons/lucide_icons.dart';

import '../../../../../core/core.dart';

class LocationInfoCards extends StatelessWidget {
  const LocationInfoCards({super.key});

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Column(
      children: [
        Container(
          padding: const EdgeInsets.all(AppDimensions.paddingLG),
          decoration: BoxDecoration(
            color: AppColors.primaryFixed.withValues(
              alpha: AppDimensions.opacitySubtle,
            ),
            borderRadius: BorderRadius.circular(AppDimensions.radiusMD),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                width: AppDimensions.avatarMD,
                height: AppDimensions.avatarMD,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: colorScheme.surface,
                  boxShadow: const [AppShadows.subtle],
                ),
                child: const Icon(
                  LucideIcons.sparkles,
                  size: AppDimensions.iconDefault,
                  color: AppColors.primary,
                ),
              ),
              const SizedBox(height: AppDimensions.paddingMD),
              Text(
                context.l10n.step1LocalizedTitle,
                style: AppTextStyles.headlineSmall.copyWith(
                  color: AppColors.onPrimaryContainer,
                  fontWeight: FontWeight.w700,
                ),
              ),
              const SizedBox(height: AppDimensions.paddingXS),
              Text(
                context.l10n.step1LocalizedDesc,
                style: AppTextStyles.bodySmall.copyWith(
                  color: AppColors.onPrimaryContainer.withValues(
                    alpha: AppDimensions.opacityHigh,
                  ),
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: AppDimensions.paddingMD),
        Container(
          padding: const EdgeInsets.all(AppDimensions.paddingLG),
          decoration: BoxDecoration(
            color: colorScheme.surfaceContainerHigh,
            borderRadius: BorderRadius.circular(AppDimensions.radiusMD),
          ),
          child: Row(
            children: [
              const Icon(
                LucideIcons.shieldCheck,
                color: AppColors.secondary,
                size: AppDimensions.iconLG,
              ),
              const SizedBox(width: AppDimensions.paddingMD),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      context.l10n.step1PrivacyTitle,
                      style: AppTextStyles.labelMedium.copyWith(
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    const SizedBox(height: AppDimensions.paddingXXS),
                    Text(
                      context.l10n.step1PrivacyDesc,
                      style: AppTextStyles.bodySmall.copyWith(
                        color: colorScheme.onSurfaceVariant,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
