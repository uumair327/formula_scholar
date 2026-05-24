library;

import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lucide_icons/lucide_icons.dart';

import '../../../../core/core.dart';
import '../../../../shared/shared.dart';
import '../cubit/chapters_cubit.dart';
import '../cubit/chapters_state.dart';

class ChapterSortControls extends StatelessWidget {
  const ChapterSortControls({
    super.key,
    required this.state,
    required this.subjectId,
  });

  final ChaptersState state;
  final String subjectId;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final directionIcon = state.sortDesc
        ? LucideIcons.arrowDown
        : LucideIcons.arrowUp;

    void applySort(String sortBy, bool sortDesc) {
      final curriculumKey = context
          .read<CurriculumCubit>()
          .state
          .curriculum
          ?.curriculumKey;
      if (curriculumKey == null || curriculumKey.isEmpty) return;
      unawaited(
        context.read<ChaptersCubit>().loadChapters(
          subjectId,
          curriculumKey: curriculumKey,
          searchQuery: state.searchQuery,
          sortBy: sortBy,
          sortDesc: sortDesc,
        ),
      );
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Wrap(
          spacing: AppDimensions.paddingSM,
          runSpacing: AppDimensions.paddingSM,
          children: [
            ChoiceChip(
              label: const Text('Name A-Z'),
              selected: state.sortBy == 'name' && state.sortDesc == false,
              onSelected: (_) => applySort('name', false),
              selectedColor: colorScheme.primaryContainer,
            ),
            ChoiceChip(
              label: const Text('Name Z-A'),
              selected: state.sortBy == 'name' && state.sortDesc == true,
              onSelected: (_) => applySort('name', true),
              selectedColor: colorScheme.primaryContainer,
            ),
            ChoiceChip(
              label: const Text('Progress High'),
              selected:
                  state.sortBy == 'progressPercent' && state.sortDesc == true,
              onSelected: (_) => applySort('progressPercent', true),
              selectedColor: colorScheme.primaryContainer,
            ),
            ChoiceChip(
              label: const Text('Progress Low'),
              selected:
                  state.sortBy == 'progressPercent' && state.sortDesc == false,
              onSelected: (_) => applySort('progressPercent', false),
              selectedColor: colorScheme.primaryContainer,
            ),
            ChoiceChip(
              label: const Text('Most Formulas'),
              selected:
                  state.sortBy == 'totalFormulas' && state.sortDesc == true,
              onSelected: (_) => applySort('totalFormulas', true),
              selectedColor: colorScheme.primaryContainer,
            ),
            ChoiceChip(
              label: const Text('Fewest Formulas'),
              selected:
                  state.sortBy == 'totalFormulas' && state.sortDesc == false,
              onSelected: (_) => applySort('totalFormulas', false),
              selectedColor: colorScheme.primaryContainer,
            ),
          ],
        ),
        const SizedBox(height: AppDimensions.paddingSM),
        Tooltip(
          message: AppStrings.toggleSortDirection,
          child: IconButton.filled(
            onPressed: () {
              final newDesc = !state.sortDesc;
              applySort(state.sortBy, newDesc);
            },
            icon: Icon(directionIcon, size: 20),
            tooltip: state.sortDesc
                ? AppStrings.sortDescending
                : AppStrings.sortAscending,
          ),
        ),
      ],
    );
  }
}
