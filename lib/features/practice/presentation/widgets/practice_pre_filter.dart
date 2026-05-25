import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/core.dart';
import '../../../../shared/shared.dart';
import '../cubit/practice_cubit.dart';
import '../cubit/practice_state.dart';
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
    final practiceState = context.select<PracticeCubit, PracticeState>(
      (c) => c.state,
    );
    final curriculumState = context.select<CurriculumCubit, CurriculumState>(
      (c) => c.state,
    );

    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            const PreFilterHeader(),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(AppDimensions.paddingXXL),
                child: SingleChildScrollView(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      EntranceWrapper.stagger(
                        index: 0,
                        child: Text(
                          AppStrings.practiceReadyTitle,
                          textAlign: TextAlign.center,
                          style: AppTextStyles.headlineSmall.copyWith(
                            color: colorScheme.onSurface,
                            fontWeight: FontWeight.w800,
                          ),
                        ),
                      ),
                      const SizedBox(height: AppDimensions.paddingLG),
                      EntranceWrapper.stagger(
                        index: 1,
                        child: Text(
                          AppStrings.practiceReadyDesc,
                          textAlign: TextAlign.center,
                          style: AppTextStyles.bodyLarge.copyWith(
                            color: colorScheme.onSurfaceVariant,
                          ),
                        ),
                      ),
                      const SizedBox(height: AppDimensions.paddingXXL),
                      EntranceWrapper.stagger(
                        index: 2,
                        child: _SubjectSelector(
                          practiceState: practiceState,
                          curriculumState: curriculumState,
                          onSubjectSelected: (id) => _startQuiz(
                            context,
                            curriculumState,
                            id,
                          ),
                        ),
                      ),
                      const SizedBox(height: AppDimensions.paddingLG),
                      EntranceWrapper.stagger(
                        index: 3,
                        child: PreFilterTimedModeCard(
                          isTimed: isTimed,
                          timedDuration: timedDuration,
                          onTimedChanged: onTimedChanged,
                          onDurationChanged: onDurationChanged,
                        ),
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
    required this.practiceState,
    required this.curriculumState,
    required this.onSubjectSelected,
  });

  final PracticeState practiceState;
  final CurriculumState curriculumState;
  final ValueChanged<String?> onSubjectSelected;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Text(
          AppStrings.practiceChooseSubject,
          style: AppTextStyles.titleMedium.copyWith(
            fontWeight: FontWeight.w700,
          ),
        ),
        const SizedBox(height: AppDimensions.paddingMD),
        LayoutBuilder(
          builder: (context, constraints) {
            // Determine column count based on available width
            final crossAxisCount = constraints.maxWidth > 600 ? 3 : 2;
            return GridView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: crossAxisCount,
                crossAxisSpacing: AppDimensions.paddingSM,
                mainAxisSpacing: AppDimensions.paddingSM,
                childAspectRatio: 2.5,
              ),
              itemCount: practiceState.availableSubjects.length + 1,
              itemBuilder: (context, index) {
                if (index == 0) {
                  return _buildSubjectCard(
                    context: context,
                    title: AppStrings.allSubjects,
                    color: colorScheme.primary,
                    icon: Icons.all_inclusive,
                    onTap: () => onSubjectSelected(null),
                  );
                }
                final subject = practiceState.availableSubjects[index - 1];
                final colors = [
                  Colors.blue,
                  Colors.red,
                  Colors.green,
                  Colors.orange,
                  Colors.purple,
                  Colors.teal,
                ];
                final subjectColor = colors[subject.id.hashCode % colors.length];

                return _buildSubjectCard(
                  context: context,
                  title: subject.name,
                  color: subjectColor,
                  icon: Icons.book_outlined,
                  onTap: () => onSubjectSelected(subject.id),
                );
              },
            );
          },
        ),
      ],
    );
  }

  Widget _buildSubjectCard({
    required BuildContext context,
    required String title,
    required Color color,
    required IconData icon,
    required VoidCallback onTap,
  }) {
    final colorScheme = Theme.of(context).colorScheme;
    
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: () {
          HapticsHelper.lightImpact();
          onTap();
        },
        borderRadius: BorderRadius.circular(AppDimensions.radiusLG),
        child: Container(
          decoration: BoxDecoration(
            color: colorScheme.surface,
            borderRadius: BorderRadius.circular(AppDimensions.radiusLG),
            border: Border.all(
              color: color.withValues(alpha: 0.3),
              width: 1.5,
            ),
            boxShadow: [
              BoxShadow(
                color: color.withValues(alpha: 0.05),
                blurRadius: 10,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          padding: const EdgeInsets.symmetric(
            horizontal: AppDimensions.paddingSM,
            vertical: AppDimensions.paddingXS,
          ),
          child: Row(
            children: [
              AppIconCircle(
                icon: icon,
                backgroundColor: color.withValues(alpha: 0.1),
                iconColor: color,
                size: 32,
              ),
              const SizedBox(width: AppDimensions.paddingSM),
              Expanded(
                child: Text(
                  title,
                  style: AppTextStyles.labelMedium.copyWith(
                    fontWeight: FontWeight.w700,
                  ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
