import 'package:flutter/material.dart';
import '../../../../../core/core.dart';

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
              Text(
                subject.name,
                style: AppTextStyles.headlineLarge.copyWith(
                  color: Colors.white,
                  fontWeight: FontWeight.w800,
                  letterSpacing: -0.5,
                ),
              ),
              const SizedBox(height: AppDimensions.paddingSM),
              Text(
                subject.subtitle.isNotEmpty
                    ? '${subject.subtitle}. ${subject.description}'
                    : subject.description,
                style: AppTextStyles.bodyMedium.copyWith(
                  color: Colors.white.withValues(
                    alpha: AppDimensions.opacityHigh,
                  ),
                  height: AppDimensions.lineHeightRelaxed,
                ),
              ),
            ],
          ),
          Positioned(
            right: -AppDimensions.paddingLG,
            bottom: -AppDimensions.paddingLG,
            child: Opacity(
              opacity: 0.15,
              child: Transform.rotate(
                angle: -0.2,
                child: Hero(
                  tag: 'subject_icon_${subject.id}',
                  child: Icon(
                    AppIconMapper.resolve(subject.iconName),
                    size: 160,
                    color: Colors.white,
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
                color: colorScheme.surface.withValues(
                  alpha: AppDimensions.opacityFaint,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
