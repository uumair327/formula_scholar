import 'package:flutter/material.dart';

import '../../../core/core.dart';

class DesktopNavItem extends StatefulWidget {
  const DesktopNavItem({
    super.key,
    required this.icon,
    required this.label,
    required this.isSelected,
    required this.onTap,
  });

  final IconData icon;
  final String label;
  final bool isSelected;
  final VoidCallback onTap;

  @override
  State<DesktopNavItem> createState() => _DesktopNavItemState();
}

class _DesktopNavItemState extends State<DesktopNavItem> {
  bool _isHovered = false;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return MouseRegion(
      cursor: SystemMouseCursors.click,
      onEnter: (_) => setState(() => _isHovered = true),
      onExit: (_) => setState(() => _isHovered = false),
      child: Tooltip(
        message: widget.label,
        child: GestureDetector(
          onTap: widget.onTap,
          behavior: HitTestBehavior.opaque,
          child: AnimatedContainer(
            duration: AppDurations.animationFast,
            margin: const EdgeInsets.symmetric(
              horizontal: AppDimensions.paddingMD,
              vertical: AppDimensions.paddingXXS,
            ),
            padding: const EdgeInsets.symmetric(
              horizontal: AppDimensions.paddingLG,
              vertical: AppDimensions.paddingMD,
            ),
            decoration: BoxDecoration(
              gradient: widget.isSelected
                  ? (isDark
                        ? AppColors.darkPrimaryGradient
                        : AppColors.primaryGradient)
                  : null,
              color: !widget.isSelected && _isHovered
                  ? colorScheme.surfaceContainerHigh.withValues(alpha: 0.5)
                  : null,
              borderRadius: BorderRadius.circular(AppDimensions.radiusMD),
            ),
            child: Row(
              children: [
                Icon(
                  widget.icon,
                  size: AppDimensions.iconDefault,
                  color: widget.isSelected
                      ? AppColors.white
                      : _isHovered
                      ? colorScheme.primary
                      : colorScheme.onSurfaceVariant,
                ),
                const SizedBox(width: AppDimensions.paddingMD),
                Text(
                  widget.label,
                  style: AppTextStyles.labelLarge.copyWith(
                    color: widget.isSelected
                        ? AppColors.white
                        : _isHovered
                        ? colorScheme.primary
                        : colorScheme.onSurfaceVariant,
                    fontWeight: widget.isSelected
                        ? FontWeight.w700
                        : FontWeight.w500,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
