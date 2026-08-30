library;

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lucide_icons/lucide_icons.dart';

import '../../../../core/core.dart';
import '../../domain/domain.dart';
import '../cubit/saved_cubit.dart';
import '../cubit/saved_state.dart';

/// Modern, tactile sort pills for the Formula Vault.
class SavedSortControls extends StatelessWidget {
  const SavedSortControls({required this.state, super.key});

  final SavedState state;

  @override
  Widget build(BuildContext context) {
    if (state.isEmpty) {
      return const SizedBox.shrink();
    }

    final colorScheme = Theme.of(context).colorScheme;

    final sortOptions = [
      _SortOption(
        label: 'Newest',
        field: 'savedAt',
        direction: SortDirection.desc,
        icon: LucideIcons.sparkles,
      ),
      _SortOption(
        label: 'Oldest',
        field: 'savedAt',
        direction: SortDirection.asc,
        icon: LucideIcons.clock,
      ),
      _SortOption(
        label: 'Title A-Z',
        field: 'title',
        direction: SortDirection.asc,
        icon: LucideIcons.arrowDown,
      ),
      _SortOption(
        label: 'Title Z-A',
        field: 'title',
        direction: SortDirection.desc,
        icon: LucideIcons.arrowUp,
      ),
    ];

    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      physics: const BouncingScrollPhysics(),
      clipBehavior: Clip.none,
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Sort category badge indicator
          Container(
            padding: const EdgeInsets.symmetric(
              horizontal: AppDimensions.paddingMD,
              vertical: AppDimensions.paddingSM,
            ),
            decoration: BoxDecoration(
              color: colorScheme.surfaceContainerHighest.withValues(alpha: 0.35),
              borderRadius: BorderRadius.circular(AppDimensions.radiusFull),
              border: Border.all(
                color: colorScheme.outlineVariant.withValues(alpha: 0.2),
              ),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(
                  LucideIcons.arrowDown,
                  size: AppDimensions.iconXS,
                  color: colorScheme.primary,
                ),
                const SizedBox(width: AppDimensions.paddingXS),
                Text(
                  'Sort',
                  style: AppTextStyles.labelSmall.copyWith(
                    color: colorScheme.primary,
                    fontWeight: FontWeight.w700,
                    letterSpacing: 0.5,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: AppDimensions.paddingMD),
          // Sort pills
          ...sortOptions.map((opt) {
            final isSelected =
                state.sortByField == opt.field &&
                state.sortDirection == opt.direction;

            return Padding(
              padding: const EdgeInsetsDirectional.only(
                end: AppDimensions.paddingSM,
              ),
              child: _SortPill(
                label: opt.label,
                icon: opt.icon,
                isSelected: isSelected,
                onTap: () => context.read<SavedCubit>().updateSort(
                  sortByField: opt.field,
                  sortDirection: opt.direction,
                ),
              ),
            );
          }),
        ],
      ),
    );
  }
}

class _SortOption {
  const _SortOption({
    required this.label,
    required this.field,
    required this.direction,
    required this.icon,
  });

  final String label;
  final String field;
  final SortDirection direction;
  final IconData icon;
}

class _SortPill extends StatelessWidget {
  const _SortPill({
    required this.label,
    required this.icon,
    required this.isSelected,
    required this.onTap,
  });

  final String label;
  final IconData icon;
  final bool isSelected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    final bgColor = isSelected
        ? colorScheme.primary.withValues(alpha: 0.16)
        : colorScheme.surfaceContainerHighest.withValues(alpha: 0.4);

    final borderColor = isSelected
        ? colorScheme.primary.withValues(alpha: 0.8)
        : colorScheme.outlineVariant.withValues(alpha: 0.25);

    final fgColor = isSelected
        ? colorScheme.primary
        : colorScheme.onSurfaceVariant;

    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(AppDimensions.radiusFull),
        child: AnimatedContainer(
          duration: AppDurations.animationFast,
          curve: Curves.easeOutCubic,
          padding: const EdgeInsets.symmetric(
            horizontal: AppDimensions.paddingLG,
            vertical: AppDimensions.paddingSM + 1,
          ),
          decoration: BoxDecoration(
            color: bgColor,
            borderRadius: BorderRadius.circular(AppDimensions.radiusFull),
            border: Border.all(
              color: borderColor,
              width: isSelected ? 1.5 : 1,
            ),
            boxShadow: isSelected
                ? [
                    BoxShadow(
                      color: colorScheme.primary.withValues(alpha: 0.15),
                      blurRadius: 8,
                      offset: const Offset(0, 2),
                    ),
                  ]
                : null,
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                icon,
                size: AppDimensions.iconSM - 2,
                color: fgColor,
              ),
              const SizedBox(width: AppDimensions.paddingSM),
              Text(
                label,
                style: AppTextStyles.labelMedium.copyWith(
                  color: fgColor,
                  fontWeight: isSelected ? FontWeight.w700 : FontWeight.w500,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
