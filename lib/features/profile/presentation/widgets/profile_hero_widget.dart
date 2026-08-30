import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../../../core/core.dart';
import '../../../../shared/widgets/widgets.dart';
import '../../domain/domain.dart';

/// Profile hero card – gradient card with avatar, name, grade, and Pro badge.
///
/// Matches the React `ProfileHero` component.
class ProfileHeroWidget extends StatelessWidget {
  const ProfileHeroWidget({super.key, required this.profile});
  final UserProfile profile;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final l10n = context.l10n;

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(AppDimensions.paddingHero),
      decoration: signatureGlowDecoration(colorScheme),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          // Avatar with Pro badge
          Stack(
            clipBehavior: Clip.none,
            children: [
              Container(
                width: AppDimensions.avatarProfile,
                height: AppDimensions.avatarProfile,
                padding: const EdgeInsets.all(AppDimensions.switchPadding),
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: colorScheme.onPrimary.withValues(
                      alpha: AppDimensions.opacitySubtle,
                    ),
                    width: AppDimensions.borderWidthThick,
                  ),
                ),
                child: AppAvatar(
                  imageUrl: profile.avatarUrl.isNotEmpty
                      ? profile.avatarUrl
                      : AppAssets.profileHeroAvatarUrl,
                  size: AppDimensions.avatarProfile,
                  placeholderColor: AppColors.primaryFixed,
                  fallbackIconColor: colorScheme.onPrimary,
                ),
              ),
              // Pro badge
              if (profile.isPro)
                Positioned(
                  bottom: -AppDimensions.borderWidthThick,
                  right: -AppDimensions.borderWidthThick,
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: AppDimensions.badgePaddingHorizontal,
                      vertical: AppDimensions.badgePaddingVertical,
                    ),
                    decoration: BoxDecoration(
                      color: AppColors.secondaryFixed,
                      borderRadius: BorderRadius.circular(
                        AppDimensions.radiusXL,
                      ),
                      boxShadow: const [AppShadows.medium],
                    ),
                    child: Text(
                      l10n.proBadge,
                      style: AppTextStyles.overline.copyWith(
                        color: AppColors.onSecondaryFixed,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                  ),
                ),
            ],
          ),
          const SizedBox(height: AppDimensions.paddingLG),
          // Name & grade
          Text(
            l10n.currentGrade,
            style: AppTextStyles.labelMedium.copyWith(
              color: colorScheme.onPrimary.withValues(
                alpha: AppDimensions.opacityHigh,
              ),
              letterSpacing: AppDimensions.letterSpacingNormal,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: AppDimensions.paddingXS),
          Text(
            profile.name.isEmpty ? l10n.welcomeScholar : profile.name,
            style: AppTextStyles.headlineLarge.copyWith(
              color: colorScheme.onPrimary,
            ),
            textAlign: TextAlign.center,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),
          if (profile.joinedAt != null) ...[
            const SizedBox(height: AppDimensions.paddingXS),
            Text(
              l10n.profileJoinedFormat(
                DateFormat('MMMM yyyy').format(profile.joinedAt!),
              ),
              style: AppTextStyles.labelSmall.copyWith(
                color: colorScheme.onPrimary.withValues(
                  alpha: AppDimensions.opacityHigh,
                ),
              ),
              textAlign: TextAlign.center,
            ),
          ],
          const SizedBox(height: AppDimensions.paddingLG),
          if (profile.email.isNotEmpty) ...[
            const SizedBox(height: AppDimensions.paddingXXS),
            Text(
              profile.email,
              style: AppTextStyles.bodyMedium.copyWith(
                color: colorScheme.onPrimary.withValues(
                  alpha: AppDimensions.opacityHigh,
                ),
              ),
              textAlign: TextAlign.center,
              overflow: TextOverflow.ellipsis,
            ),
          ],
          const SizedBox(height: AppDimensions.paddingLG),
          Container(
            padding: const EdgeInsets.symmetric(
              horizontal: AppDimensions.chipPaddingHorizontal,
              vertical: AppDimensions.chipPaddingVertical,
            ),
            decoration: BoxDecoration(
              color: colorScheme.onPrimary.withValues(
                alpha: AppDimensions.opacityFaint,
              ),
              borderRadius: BorderRadius.circular(AppDimensions.radiusXL),
              border: Border.all(
                color: colorScheme.onPrimary.withValues(
                  alpha: AppDimensions.opacityFaint,
                ),
              ),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(
                  Icons.school_outlined,
                  size: AppDimensions.iconSM,
                  color: colorScheme.onPrimary.withValues(
                    alpha: AppDimensions.opacityNearOpaque,
                  ),
                ),
                const SizedBox(width: AppDimensions.chipPaddingVertical),
                Flexible(
                  child: Text(
                    profile.curriculumLabel,
                    style: AppTextStyles.labelLarge.copyWith(
                      color: colorScheme.onPrimary,
                    ),
                    overflow: TextOverflow.ellipsis,
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
