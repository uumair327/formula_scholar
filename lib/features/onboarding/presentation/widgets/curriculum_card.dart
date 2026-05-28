import 'package:flutter/material.dart';
import 'package:lucide_icons/lucide_icons.dart';
import '../../../../core/core.dart';
import '../../domain/domain.dart';
class CurriculumCard extends StatelessWidget {
  const CurriculumCard({
    super.key,
    required this.board,
    required this.isSelected,
    required this.onTap,
    required this.icon,
    required this.color,
  });
  final Board board;
  final bool isSelected;
  final VoidCallback onTap;
  final IconData icon;
  final Color color;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: AppDurations.animationFast,
        padding: const EdgeInsets.all(AppDimensions.paddingXXL),
        decoration: BoxDecoration(
          color: colorScheme.surfaceContainerLowest,
          borderRadius: BorderRadius.circular(AppDimensions.radiusMD),
          border: Border.all(
            color: isSelected
                ? AppColors.primary.withValues(
                    alpha: AppDimensions.opacityMedium,
                  )
                : AppColors.transparent,
            width: isSelected
                ? AppDimensions.borderWidthThick
                : AppDimensions.borderWidth,
          ),
          boxShadow: isSelected ? [AppShadows.ghost] : [AppShadows.subtle],
        ),
        child: Stack(
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                AnimatedContainer(
                  duration: AppDurations.animationFast,
                  width: AppDimensions.avatarLG,
                  height: AppDimensions.avatarLG,
                  decoration: BoxDecoration(
                    color: isSelected
                        ? color
                        : color.withValues(alpha: AppDimensions.opacityFaint),
                    borderRadius: BorderRadius.circular(AppDimensions.radiusMD),
                  ),
                  child: Icon(
                    icon,
                    size: AppDimensions.iconLG,
                    color: isSelected ? AppColors.onPrimary : color,
                  ),
                ),
                const SizedBox(height: AppDimensions.paddingXL),
                Text(
                  board.name,
                  style: AppTextStyles.headlineSmall.copyWith(
                    fontWeight: FontWeight.w700,
                  ),
                ),
                const SizedBox(height: AppDimensions.paddingXXS),
                Text(
                  board.description,
                  style: AppTextStyles.bodySmall.copyWith(
                    color: colorScheme.onSurfaceVariant,
                  ),
                ),
              ],
            ),
            if (isSelected)
              Positioned(
                top: 0,
                left: Directionality.of(context) == TextDirection.rtl
                    ? 0
                    : null,
                right: Directionality.of(context) == TextDirection.ltr
                    ? 0
                    : null,
                child: Container(
                  width: AppDimensions.iconMD,
                  height: AppDimensions.iconMD,
                  decoration: const BoxDecoration(
                    shape: BoxShape.circle,
                    color: AppColors.primary,
                  ),
                  child: const Icon(
                    LucideIcons.checkCircle2,
                    size: AppDimensions.iconDefault,
                    color: AppColors.onPrimary,
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
