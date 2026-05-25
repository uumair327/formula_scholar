library;

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lucide_icons/lucide_icons.dart';
import '../../../../core/core.dart';
import '../../domain/domain.dart';
import '../cubit/saved_cubit.dart';
import '../cubit/saved_state.dart';

class SavedSortControls extends StatelessWidget {
  const SavedSortControls({required this.state, super.key});

  final SavedState state;

  @override
  Widget build(BuildContext context) {
    if (state.isEmpty) {
      return const SizedBox.shrink();
    }

    final colorScheme = Theme.of(context).colorScheme;
    final directionIcon = state.sortDirection == SortDirection.asc
        ? LucideIcons.arrowUp
        : LucideIcons.arrowDown;

    return Row(
      children: [
        Expanded(
          child: SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: [
                _buildChip(
                  context,
                  label: 'Newest',
                  isSelected: state.sortByField == 'savedAt' &&
                      state.sortDirection == SortDirection.desc,
                  onSelected: () => context.read<SavedCubit>().updateSort(
                        sortByField: 'savedAt',
                        sortDirection: SortDirection.desc,
                      ),
                  colorScheme: colorScheme,
                ),
                const SizedBox(width: AppDimensions.paddingSM),
                _buildChip(
                  context,
                  label: 'Oldest',
                  isSelected: state.sortByField == 'savedAt' &&
                      state.sortDirection == SortDirection.asc,
                  onSelected: () => context.read<SavedCubit>().updateSort(
                        sortByField: 'savedAt',
                        sortDirection: SortDirection.asc,
                      ),
                  colorScheme: colorScheme,
                ),
                const SizedBox(width: AppDimensions.paddingSM),
                _buildChip(
                  context,
                  label: 'Title A-Z',
                  isSelected: state.sortByField == 'title' &&
                      state.sortDirection == SortDirection.asc,
                  onSelected: () => context.read<SavedCubit>().updateSort(
                        sortByField: 'title',
                        sortDirection: SortDirection.asc,
                      ),
                  colorScheme: colorScheme,
                ),
                const SizedBox(width: AppDimensions.paddingSM),
                _buildChip(
                  context,
                  label: 'Title Z-A',
                  isSelected: state.sortByField == 'title' &&
                      state.sortDirection == SortDirection.desc,
                  onSelected: () => context.read<SavedCubit>().updateSort(
                        sortByField: 'title',
                        sortDirection: SortDirection.desc,
                      ),
                  colorScheme: colorScheme,
                ),
              ],
            ),
          ),
        ),
        const SizedBox(width: AppDimensions.paddingSM),
        Tooltip(
          message: AppStrings.toggleSortDirection,
          child: IconButton.filled(
            onPressed: () => context.read<SavedCubit>().toggleSortDirection(),
            icon: Icon(directionIcon, size: 20),
            style: IconButton.styleFrom(
              backgroundColor: colorScheme.surfaceContainerHigh,
              foregroundColor: colorScheme.onSurface,
            ),
            tooltip: state.sortDirection == SortDirection.asc
                ? AppStrings.sortAscending
                : AppStrings.sortDescending,
          ),
        ),
      ],
    );
  }

  Widget _buildChip(
    BuildContext context, {
    required String label,
    required bool isSelected,
    required VoidCallback onSelected,
    required ColorScheme colorScheme,
  }) {
    return ChoiceChip(
      label: Text(label),
      labelStyle: AppTextStyles.labelLarge.copyWith(
        color: isSelected ? colorScheme.onPrimaryContainer : colorScheme.onSurface,
        fontWeight: isSelected ? FontWeight.w700 : FontWeight.w500,
      ),
      selected: isSelected,
      onSelected: (_) => onSelected(),
      selectedColor: colorScheme.primaryContainer,
      backgroundColor: colorScheme.surfaceContainerHigh,
      side: BorderSide.none,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(AppDimensions.radiusXL),
      ),
      showCheckmark: false,
    );
  }
}
