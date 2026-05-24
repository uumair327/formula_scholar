import 'package:flutter/material.dart';
import 'package:lucide_icons/lucide_icons.dart';

import '../../../../../core/core.dart';
import '../../../../../shared/shared.dart';
import '../../../domain/domain.dart';

class AccountProfileCard extends StatelessWidget {
  const AccountProfileCard({super.key, required this.profile});

  final UserProfile? profile;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return AppCard(
      padding: const EdgeInsets.all(AppDimensions.paddingXXL),
      child: Row(
        children: [
          AppAvatar(
            imageUrl: profile?.avatarUrl ?? AppAssets.profileAvatarUrl,
            size: AppDimensions.avatarHero,
            border: Border.all(color: colorScheme.primaryContainer, width: AppDimensions.borderWidth),
          ),
          const SizedBox(width: AppDimensions.paddingXL),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(profile?.name ?? AppStrings.welcomeScholar,
                  style: AppTextStyles.titleLarge.copyWith(color: colorScheme.onSurface)),
                const SizedBox(height: AppDimensions.paddingXXS),
                Text(profile?.email ?? '—',
                  style: AppTextStyles.bodySmall.copyWith(color: colorScheme.onSurfaceVariant)),
                const SizedBox(height: AppDimensions.paddingSM),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: AppDimensions.chipPaddingHorizontal,
                    vertical: AppDimensions.chipPaddingVertical,
                  ),
                  decoration: BoxDecoration(
                    color: colorScheme.secondaryContainer,
                    borderRadius: BorderRadius.circular(AppDimensions.radiusXL),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(LucideIcons.checkCircle, size: AppDimensions.iconXS, color: colorScheme.secondary),
                      const SizedBox(width: AppDimensions.paddingXS),
                      Text(AppStrings.verifiedAccount,
                        style: AppTextStyles.labelSmall.copyWith(
                          color: colorScheme.onSecondaryContainer,
                          letterSpacing: AppDimensions.letterSpacingNarrow,
                        )),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
