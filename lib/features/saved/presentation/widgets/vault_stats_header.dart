library;

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lucide_icons/lucide_icons.dart';

import '../../../../core/core.dart';
import '../cubit/saved_cubit.dart';
import '../cubit/saved_state.dart';
import 'vault_tab_bar.dart';

/// Compact stats banner showing vault totals at a glance.
///
/// Can optionally accept [selectedTab] and [onTabSelected] to make
/// stat items interactive shortcuts to their respective tabs.
class VaultStatsHeader extends StatelessWidget {
  const VaultStatsHeader({
    super.key,
    this.selectedTab,
    this.onTabSelected,
  });

  /// Currently selected vault tab.
  final VaultTab? selectedTab;

  /// Callback when a stat item is tapped to switch tab.
  final ValueChanged<VaultTab>? onTabSelected;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return BlocBuilder<SavedCubit, SavedState>(
      buildWhen: (prev, curr) =>
          prev.totalFormulas != curr.totalFormulas ||
          prev.totalChapters != curr.totalChapters ||
          prev.totalNotes != curr.totalNotes ||
          prev.totalSubjects != curr.totalSubjects,
      builder: (context, state) {
        return AppCard(
          padding: const EdgeInsets.all(AppDimensions.paddingLG),
          child: Row(
            children: [
              _StatItem(
                icon: LucideIcons.bookmark,
                label: context.l10n.vaultStatsFormulas,
                count: state.totalFormulas,
                color: colorScheme.primary,
                isDark: isDark,
                isSelected: selectedTab == VaultTab.formulas,
                onTap: onTabSelected != null
                    ? () => onTabSelected!(VaultTab.formulas)
                    : null,
              ),
              _divider(colorScheme),
              _StatItem(
                icon: LucideIcons.bookOpen,
                label: context.l10n.vaultStatsChapters,
                count: state.totalChapters,
                color: colorScheme.tertiary,
                isDark: isDark,
                isSelected: selectedTab == VaultTab.chapters,
                onTap: onTabSelected != null
                    ? () => onTabSelected!(VaultTab.chapters)
                    : null,
              ),
              _divider(colorScheme),
              _StatItem(
                icon: LucideIcons.stickyNote,
                label: context.l10n.vaultStatsNotes,
                count: state.totalNotes,
                color: colorScheme.secondary,
                isDark: isDark,
                isSelected: selectedTab == VaultTab.notes,
                onTap: onTabSelected != null
                    ? () => onTabSelected!(VaultTab.notes)
                    : null,
              ),
              _divider(colorScheme),
              _StatItem(
                icon: LucideIcons.layers,
                label: context.l10n.vaultStatsSubjects,
                count: state.totalSubjects,
                color: colorScheme.error,
                isDark: isDark,
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _divider(ColorScheme colorScheme) {
    return Container(
      width: 1,
      height: AppDimensions.avatarMD,
      margin: const EdgeInsets.symmetric(
        horizontal: AppDimensions.paddingXS,
      ),
      color: colorScheme.outlineVariant.withValues(alpha: 0.3),
    );
  }
}

class _StatItem extends StatelessWidget {
  const _StatItem({
    required this.icon,
    required this.label,
    required this.count,
    required this.color,
    required this.isDark,
    this.isSelected = false,
    this.onTap,
  });

  final IconData icon;
  final String label;
  final int count;
  final Color color;
  final bool isDark;
  final bool isSelected;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    Widget content = Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        AnimatedContainer(
          duration: AppDurations.animationFast,
          width: AppDimensions.avatarMD,
          height: AppDimensions.avatarMD,
          decoration: BoxDecoration(
            color: isSelected
                ? color.withValues(alpha: 0.25)
                : color.withValues(alpha: 0.1),
            borderRadius: BorderRadius.circular(AppDimensions.radiusSM),
            border: isSelected
                ? Border.all(color: color, width: 2)
                : null,
          ),
          child: Icon(icon, size: AppDimensions.iconSM, color: color),
        ),
        const SizedBox(height: AppDimensions.paddingXS),
        Text(
          '$count',
          style: AppTextStyles.titleMedium.copyWith(
            fontWeight: FontWeight.w800,
            color: isSelected ? color : colorScheme.onSurface,
          ),
        ),
        Text(
          label,
          style: AppTextStyles.labelSmall.copyWith(
            color: isSelected ? color : colorScheme.onSurfaceVariant,
            fontWeight: isSelected ? FontWeight.w700 : FontWeight.w500,
          ),
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
        ),
      ],
    );

    if (onTap != null) {
      content = Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(AppDimensions.radiusSM),
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 2),
            child: content,
          ),
        ),
      );
    }

    return Expanded(child: content);
  }
}
