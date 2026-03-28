import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:lucide_icons/lucide_icons.dart';

import '../../core/core.dart';

/// Shell page wrapping routes with a persistent bottom navigation bar.
///
/// Matches the React app's `<BottomNav>` component.
class MainShellPage extends StatelessWidget {
  final StatefulNavigationShell navigationShell;

  const MainShellPage({
    super.key,
    required this.navigationShell,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: navigationShell,
      bottomNavigationBar: _BottomNavBar(
        currentIndex: navigationShell.currentIndex,
        onTap: (index) {
          AppLogger.debug(
            'Bottom nav tapped: index=$index',
            tag: AppLogTags.mainShellPage,
          );
          navigationShell.goBranch(
            index,
            initialLocation: index == navigationShell.currentIndex,
          );
        },
      ),
    );
  }
}

class _BottomNavBar extends StatelessWidget {
  final int currentIndex;
  final ValueChanged<int> onTap;

  const _BottomNavBar({
    required this.currentIndex,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.surface.withValues(alpha: AppDimensions.opacityNearOpaque),
        borderRadius: const BorderRadius.vertical(top: Radius.circular(AppDimensions.radiusShell)),
        boxShadow: const [AppShadows.bottomNav],
      ),
      child: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: AppDimensions.paddingLG, vertical: AppDimensions.paddingSM),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _NavItem(
                icon: LucideIcons.home,
                label: AppStrings.navHome,
                isSelected: currentIndex == 0,
                onTap: () => onTap(0),
                fillWhenActive: true,
              ),
              _NavItem(
                icon: LucideIcons.bookOpen,
                label: AppStrings.navChapters,
                isSelected: currentIndex == 1,
                onTap: () => onTap(1),
                fillWhenActive: false,
              ),
              _NavItem(
                icon: LucideIcons.fileText,
                label: AppStrings.navCheatSheet,
                isSelected: currentIndex == 2,
                onTap: () => onTap(2),
                fillWhenActive: true,
              ),
              _NavItem(
                icon: LucideIcons.user,
                label: AppStrings.navProfile,
                isSelected: currentIndex == 3,
                onTap: () => onTap(3),
                fillWhenActive: true,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _NavItem extends StatelessWidget {
  final IconData icon;
  final String label;
  final bool isSelected;
  final VoidCallback onTap;
  final bool fillWhenActive;

  const _NavItem({
    required this.icon,
    required this.label,
    required this.isSelected,
    required this.onTap,
    this.fillWhenActive = false,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      behavior: HitTestBehavior.opaque,
      child: AnimatedContainer(
        duration: AppDurations.animationDefault,
        curve: AppDurations.curveEaseOutBack,
        padding: EdgeInsets.symmetric(
          horizontal: isSelected ? AppDimensions.paddingLG : AppDimensions.paddingMD,
          vertical: AppDimensions.paddingSM,
        ),
        decoration: BoxDecoration(
          color: isSelected ? AppColors.primaryFixed : AppColors.transparent,
          borderRadius: BorderRadius.circular(AppDimensions.radiusLG),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              icon,
              size: AppDimensions.iconDefault,
              color: isSelected
                  ? AppColors.onPrimaryFixedVariant
                  : AppColors.outline,
            ),
            const SizedBox(height: AppDimensions.paddingXXS),
            Text(
              label,
              style: AppTextStyles.labelSmall.copyWith(
                color: isSelected
                    ? AppColors.onPrimaryFixedVariant
                    : AppColors.outline,
                fontWeight: isSelected ? FontWeight.w700 : FontWeight.w500,
                fontSize: AppDimensions.fontSizeXS,
                letterSpacing: AppDimensions.letterSpacingNarrow,
              ),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ],
        ),
      ),
    );
  }
}
