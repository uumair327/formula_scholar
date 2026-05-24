import 'package:flutter/material.dart';

import '../../../core/core.dart';

class NavItem extends StatefulWidget {
  const NavItem({
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
  State<NavItem> createState() => _NavItemState();
}

class _NavItemState extends State<NavItem> with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  late final Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: AppDurations.animationFast,
    );
    _scaleAnimation = Tween<double>(begin: 1.0, end: 0.85).animate(
      CurvedAnimation(parent: _controller, curve: AppDurations.curvePremium),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return GestureDetector(
      onTapDown: (_) => _controller.forward(),
      onTapUp: (_) => _controller.reverse(),
      onTapCancel: () => _controller.reverse(),
      onTap: widget.onTap,
      behavior: HitTestBehavior.opaque,
      child: Tooltip(
        message: widget.label,
        child: AnimatedBuilder(
          animation: _scaleAnimation,
          builder: (context, child) {
            return Transform.scale(scale: _scaleAnimation.value, child: child);
          },
          child: AnimatedContainer(
            duration: AppDurations.animationDefault,
            curve: AppDurations.curvePremium,
            padding: const EdgeInsets.symmetric(
              vertical: AppDimensions.paddingSM,
            ),
            margin: const EdgeInsets.symmetric(
              horizontal: AppDimensions.paddingXXS,
            ),
            decoration: BoxDecoration(
              gradient: widget.isSelected
                  ? (isDark
                        ? AppColors.darkPrimaryGradient
                        : AppColors.primaryGradient)
                  : null,
              borderRadius: BorderRadius.circular(AppDimensions.radiusXL),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(
                  widget.icon,
                  size: AppDimensions.iconDefault,
                  color: widget.isSelected
                      ? AppColors.white
                      : colorScheme.outline,
                ),
                const SizedBox(height: AppDimensions.paddingXXS),
                Text(
                  widget.label,
                  style: AppTextStyles.labelSmall.copyWith(
                    color: widget.isSelected
                        ? AppColors.white
                        : colorScheme.outline,
                    fontWeight: widget.isSelected
                        ? FontWeight.w700
                        : FontWeight.w500,
                    fontSize: AppDimensions.fontSizeXS,
                    letterSpacing: AppDimensions.letterSpacingNarrow,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
