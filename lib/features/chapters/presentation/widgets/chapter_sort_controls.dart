library;

import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lucide_icons/lucide_icons.dart';

import '../../../../core/core.dart';

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

    Widget buildChoiceChip(String label, String sortValue, bool desc) {
      final isSelected = state.sortBy == sortValue && state.sortDesc == desc;
      return ChoiceChip(
        label: Text(label),
        selected: isSelected,
        onSelected: (_) => applySort(sortValue, desc),
        selectedColor: colorScheme.primaryContainer,
        backgroundColor: colorScheme.surfaceContainerHighest,
        labelStyle: AppTextStyles.labelMedium.copyWith(
          color: isSelected
              ? colorScheme.onPrimaryContainer
              : colorScheme.onSurfaceVariant,
          fontWeight: isSelected ? FontWeight.w700 : FontWeight.w500,
        ),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppDimensions.radiusLG),
        ),
        showCheckmark: false,
      );
    }

    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      clipBehavior: Clip.none,
      child: Row(
        children: [
          Tooltip(
            message: context.l10n.toggleSortDirection,
            child: IconButton.filledTonal(
              onPressed: () {
                final newDesc = !state.sortDesc;
                applySort(state.sortBy, newDesc);
              },
              icon: Icon(directionIcon, size: AppDimensions.iconSM),
              tooltip: state.sortDesc
                  ? context.l10n.sortDescending
                  : context.l10n.sortAscending,
              style: IconButton.styleFrom(
                backgroundColor: colorScheme.secondaryContainer,
                foregroundColor: colorScheme.onSecondaryContainer,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(AppDimensions.radiusLG),
                ),
              ),
            ),
          ),
          const SizedBox(width: AppDimensions.paddingMD),
          buildChoiceChip('Name A-Z', 'name', false),
          const SizedBox(width: AppDimensions.paddingSM),
          buildChoiceChip('Name Z-A', 'name', true),
          const SizedBox(width: AppDimensions.paddingSM),
          buildChoiceChip('Progress High', 'progressPercent', true),
          const SizedBox(width: AppDimensions.paddingSM),
          buildChoiceChip('Progress Low', 'progressPercent', false),
          const SizedBox(width: AppDimensions.paddingSM),
          buildChoiceChip('Most Formulas', 'totalFormulas', true),
          const SizedBox(width: AppDimensions.paddingSM),
          buildChoiceChip('Fewest Formulas', 'totalFormulas', false),
        ],
      ),
    );
  }
}
