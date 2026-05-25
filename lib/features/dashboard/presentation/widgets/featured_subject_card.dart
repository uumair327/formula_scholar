library;

import 'package:flutter/material.dart';

import '../../../../core/core.dart';
import '../../../../shared/shared.dart';
import '../../domain/domain.dart';

class FeaturedSubjectCard extends StatelessWidget {
  const FeaturedSubjectCard({
    super.key,
    required this.subject,
    this.onTap,
    this.onLongPress,
  });

  final Subject subject;
  final VoidCallback? onTap;
  final VoidCallback? onLongPress;

  @override
  Widget build(BuildContext context) {
    final accentColor = Color(subject.colorValue);
    final lightColor = accentColor.withValues(alpha: AppDimensions.opacityLight);
    final iconData = AppIconMapper.resolve(subject.iconName);
    final colorScheme = Theme.of(context).colorScheme;

    return AppCard(
      padding: EdgeInsets.zero,
      clipBehavior: Clip.antiAlias,
      onTap: onTap,
      onLongPress: onLongPress,
      child: ConstrainedBox(
        constraints: const BoxConstraints(minHeight: 280),
        child: Stack(
          clipBehavior: Clip.none,
          children: [
            Positioned(
              right: -30,
              bottom: -30,
              child: Icon(
                iconData,
                size: 180,
                color: accentColor.withValues(alpha: 0.08),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(AppDimensions.paddingHero),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Hero(
                        tag: 'subject_icon_${subject.id}',
                        child: AppIconCircle(
                          icon: iconData,
                          size: AppDimensions.avatarLG,
                          backgroundColor: lightColor,
                          iconColor: accentColor,
                          iconSize: AppDimensions.iconXL,
                          borderRadius: AppDimensions.radiusLG,
                        ),
                      ),
                      if (subject.badgeText != null)
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: AppDimensions.chipPaddingHorizontal,
                            vertical: AppDimensions.badgePaddingVertical,
                          ),
                          decoration: BoxDecoration(
                            color: colorScheme.surfaceContainerLowest,
                            border: Border.all(
                              color: colorScheme.outlineVariant.withValues(
                                alpha: AppDimensions.opacityLight,
                              ),
                            ),
                            borderRadius: BorderRadius.circular(AppDimensions.radiusXXL),
                          ),
                          child: Text(
                            subject.badgeText!,
                            style: AppTextStyles.labelSmall.copyWith(
                              color: colorScheme.onSurfaceVariant,
                              fontSize: AppDimensions.fontSizeXS,
                            ),
                          ),
                        ),
                    ],
                  ),
                  const SizedBox(height: AppDimensions.paddingLG),
                  Text(
                    subject.category.toUpperCase(),
                    style: AppTextStyles.overline.copyWith(
                      color: accentColor,
                      letterSpacing: 1.2,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: AppDimensions.paddingXS),
                  Text(subject.name, style: AppTextStyles.headlineMedium),
                  const SizedBox(height: AppDimensions.paddingSM),
                  Text(
                    subject.description,
                    style: AppTextStyles.bodyMedium.copyWith(
                      color: colorScheme.onSurfaceVariant,
                      height: 1.4,
                    ),
                    maxLines: 3,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: AppDimensions.paddingXL),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: AppDimensions.chipPaddingHorizontalLG,
                          vertical: AppDimensions.chipPaddingVerticalLG,
                        ),
                        decoration: BoxDecoration(
                          color: accentColor.withValues(alpha: AppDimensions.opacitySubtle),
                          borderRadius: BorderRadius.circular(AppDimensions.radiusXL),
                          border: Border.all(
                            color: accentColor.withValues(alpha: 0.3),
                          ),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(
                              Icons.functions,
                              size: 16,
                              color: accentColor,
                            ),
                            const SizedBox(width: AppDimensions.paddingXS),
                            Text(
                              '${subject.formulaCount} Formulas',
                              style: AppTextStyles.labelLarge.copyWith(color: accentColor),
                            ),
                          ],
                        ),
                      ),
                    ],
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
