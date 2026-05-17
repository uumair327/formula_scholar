import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/core.dart';
import '../../../../shared/shared.dart';
import '../../../auth/auth.dart';
import '../cubit/practice_cubit.dart';
import 'practice_pre_filter_header.dart';
import 'practice_pre_filter_timed_mode.dart';

/// Pre-quiz filter screen for selecting subject and timed mode.
class PracticePreFilter extends StatelessWidget {
  const PracticePreFilter({
    super.key,
    required this.isTimed,
    required this.timedDuration,
    required this.onTimedChanged,
    required this.onDurationChanged,
  });

  final bool isTimed;
  final int? timedDuration;
  final ValueChanged<bool> onTimedChanged;
  final ValueChanged<int?> onDurationChanged;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final authState = context.watch<AuthCubit>().state;
    final photoUrl = authState.user?.photoUrl ?? '';
    final subjectState = context.watch<SubjectSelectionCubit>().state;
    final curriculumState = context.watch<CurriculumCubit>().state;

    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            PreFilterHeader(photoUrl: photoUrl),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(AppDimensions.paddingXXL),
                child: SingleChildScrollView(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Text(
                        AppStrings.practiceReadyTitle,
                        textAlign: TextAlign.center,
                        style: AppTextStyles.headlineSmall.copyWith(
                          color: colorScheme.onSurface,
                          fontWeight: FontWeight.w800,
                        ),
                      ),
                      const SizedBox(height: AppDimensions.paddingLG),
                      Text(
                        AppStrings.practiceReadyDesc,
                        textAlign: TextAlign.center,
                        style: AppTextStyles.bodyLarge.copyWith(
                          color: colorScheme.onSurfaceVariant,
                        ),
                      ),
                      const SizedBox(height: AppDimensions.paddingXXL),
                      _SubjectSelector(
                        subjectState: subjectState,
                        curriculumState: curriculumState,
                        onSubjectSelected: (id) => _startQuiz(
                          context, curriculumState, id,
                        ),
                      ),
                      const SizedBox(height: AppDimensions.paddingLG),
                      PreFilterTimedModeCard(
                        isTimed: isTimed,
                        timedDuration: timedDuration,
                        onTimedChanged: onTimedChanged,
                        onDurationChanged: onDurationChanged,
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _startQuiz(
    BuildContext context,
    CurriculumState curriculumState,
    String? subjectId,
  ) {
    if (!curriculumState.hasSelection) return;
    context.read<PracticeCubit>().loadQuestions(
      boardId: curriculumState.boardId!,
      gradeId: curriculumState.gradeId!,
      subjectId: subjectId,
      timedMode: isTimed,
      durationSeconds: timedDuration,
    );
  }
}

class _SubjectSelector extends StatelessWidget {
  const _SubjectSelector({
    required this.subjectState,
    required this.curriculumState,
    required this.onSubjectSelected,
  });

  final SubjectSelectionState subjectState;
  final CurriculumState curriculumState;
  final ValueChanged<String?> onSubjectSelected;

  @override
  Widget build(BuildContext context) {
    return AppCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text(
            AppStrings.practiceChooseSubject,
            style: AppTextStyles.titleMedium,
          ),
          const SizedBox(height: AppDimensions.paddingMD),
          Wrap(
            spacing: AppDimensions.paddingSM,
            runSpacing: AppDimensions.paddingSM,
            children: [
              ChoiceChip(
                label: const Text(AppStrings.allSubjects),
                selected: true,
                onSelected: (_) => onSubjectSelected(null),
              ),
              ...subjectState.availableSubjects.map((subject) {
                return ChoiceChip(
                  label: Text(subject.name),
                  selected: false,
                  onSelected: (_) => onSubjectSelected(subject.category),
                );
              }),
            ],
          ),
        ],
      ),
    );
  }
}
