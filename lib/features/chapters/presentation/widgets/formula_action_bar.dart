import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/core.dart';
import '../../../../shared/shared.dart';
import '../../domain/domain.dart';
import '../cubit/formulas_cubit.dart';
import 'bookmark_button.dart';
import 'mastery_toggle_button.dart';

class FormulaActionBar extends StatelessWidget {
  const FormulaActionBar({
    super.key,
    required this.formula,
  });

  final Formula formula;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(AppDimensions.paddingLG),
      child: Row(
        children: [
          Expanded(
            child: MasteryToggleButton(
              isMastered: formula.isMastered,
              onToggle: () {
                context.read<FormulasCubit>().toggleMastery(formula);
              },
            ),
          ),
          const SizedBox(width: AppDimensions.paddingMD),
          BookmarkButton(
            isBookmarked: formula.isBookmarked,
            onToggle: () {
              final subjectName =
                  context
                      .read<SubjectSelectionCubit>()
                      .state
                      .subject
                      ?.name ??
                  AppStrings.unknownSubject;
              final curriculumKey = context
                  .read<CurriculumCubit>()
                  .state
                  .curriculum
                  ?.curriculumKey;

              if (curriculumKey == null || curriculumKey.isEmpty) {
                return;
              }

              context.read<FormulasCubit>().toggleBookmark(
                formula,
                subjectName,
                curriculumKey: curriculumKey,
              );
            },
          ),
        ],
      ),
    );
  }
}
