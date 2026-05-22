import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:lucide_icons/lucide_icons.dart';

import '../../core/core.dart';

/// Shell page wrapping routes with a responsive navigation:
/// - **Desktop** (≥1024px): Persistent side [NavigationRail]
/// - **Mobile/Tablet** (<1024px): Premium bottom navigation bar with
///   frosted glass backdrop and animated indicator
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
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      body: Row(
        children: [
          Container(
            width: AppDimensions.sideNavWidth,
            decoration: BoxDecoration(
              color: colorScheme.surface,
              border: Border(
                right: BorderSide(
                  color: colorScheme.outlineVariant.withValues(alpha: 0.3),
                ),
              ),
            ),
            child: Column(
              children: [
                // ── Brand Header ──
                Padding(
                  padding: const EdgeInsets.symmetric(
                    vertical: AppDimensions.paddingXXL,
                    horizontal: AppDimensions.paddingLG,
                  ),
                  child: Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(AppDimensions.paddingSM),
                        decoration: BoxDecoration(
                          gradient: isDark
                              ? AppColors.darkPrimaryGradient
                              : AppColors.primaryGradient,
                          borderRadius: BorderRadius.circular(
                            AppDimensions.radiusMD,
                          ),
                        ),
                        child: const Icon(
                          LucideIcons.sigma,
                          size: AppDimensions.iconLG,
                          color: AppColors.white,
                        ),
                      ),
                      const SizedBox(width: AppDimensions.paddingMD),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Formula',
                              style: AppTextStyles.titleSmall.copyWith(
                                color: colorScheme.onSurface,
                                fontWeight: FontWeight.w800,
                              ),
                            ),
                            Text(
                              'Scholar',
                              style: AppTextStyles.labelSmall.copyWith(
                                color: colorScheme.primary,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: AppDimensions.paddingSM),
                // ── Nav Items ──
                ..._navItems.asMap().entries.map((entry) {
                  final index = entry.key;
                  final item = entry.value;
                  final selected = index == currentIndex;

                  return _DesktopNavItem(
                    icon: item.icon,
                    label: item.label,
                    isSelected: selected,
                    onTap: () {
                      AppLogger.debug(
                        'Side nav tapped: index=$index',
                        tag: AppLogTags.mainShellPage,
                      );
                      navigationShell.goBranch(
                        index,
                        initialLocation: index == currentIndex,
                      );
                    },
                  );
                }),
              ],
            ),
          ),
          Expanded(child: navigationShell),
        ],
      ),
    );
  }
}

/// Mobile/tablet shell with premium bottom navigation bar.
class _MobileShell extends StatelessWidget {
  const _MobileShell({required this.navigationShell});
  final StatefulNavigationShell navigationShell;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: navigationShell,
      extendBody: true,
      bottomNavigationBar: _GlassBottomNavBar(
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

/// Premium bottom navigation with frosted glass backdrop and
/// animated selection indicator.
class _GlassBottomNavBar extends StatelessWidget {
  const _GlassBottomNavBar({
    required this.currentIndex,
    required this.onTap,
  });
  final int currentIndex;
  final ValueChanged<int> onTap;

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return ClipRRect(
      borderRadius: const BorderRadius.vertical(
        top: Radius.circular(AppDimensions.radiusXL),
      ),
      child: BackdropFilter(
        filter: ImageFilter.blur(
          sigmaX: AppDimensions.glassBlurSigma,
          sigmaY: AppDimensions.glassBlurSigma,
        ),
        child: Container(
          decoration: BoxDecoration(
            color: isDark ? AppColors.glassDark : AppColors.glassLight,
            borderRadius: const BorderRadius.vertical(
              top: Radius.circular(AppDimensions.radiusXL),
            ),
            border: Border(
              top: BorderSide(
                color: isDark
                    ? AppColors.glassBorderDark
                    : AppColors.glassBorderLight,
              ),
            ),
          ),
          child: SafeArea(
            child: Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: AppDimensions.paddingMD,
                vertical: AppDimensions.paddingSM,
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: _navItems.asMap().entries.map((entry) {
                  return _NavItem(
                    icon: entry.value.icon,
                    label: entry.value.label,
                    isSelected: entry.key == currentIndex,
                    onTap: () => onTap(entry.key),
                  );
                }).toList(),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _NavItem extends StatefulWidget {
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
  State<_NavItem> createState() => _NavItemState();
}

class _NavItemState extends State<_NavItem>
    with SingleTickerProviderStateMixin {
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
      child: AnimatedBuilder(
        animation: _scaleAnimation,
        builder: (context, child) {
          return Transform.scale(
            scale: _scaleAnimation.value,
            child: child,
          );
        },
        child: AnimatedContainer(
          duration: AppDurations.animationDefault,
          curve: AppDurations.curvePremium,
          padding: EdgeInsets.symmetric(
            horizontal: widget.isSelected
                ? AppDimensions.paddingLG
                : AppDimensions.paddingMD,
            vertical: AppDimensions.paddingSM,
          ),
          decoration: BoxDecoration(
            gradient: widget.isSelected
                ? (isDark
                    ? AppColors.darkPrimaryGradient
                    : AppColors.primaryGradient)
                : null,
            borderRadius: BorderRadius.circular(AppDimensions.radiusLG),
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
                  fontWeight:
                      widget.isSelected ? FontWeight.w700 : FontWeight.w500,
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

/// Desktop side-nav item with hover highlight.
class _DesktopNavItem extends StatefulWidget {
  const _DesktopNavItem({
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
  State<_DesktopNavItem> createState() => _DesktopNavItemState();
}

class _DesktopNavItemState extends State<_DesktopNavItem> {
  bool _isHovered = false;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return MouseRegion(
      cursor: SystemMouseCursors.click,
      onEnter: (_) => setState(() => _isHovered = true),
      onExit: (_) => setState(() => _isHovered = false),
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
                  fontWeight:
                      widget.isSelected ? FontWeight.w700 : FontWeight.w500,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

/// Navigation item data.
class _NavItemData {
  const _NavItemData({required this.icon, required this.label});
  final IconData icon;
  final String label;
}

/// Shared nav items used by both mobile and desktop shells.
const List<_NavItemData> _navItems = [
  _NavItemData(icon: LucideIcons.home, label: AppStrings.navHome),
  _NavItemData(icon: LucideIcons.layers, label: AppStrings.navSubjects),
  _NavItemData(icon: LucideIcons.gamepad2, label: AppStrings.navPractice),
  _NavItemData(icon: LucideIcons.bookmark, label: AppStrings.navSaved),
  _NavItemData(icon: LucideIcons.user, label: AppStrings.navProfile),
];
