import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

import '../../../../core/core.dart';
import '../../../../shared/shared.dart';
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

    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: AppDimensions.paddingHero,
        vertical: AppDimensions.paddingSection,
      ),
      decoration: signatureGlowDecoration(colorScheme),
      child: Row(
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
                child: ClipOval(
                  child: CachedNetworkImage(
                    imageUrl: profile.avatarUrl,
                    fit: BoxFit.cover,
                    placeholder: (context, url) =>
                        Container(color: AppColors.primaryFixed),
                    errorWidget: (context, url, error) => Container(
                      color: AppColors.primaryFixed,
                      child: Icon(
                        Icons.person,
                        size: AppDimensions.avatarMD,
                        color: colorScheme.onPrimary,
                      ),
                    ),
                  ),
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
                      AppStrings.proBadge,
                      style: AppTextStyles.overline.copyWith(
                        color: AppColors.onSecondaryFixed,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                  ),
                ),
            ],
          ),
          const SizedBox(width: AppDimensions.paddingXXL),
          // Name & grade
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  AppStrings.currentGrade,
                  style: AppTextStyles.labelMedium.copyWith(
                    color: colorScheme.onPrimary.withValues(
                      alpha: AppDimensions.opacityHigh,
                    ),
                    letterSpacing: AppDimensions.letterSpacingNormal,
                  ),
                ),
                const SizedBox(height: AppDimensions.paddingXS),
                Text(
                  profile.name,
                  style: AppTextStyles.headlineLarge.copyWith(
                    color: colorScheme.onPrimary,
                  ),
                ),
                if (profile.email.isNotEmpty) ...[
                  const SizedBox(height: AppDimensions.paddingXXS),
                  Text(
                    profile.email,
                    style: AppTextStyles.bodySmall.copyWith(
                      color: colorScheme.onPrimary.withValues(
                        alpha: AppDimensions.opacityHigh,
                      ),
                    ),
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
                const SizedBox(height: AppDimensions.paddingSM),
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
                      Text(
                        profile.curriculumLabel,
                        style: AppTextStyles.labelLarge.copyWith(
                          color: colorScheme.onPrimary,
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
    );
  }
}
