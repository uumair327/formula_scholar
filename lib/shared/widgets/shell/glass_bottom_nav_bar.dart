import 'dart:ui';

import 'package:flutter/material.dart';

import '../../../core/core.dart';
import 'nav_item.dart';
import 'shell_nav_data.dart';

class GlassBottomNavBar extends StatelessWidget {
  const GlassBottomNavBar({
    super.key,
    required this.currentIndex,
    required this.onTap,
  });

  final int currentIndex;
  final ValueChanged<int> onTap;

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final items = navItems(context);

    return ClipRRect(
      borderRadius: BorderRadius.circular(AppDimensions.radiusXXL),
      child: BackdropFilter(
        filter: ImageFilter.blur(
          sigmaX: AppDimensions.glassBlurSigma,
          sigmaY: AppDimensions.glassBlurSigma,
        ),
        child: Container(
          decoration: BoxDecoration(
            color: isDark ? AppColors.glassDark : AppColors.glassLight,
            borderRadius: BorderRadius.circular(AppDimensions.radiusXXL),
            border: Border.all(
              color: isDark
                  ? AppColors.glassBorderDark
                  : AppColors.glassBorderLight,
              width: AppDimensions.borderWidth,
            ),
            boxShadow: [
              BoxShadow(
                color: AppColors.primary.withValues(alpha: 0.1),
                blurRadius: 24,
                offset: const Offset(0, 8),
              ),
            ],
          ),
          child: Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: AppDimensions.paddingSM,
              vertical: AppDimensions.paddingSM,
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: items.asMap().entries.map((entry) {
                return Expanded(
                  child: NavItem(
                    icon: entry.value.icon,
                    label: entry.value.label,
                    isSelected: entry.key == currentIndex,
                    onTap: () => onTap(entry.key),
                  ),
                );
              }).toList(),
            ),
          ),
        ),
      ),
    );
  }
}
