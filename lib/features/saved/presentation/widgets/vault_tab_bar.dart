import 'package:flutter/material.dart';
import 'package:lucide_icons/lucide_icons.dart';

import '../../../../core/core.dart';

/// Available tabs in the Formula Vault screen.
enum VaultTab {
  /// Formulas / bookmarks tab.
  formulas,

  /// Chapters tab.
  chapters,

  /// Personal notes tab.
  notes,
}

/// A modern, segmented tab bar for the Formula Vault allowing users
/// to toggle seamlessly between Formulas, Chapters, and Notes.
class VaultTabBar extends StatelessWidget {
  const VaultTabBar({
    super.key,
    required this.selectedTab,
    required this.onTabChanged,
    required this.formulaCount,
    required this.chapterCount,
    required this.noteCount,
  });

  /// The currently active tab.
  final VaultTab selectedTab;

  /// Callback when a new tab is selected.
  final ValueChanged<VaultTab> onTabChanged;

  /// Number of formulas matching the current filter.
  final int formulaCount;

  /// Number of chapters matching the current filter.
  final int chapterCount;

  /// Number of notes matching the current filter.
  final int noteCount;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Container(
      padding: const EdgeInsets.all(AppDimensions.paddingXS),
      decoration: BoxDecoration(
        color: isDark
            ? colorScheme.surfaceContainerLow
            : colorScheme.surfaceContainerHighest.withValues(alpha: 0.5),
        borderRadius: BorderRadius.circular(AppDimensions.radiusXL),
        border: Border.all(
          color: colorScheme.outlineVariant.withValues(
            alpha: AppDimensions.opacityLight,
          ),
        ),
      ),
      child: LayoutBuilder(
        builder: (context, constraints) {
          final isNarrow = constraints.maxWidth < AppDimensions.breakpointCardHorizontal;

          return Row(
            children: [
              Expanded(
                child: _VaultTabItem(
                  icon: LucideIcons.bookmark,
                  label: context.l10n.vaultStatsFormulas,
                  count: formulaCount,
                  isSelected: selectedTab == VaultTab.formulas,
                  onTap: () => onTabChanged(VaultTab.formulas),
                  isNarrow: isNarrow,
                  accentColor: colorScheme.primary,
                ),
              ),
              const SizedBox(width: AppDimensions.paddingXS),
              Expanded(
                child: _VaultTabItem(
                  icon: LucideIcons.bookOpen,
                  label: context.l10n.vaultStatsChapters,
                  count: chapterCount,
                  isSelected: selectedTab == VaultTab.chapters,
                  onTap: () => onTabChanged(VaultTab.chapters),
                  isNarrow: isNarrow,
                  accentColor: colorScheme.tertiary,
                ),
              ),
              const SizedBox(width: AppDimensions.paddingXS),
              Expanded(
                child: _VaultTabItem(
                  icon: LucideIcons.stickyNote,
                  label: context.l10n.vaultStatsNotes,
                  count: noteCount,
                  isSelected: selectedTab == VaultTab.notes,
                  onTap: () => onTabChanged(VaultTab.notes),
                  isNarrow: isNarrow,
                  accentColor: colorScheme.secondary,
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}

class _VaultTabItem extends StatelessWidget {
  const _VaultTabItem({
    required this.icon,
    required this.label,
    required this.count,
    required this.isSelected,
    required this.onTap,
    required this.isNarrow,
    required this.accentColor,
  });

  final IconData icon;
  final String label;
  final int count;
  final bool isSelected;
  final VoidCallback onTap;
  final bool isNarrow;
  final Color accentColor;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final isDark = Theme.of(context).brightness == Brightness.dark;

    final selectedBg = isDark
        ? accentColor.withValues(alpha: 0.22)
        : accentColor.withValues(alpha: 0.12);

    final activeColor = isDark
        ? Color.lerp(accentColor, Colors.white, 0.2)!
        : accentColor;

    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(AppDimensions.radiusLG),
        child: AnimatedContainer(
          duration: AppDurations.animationFast,
          curve: AppDurations.curvePremium,
          padding: EdgeInsets.symmetric(
            vertical: isNarrow ? AppDimensions.paddingSM : AppDimensions.paddingMD,
            horizontal: isNarrow ? AppDimensions.paddingXS : AppDimensions.paddingSM,
          ),
          decoration: BoxDecoration(
            color: isSelected ? selectedBg : Colors.transparent,
            borderRadius: BorderRadius.circular(AppDimensions.radiusLG),
            border: isSelected
                ? Border.all(
                    color: activeColor.withValues(alpha: 0.5),
                    width: 1.5,
                  )
                : null,
            boxShadow: isSelected
                ? [
                    BoxShadow(
                      color: activeColor.withValues(alpha: 0.15),
                      blurRadius: AppDimensions.blurRadiusMD,
                      offset: const Offset(0, 2),
                    ),
                  ]
                : null,
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                icon,
                size: isNarrow ? AppDimensions.iconSM : AppDimensions.iconMD,
                color: isSelected ? activeColor : colorScheme.onSurfaceVariant,
              ),
              const SizedBox(width: AppDimensions.paddingXS),
              Flexible(
                child: Text(
                  label,
                  style: isNarrow
                      ? AppTextStyles.labelSmall.copyWith(
                          color: isSelected
                              ? activeColor
                              : colorScheme.onSurfaceVariant,
                          fontWeight: isSelected
                              ? FontWeight.w700
                              : FontWeight.w500,
                        )
                      : AppTextStyles.labelMedium.copyWith(
                          color: isSelected
                              ? activeColor
                              : colorScheme.onSurfaceVariant,
                          fontWeight: isSelected
                              ? FontWeight.w700
                              : FontWeight.w500,
                        ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              const SizedBox(width: AppDimensions.paddingXS),
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 6,
                  vertical: 2,
                ),
                decoration: BoxDecoration(
                  color: isSelected
                      ? activeColor.withValues(alpha: 0.2)
                      : colorScheme.surfaceContainerHighest,
                  borderRadius: BorderRadius.circular(AppDimensions.radiusPill),
                ),
                child: Text(
                  '$count',
                  style: TextStyle(
                    fontSize: AppDimensions.fontSizeXXSPlus,
                    fontWeight: isSelected ? FontWeight.w800 : FontWeight.w600,
                    color: isSelected ? activeColor : colorScheme.onSurfaceVariant,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
