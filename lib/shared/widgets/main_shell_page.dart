import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:lucide_icons/lucide_icons.dart';

import '../../core/core.dart';

/// Shell page wrapping routes with a responsive navigation:
/// - **Desktop** (≥1024px): Persistent side [NavigationRail]
/// - **Mobile/Tablet** (<1024px): Bottom navigation bar (existing pattern)
class MainShellPage extends StatelessWidget {
  const MainShellPage({super.key, required this.navigationShell});
  final StatefulNavigationShell navigationShell;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        if (constraints.maxWidth >= AppDimensions.breakpointDesktop) {
          return _DesktopShell(navigationShell: navigationShell);
        }
        return _MobileShell(navigationShell: navigationShell);
      },
    );
  }
}

/// Desktop shell with side navigation rail.
class _DesktopShell extends StatelessWidget {
  const _DesktopShell({required this.navigationShell});
  final StatefulNavigationShell navigationShell;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final currentIndex = navigationShell.currentIndex;

    return Scaffold(
      body: Row(
        children: [
          NavigationRail(
            selectedIndex: currentIndex,
            onDestinationSelected: (index) {
              AppLogger.debug(
                'Side nav tapped: index=$index',
                tag: AppLogTags.mainShellPage,
              );
              navigationShell.goBranch(
                index,
                initialLocation: index == currentIndex,
              );
            },
            labelType: NavigationRailLabelType.all,
            minWidth: AppDimensions.sideNavWidth,
            groupAlignment: 0.0,
            backgroundColor: colorScheme.surface,
            indicatorColor: colorScheme.primaryContainer,
            leading: Padding(
              padding: const EdgeInsets.symmetric(
                vertical: AppDimensions.paddingLG,
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(
                    LucideIcons.sigma,
                    size: AppDimensions.iconXL,
                    color: colorScheme.primary,
                  ),
                  const SizedBox(height: AppDimensions.paddingXXS),
                  Text(
                    'Formula\nScholar',
                    textAlign: TextAlign.center,
                    style: AppTextStyles.labelSmall.copyWith(
                      color: colorScheme.primary,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ],
              ),
            ),
            destinations: const [
              NavigationRailDestination(
                icon: Icon(LucideIcons.home),
                label: Text(AppStrings.navHome),
              ),
              NavigationRailDestination(
                icon: Icon(LucideIcons.layers),
                label: Text(AppStrings.navSubjects),
              ),
              NavigationRailDestination(
                icon: Icon(LucideIcons.gamepad2),
                label: Text(AppStrings.navPractice),
              ),
              NavigationRailDestination(
                icon: Icon(LucideIcons.bookmark),
                label: Text(AppStrings.navSaved),
              ),
              NavigationRailDestination(
                icon: Icon(LucideIcons.user),
                label: Text(AppStrings.navProfile),
              ),
            ],
          ),
          const VerticalDivider(width: 1, thickness: 1),
          Expanded(child: navigationShell),
        ],
      ),
    );
  }
}

/// Mobile/tablet shell with bottom navigation bar (original pattern).
class _MobileShell extends StatelessWidget {
  const _MobileShell({required this.navigationShell});
  final StatefulNavigationShell navigationShell;

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
  const _BottomNavBar({required this.currentIndex, required this.onTap});
  final int currentIndex;
  final ValueChanged<int> onTap;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Container(
      decoration: BoxDecoration(
        color: colorScheme.surface.withValues(
          alpha: AppDimensions.opacityNearOpaque,
        ),
        borderRadius: const BorderRadius.vertical(
          top: Radius.circular(AppDimensions.radiusShell),
        ),
        boxShadow: const [AppShadows.bottomNav],
      ),
      child: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: AppDimensions.paddingLG,
            vertical: AppDimensions.paddingSM,
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _NavItem(
                icon: LucideIcons.home,
                label: AppStrings.navHome,
                isSelected: currentIndex == 0,
                onTap: () => onTap(0),
              ),
              _NavItem(
                icon: LucideIcons.layers,
                label: AppStrings.navSubjects,
                isSelected: currentIndex == 1,
                onTap: () => onTap(1),
              ),
              _NavItem(
                icon: LucideIcons.gamepad2,
                label: AppStrings.navPractice,
                isSelected: currentIndex == 2,
                onTap: () => onTap(2),
              ),
              _NavItem(
                icon: LucideIcons.bookmark,
                label: AppStrings.navSaved,
                isSelected: currentIndex == 3,
                onTap: () => onTap(3),
              ),
              _NavItem(
                icon: LucideIcons.user,
                label: AppStrings.navProfile,
                isSelected: currentIndex == 4,
                onTap: () => onTap(4),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _NavItem extends StatelessWidget {
  const _NavItem({
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
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return MouseRegion(
      cursor: SystemMouseCursors.click,
      child: GestureDetector(
        onTap: onTap,
        behavior: HitTestBehavior.opaque,
        child: AnimatedContainer(
          duration: AppDurations.animationDefault,
          curve: AppDurations.curveEaseOutBack,
          padding: EdgeInsets.symmetric(
            horizontal: isSelected
                ? AppDimensions.paddingLG
                : AppDimensions.paddingMD,
            vertical: AppDimensions.paddingSM,
          ),
          decoration: BoxDecoration(
            color: isSelected
                ? colorScheme.primaryContainer
                : AppColors.transparent,
            borderRadius: BorderRadius.circular(AppDimensions.radiusLG),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                icon,
                size: AppDimensions.iconDefault,
                color: isSelected
                    ? colorScheme.onPrimaryContainer
                    : colorScheme.outline,
              ),
              const SizedBox(height: AppDimensions.paddingXXS),
              Text(
                label,
                style: AppTextStyles.labelSmall.copyWith(
                  color: isSelected
                      ? colorScheme.onPrimaryContainer
                      : colorScheme.outline,
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
      ),
    );
  }
}

