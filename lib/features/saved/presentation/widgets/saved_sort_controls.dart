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

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Wrap(
          spacing: AppDimensions.paddingSM,
          runSpacing: AppDimensions.paddingSM,
          children: [
            ChoiceChip(
              label: const Text('Newest'),
              selected:
                  state.sortByField == 'savedAt' &&
                  state.sortDirection == SortDirection.desc,
              onSelected: (_) => context.read<SavedCubit>().updateSort(
                sortByField: 'savedAt',
                sortDirection: SortDirection.desc,
              ),
              selectedColor: colorScheme.primaryContainer,
            ),
            ChoiceChip(
              label: const Text('Oldest'),
              selected:
                  state.sortByField == 'savedAt' &&
                  state.sortDirection == SortDirection.asc,
              onSelected: (_) => context.read<SavedCubit>().updateSort(
                sortByField: 'savedAt',
                sortDirection: SortDirection.asc,
              ),
              selectedColor: colorScheme.primaryContainer,
            ),
            ChoiceChip(
              label: const Text('Title A-Z'),
              selected:
                  state.sortByField == 'title' &&
                  state.sortDirection == SortDirection.asc,
              onSelected: (_) => context.read<SavedCubit>().updateSort(
                sortByField: 'title',
                sortDirection: SortDirection.asc,
              ),
              selectedColor: colorScheme.primaryContainer,
            ),
            ChoiceChip(
              label: const Text('Title Z-A'),
              selected:
                  state.sortByField == 'title' &&
                  state.sortDirection == SortDirection.desc,
              onSelected: (_) => context.read<SavedCubit>().updateSort(
                sortByField: 'title',
                sortDirection: SortDirection.desc,
              ),
              selectedColor: colorScheme.primaryContainer,
            ),
          ],
        ),
        const SizedBox(height: AppDimensions.paddingSM),
        Tooltip(
          message: 'Toggle sort direction',
          child: IconButton.filled(
            onPressed: () => context.read<SavedCubit>().toggleSortDirection(),
            icon: Icon(directionIcon, size: 20),
            tooltip: state.sortDirection == SortDirection.asc
                ? 'Ascending'
                : 'Descending',
          ),
        ),
      ],
    );
  }
}
