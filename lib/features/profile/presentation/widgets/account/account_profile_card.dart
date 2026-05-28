import 'package:flutter/material.dart';
import 'package:lucide_icons/lucide_icons.dart';

import '../../../../../core/core.dart';

import '../../../domain/domain.dart';

class AccountProfileCard extends StatelessWidget {
  const AccountProfileCard({super.key, required this.profile});

  final UserProfile? profile;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return AppCard(
      padding: const EdgeInsets.all(AppDimensions.paddingXXL),
      child: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [
              colorScheme.primaryContainer.withValues(alpha: 0.3),
              colorScheme.surface,
            ],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          borderRadius: BorderRadius.circular(AppDimensions.radiusMD),
        ),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(3.0),
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                gradient: isDark
                    ? AppColors.darkPrimaryGradient
                    : AppColors.primaryGradient,
                boxShadow: [
                  BoxShadow(
                    color: colorScheme.primary.withValues(alpha: 0.3),
                    blurRadius: 12,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: Container(
                padding: const EdgeInsets.all(2.0),
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: colorScheme.surface,
                ),
                child: AppAvatar(
                  imageUrl: profile?.avatarUrl ?? AppAssets.profileAvatarUrl,
                  size: AppDimensions.avatarHero,
                ),
              ),
            ),
            const SizedBox(width: AppDimensions.paddingXL),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    profile?.name ?? context.l10n.welcomeScholar,
                    style: AppTextStyles.titleLarge.copyWith(
                      color: colorScheme.onSurface,
                      fontWeight: FontWeight.w800,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: AppDimensions.paddingXXS),
                  Text(
                    profile?.email ?? '—',
                    style: AppTextStyles.bodySmall.copyWith(
                      color: colorScheme.onSurfaceVariant,
                    ),
                  ),
                  const SizedBox(height: AppDimensions.paddingSM),
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: AppDimensions.chipPaddingHorizontal,
                      vertical: AppDimensions.chipPaddingVertical,
                    ),
                    decoration: BoxDecoration(
                      color: colorScheme.secondaryContainer,
                      borderRadius: BorderRadius.circular(
                        AppDimensions.radiusXL,
                      ),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(
                          LucideIcons.checkCircle,
                          size: AppDimensions.iconXS,
                          color: colorScheme.secondary,
                        ),
                        const SizedBox(width: AppDimensions.paddingXS),
                        Text(
                          context.l10n.verifiedAccount,
                          style: AppTextStyles.labelSmall.copyWith(
                            color: colorScheme.onSecondaryContainer,
                            letterSpacing: AppDimensions.letterSpacingNarrow,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
