library;

import 'package:flutter/material.dart';
import 'package:lucide_icons/lucide_icons.dart';

import '../../../../core/core.dart';
import '../../../../shared/shared.dart';
import '../../domain/domain.dart';

class CompactSubjectCard extends StatelessWidget {
  const CompactSubjectCard({
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
    final faintColor = accentColor.withValues(alpha: AppDimensions.opacityFaint);
    final iconData = AppIconMapper.resolve(subject.iconName);

    return AppCard(
      color: lightColor,
      padding: const EdgeInsets.all(AppDimensions.paddingXXL),
      border: Border.all(color: faintColor),
      onTap: onTap,
      onLongPress: onLongPress,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Hero(
                tag: 'subject_icon_${subject.id}',
                child: AppIconCircle(
                  icon: iconData,
                  size: AppDimensions.avatarMD,
                  backgroundColor: lightColor,
                  iconColor: accentColor,
                  iconSize: AppDimensions.iconLG,
                  borderRadius: AppDimensions.radiusXL,
                ),
              ),
              if (subject.badgeText != null)
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: AppDimensions.paddingSM,
                    vertical: AppDimensions.paddingXXS,
                  ),
                  decoration: BoxDecoration(
                    color: faintColor,
                    borderRadius: BorderRadius.circular(AppDimensions.radiusXXL),
                  ),
                  child: Text(
                    subject.badgeText!,
                    style: AppTextStyles.labelSmall.copyWith(
                      color: accentColor,
                      fontSize: AppDimensions.fontSizeXXS,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                ),
            ],
          ),
          const SizedBox(height: AppDimensions.paddingLG),
          Text(
            subject.category.toUpperCase(),
            style: AppTextStyles.labelSmall.copyWith(color: accentColor),
          ),
          const SizedBox(height: AppDimensions.paddingXS),
          Text(subject.name, style: AppTextStyles.headlineSmall),
          if (subject.masteryPercentage != null) ...[
            const SizedBox(height: AppDimensions.paddingSM),
            Text(
              subject.description,
              style: AppTextStyles.bodyMedium.copyWith(
                color: accentColor.withValues(alpha: AppDimensions.opacityHigh),
              ),
            ),
            const SizedBox(height: AppDimensions.paddingXL),
            ProgressBar(
              percentage: subject.masteryPercentage!,
              barColor: accentColor,
              backgroundColor: faintColor,
              height: AppDimensions.progressBarSM,
            ),
            const SizedBox(height: AppDimensions.paddingSM),
            Text(
              '${subject.masteryPercentage!.toInt()}% MASTERED',
              style: AppTextStyles.labelSmall.copyWith(
                color: accentColor,
                fontSize: AppDimensions.fontSizeXS,
              ),
            ),
          ],
          if (subject.lastViewed != null) ...[
            const SizedBox(height: AppDimensions.paddingMD),
            Row(
              children: [
                Icon(LucideIcons.clock, size: AppDimensions.iconSM, color: accentColor),
                const SizedBox(width: AppDimensions.paddingSM),
                Text(
                  'Last viewed ${subject.lastViewed}',
                  style: AppTextStyles.bodySmall.copyWith(color: accentColor),
                ),
              ],
            ),
          ],
          if (subject.subtitle != null) ...[
            const SizedBox(height: AppDimensions.paddingMD),
            Row(
              children: [
                Icon(LucideIcons.star, size: AppDimensions.iconSM, color: accentColor),
                const SizedBox(width: AppDimensions.paddingSM),
                Expanded(
                  child: Text(
                    subject.subtitle!,
                    style: AppTextStyles.bodySmall.copyWith(color: accentColor),
                  ),
                ),
              ],
            ),
          ],
        ],
      ),
    );
  }
}
