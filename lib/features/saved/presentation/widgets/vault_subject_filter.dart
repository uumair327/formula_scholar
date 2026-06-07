library;

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/core.dart';
import '../cubit/saved_cubit.dart';
import '../cubit/saved_state.dart';

/// Horizontal scrollable filter chips for subject-based vault filtering.
class VaultSubjectFilter extends StatelessWidget {
  const VaultSubjectFilter({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<SavedCubit, SavedState>(
      buildWhen: (prev, curr) =>
          prev.availableSubjects != curr.availableSubjects ||
          prev.selectedSubjectFilter != curr.selectedSubjectFilter,
      builder: (context, state) {
        final subjects = state.availableSubjects.toList()..sort();
        if (subjects.isEmpty) {
          return const SizedBox.shrink();
        }

        final colorScheme = Theme.of(context).colorScheme;
        final cubit = context.read<SavedCubit>();
        final selected = state.selectedSubjectFilter;

        return SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          clipBehavior: Clip.none,
          child: Row(
            children: [
              _buildChip(
                context,
                label: context.l10n.vaultFilterAll,
                isSelected: selected == null,
                onSelected: () => cubit.setSubjectFilter(null),
                colorScheme: colorScheme,
              ),
              ...subjects.map((subject) {
                final formulaCount = state.bookmarks
                    .where((b) => b.subject == subject)
                    .length;
                final chapterCount = state.chapters
                    .where((c) => c.subjectName == subject)
                    .length;
                final totalCount = formulaCount + chapterCount;

                return Padding(
                  padding: const EdgeInsetsDirectional.only(
                    start: AppDimensions.paddingSM,
                  ),
                  child: _buildChip(
                    context,
                    label: '$subject ($totalCount)',
                    isSelected: selected == subject,
                    onSelected: () => cubit.setSubjectFilter(subject),
                    colorScheme: colorScheme,
                  ),
                );
              }),
            ],
          ),
        );
      },
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
      labelStyle: AppTextStyles.labelMedium.copyWith(
        color: isSelected
            ? colorScheme.onPrimaryContainer
            : colorScheme.onSurfaceVariant,
        fontWeight: isSelected ? FontWeight.w700 : FontWeight.w500,
      ),
      selected: isSelected,
      onSelected: (_) => onSelected(),
      selectedColor: colorScheme.primaryContainer,
      backgroundColor: colorScheme.surfaceContainerHighest,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(AppDimensions.radiusLG),
      ),
      showCheckmark: false,
    );
  }
}
