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

    return LayoutBuilder(
      builder: (context, constraints) {
        final isCompact = constraints.maxWidth < 450;

        final avatarWidget = Container(
          padding: const EdgeInsets.all(4.0),
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            gradient: isDark
                ? AppColors.darkPrimaryGradient
                : AppColors.primaryGradient,
            boxShadow: [
              BoxShadow(
                color: colorScheme.primary.withValues(alpha: 0.25),
                blurRadius: 16,
                offset: const Offset(0, 6),
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
        );

        final detailsWidget = Column(
          crossAxisAlignment:
              isCompact ? CrossAxisAlignment.center : CrossAxisAlignment.start,
          children: [
            Text(
              profile?.name ?? context.l10n.welcomeScholar,
              style: AppTextStyles.titleLarge.copyWith(
                color: colorScheme.onSurface,
                fontWeight: FontWeight.w800,
              ),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              textAlign: isCompact ? TextAlign.center : TextAlign.start,
            ),
            const SizedBox(height: AppDimensions.paddingXXS),
            Text(
              profile?.email ?? '—',
              style: AppTextStyles.bodySmall.copyWith(
                color: colorScheme.onSurfaceVariant,
              ),
              textAlign: isCompact ? TextAlign.center : TextAlign.start,
            ),
            const SizedBox(height: AppDimensions.paddingMD),
            Container(
              padding: const EdgeInsets.symmetric(
                horizontal: AppDimensions.chipPaddingHorizontal,
                vertical: AppDimensions.chipPaddingVertical,
              ),
              decoration: BoxDecoration(
                color: colorScheme.secondaryContainer.withValues(
                  alpha: isDark ? 0.3 : 1.0,
                ),
                borderRadius: BorderRadius.circular(AppDimensions.radiusXL),
                border: Border.all(
                  color: colorScheme.secondary.withValues(alpha: 0.2),
                  width: 1,
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
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                ],
              ),
            ),
          ],
        );

        if (isCompact) {
          return AppGlassCard(
            borderRadius: AppDimensions.radiusLG,
            padding: const EdgeInsets.symmetric(
              horizontal: AppDimensions.paddingXL,
              vertical: AppDimensions.paddingXXL,
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                avatarWidget,
                const SizedBox(height: AppDimensions.paddingXL),
                detailsWidget,
              ],
            ),
          );
        }

        return AppGlassCard(
          borderRadius: AppDimensions.radiusLG,
          padding: const EdgeInsets.all(AppDimensions.paddingXXL),
          child: Row(
            children: [
              avatarWidget,
              const SizedBox(width: AppDimensions.paddingXL),
              Expanded(child: detailsWidget),
            ],
          ),
        );
      },
    );
  }
}

