import 'package:flutter/material.dart';
import '../../../../../core/core.dart';
import '../../../../../shared/shared.dart';

class SubjectHeroCard extends StatelessWidget {
  const SubjectHeroCard({super.key, required this.subject});

  final SelectedSubject subject;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Container(
      padding: const EdgeInsets.all(AppDimensions.paddingHero),
      decoration: BoxDecoration(
        gradient: isDark ? AppColors.darkHeroGradient : AppColors.heroGradient,
        borderRadius: BorderRadius.circular(AppDimensions.radiusXL),
        boxShadow: [AppShadows.glow(colorScheme.primary)],
      ),
      child: Stack(
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              AppInfoChip(
                label: subject.name.toUpperCase(),
                backgroundColor: colorScheme.onPrimary.withValues(alpha: AppDimensions.opacitySubtle),
                textColor: colorScheme.onPrimary,
                textStyle: AppTextStyles.overline.copyWith(color: colorScheme.onPrimary),
              ),
              const SizedBox(height: AppDimensions.paddingLG),
              Text(subject.name, style: AppTextStyles.displayLarge.copyWith(
                color: colorScheme.onPrimary, fontWeight: FontWeight.w800,
              )),
              const SizedBox(height: AppDimensions.paddingSM),
              Text(
                subject.subtitle.isNotEmpty
                    ? '${subject.subtitle}. ${subject.description}'
                    : subject.description,
                style: AppTextStyles.bodySmall.copyWith(
                  color: colorScheme.onPrimary.withValues(alpha: AppDimensions.opacityHigh),
                  height: AppDimensions.lineHeightRelaxed,
                ),
              ),
            ],
          ),
          Positioned(
            right: AppDimensions.decorativeOffset,
            bottom: AppDimensions.decorativeOffset,
            child: Opacity(
              opacity: AppDimensions.opacityFaint,
              child: Transform.rotate(
                angle: AppDimensions.rotationSubtle,
                child: Hero(
                  tag: 'subject_icon_${subject.id}',
                  child: Icon(AppIconMapper.resolve(subject.iconName),
                    size: AppDimensions.iconDecorative, color: colorScheme.onPrimary,
                  ),
                ),
              ),
            ),
          ),
          Positioned(
            top: -AppDimensions.paddingSM,
            right: -AppDimensions.paddingSM,
            child: Container(
              width: AppDimensions.glowCircleSizeSM,
              height: AppDimensions.glowCircleSizeSM,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: colorScheme.surface.withValues(alpha: AppDimensions.opacityFaint),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
