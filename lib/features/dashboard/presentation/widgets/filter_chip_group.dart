import 'package:flutter/material.dart';

import '../../../../core/core.dart';

/// A segmented chip group with an icon prefix (e.g. Board chips, Grade chips).
///
/// Uses an external [onChanged] callback to propagate selection changes
/// to the parent (DashboardCubit), following the lift-state-up pattern
/// for predictable state management.
class FilterChipGroup extends StatelessWidget {
  const FilterChipGroup({
    super.key,
    required this.icon,
    required this.iconColor,
    required this.chips,
    required this.activeIndex,
    required this.activeColor,
    this.onChanged,
  });
  final IconData icon;
  final Color iconColor;
  final List<String> chips;
  final int activeIndex;
  final Color activeColor;
  final ValueChanged<int>? onChanged;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: AppDimensions.paddingMD,
        vertical: AppDimensions.paddingXXS,
      ),
      decoration: BoxDecoration(
        color: colorScheme.surface.withValues(alpha: AppDimensions.opacityHigh),
        borderRadius: BorderRadius.circular(AppDimensions.radiusXXL),
        border: Border.all(color: colorScheme.surfaceContainerHigh),
        boxShadow: const [AppShadows.subtle],
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: AppDimensions.iconSM, color: iconColor),
          const SizedBox(width: AppDimensions.paddingSM),
          ...List.generate(chips.length, (index) {
            final isActive = index == activeIndex;
            return Padding(
              padding: const EdgeInsets.only(right: AppDimensions.paddingXXS),
              child: GestureDetector(
                onTap: () {
                  onChanged?.call(index);
                  AppLogger.debug(
                    'Filter chip tapped: ${chips[index]}',
                    tag: AppLogTags.dashboardPage,
                  );
                },
                child: AnimatedContainer(
                  duration: AppDurations.animationFast,
                  padding: const EdgeInsets.symmetric(
                    horizontal: AppDimensions.chipPaddingHorizontal,
                    vertical: AppDimensions.chipPaddingVertical,
                  ),
                  decoration: BoxDecoration(
                    color: isActive ? activeColor : AppColors.transparent,
                    borderRadius: BorderRadius.circular(
                      AppDimensions.radiusXXL,
                    ),
                    boxShadow: isActive ? const [AppShadows.chip] : null,
                  ),
                  child: Text(
                    chips[index],
                    style: AppTextStyles.bodySmall.copyWith(
                      color: isActive
                          ? colorScheme.onPrimary
                          : colorScheme.onSurfaceVariant,
                      fontWeight: isActive ? FontWeight.w700 : FontWeight.w500,
                    ),
                  ),
                ),
              ),
            );
          }),
        ],
      ),
    );
  }
}
