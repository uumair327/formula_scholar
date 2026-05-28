import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:lucide_icons/lucide_icons.dart';

import '../../../core/core.dart';
import '../../../l10n/l10n.dart';
import 'desktop_nav_item.dart';
import 'shell_nav_data.dart';

class DesktopShell extends StatelessWidget {
  const DesktopShell({super.key, required this.navigationShell});

  final StatefulNavigationShell navigationShell;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final currentIndex = navigationShell.currentIndex;
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final l10n = context.l10n;

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
                              l10n.appName,
                              style: AppTextStyles.titleSmall.copyWith(
                                color: colorScheme.onSurface,
                                fontWeight: FontWeight.w800,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: AppDimensions.paddingSM),
                ...navItems(context).asMap().entries.map((entry) {
                  final index = entry.key;
                  final item = entry.value;
                  return DesktopNavItem(
                    icon: item.icon,
                    label: item.label,
                    isSelected: index == currentIndex,
                    onTap: () => navigationShell.goBranch(
                      index,
                      initialLocation: index == currentIndex,
                    ),
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
