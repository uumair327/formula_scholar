library;

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lucide_icons/lucide_icons.dart';

import '../../../../core/core.dart';
import '../cubit/saved_cubit.dart';
import '../cubit/saved_state.dart';

/// Compact stats banner showing vault totals at a glance.
class VaultStatsHeader extends StatelessWidget {
  const VaultStatsHeader({super.key});

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
              ),
              _divider(colorScheme),
              _StatItem(
                icon: LucideIcons.bookOpen,
                label: context.l10n.vaultStatsChapters,
                count: state.totalChapters,
                color: colorScheme.tertiary,
                isDark: isDark,
              ),
              _divider(colorScheme),
              _StatItem(
                icon: LucideIcons.stickyNote,
                label: context.l10n.vaultStatsNotes,
                count: state.totalNotes,
                color: colorScheme.secondary,
                isDark: isDark,
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
  });

  final IconData icon;
  final String label;
  final int count;
  final Color color;
  final bool isDark;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Expanded(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: AppDimensions.avatarMD,
            height: AppDimensions.avatarMD,
            decoration: BoxDecoration(
              color: color.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(AppDimensions.radiusSM),
            ),
            child: Icon(icon, size: AppDimensions.iconSM, color: color),
          ),
          const SizedBox(height: AppDimensions.paddingXS),
          Text(
            '$count',
            style: AppTextStyles.titleMedium.copyWith(
              fontWeight: FontWeight.w800,
              color: colorScheme.onSurface,
            ),
          ),
          Text(
            label,
            style: AppTextStyles.labelSmall.copyWith(
              color: colorScheme.onSurfaceVariant,
            ),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
        ],
      ),
    );
  }
}
