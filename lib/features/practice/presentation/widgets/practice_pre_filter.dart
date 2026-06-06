import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lucide_icons/lucide_icons.dart';

import '../../../../core/core.dart';

import '../cubit/practice_cubit.dart';
import '../cubit/practice_state.dart';
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
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(kToolbarHeight),
        child: GlassAppBar(
          titleWidget: Text(
            context.l10n.navPractice,
            style: AppTextStyles.headlineSmall.copyWith(
              color: colorScheme.onSurface,
              fontWeight: FontWeight.w800,
            ),
          ),
        ),
      ),
      body: SafeArea(
        child: Column(
          children: [
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
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Container(
                              width: 40,
                              height: 4,
                              margin: const EdgeInsets.only(
                                bottom: AppDimensions.paddingMD,
                              ),
                              decoration: BoxDecoration(
                                color: colorScheme.primary,
                                borderRadius: BorderRadius.circular(
                                  AppDimensions.radiusPill,
                                ),
                              ),
                            ),
                            Text(
                              context.l10n.practiceReadyTitle,
                              textAlign: TextAlign.left,
                              style: AppTextStyles.headlineLarge.copyWith(
                                color: colorScheme.onSurface,
                                fontWeight: FontWeight.w900,
                                letterSpacing: -0.5,
                              ),
                            ),
                            const SizedBox(height: AppDimensions.paddingSM),
                            Text(
                              context.l10n.practiceReadyDesc,
                              textAlign: TextAlign.left,
                              style: AppTextStyles.bodyLarge.copyWith(
                                color: colorScheme.onSurfaceVariant,
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: AppDimensions.paddingSectionLG),
                      EntranceWrapper.stagger(
                        index: 2,
                        child: _SubjectSelector(
                          practiceState: practiceState,
                          curriculumState: curriculumState,
                          onSubjectSelected: (id) =>
                              _startQuiz(context, curriculumState, id),
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
    final curriculum = curriculumState.curriculum;
    if (curriculum == null) return;
    context.read<PracticeCubit>().loadQuestions(
      curriculumKey: curriculum.curriculumKey,
      boardId: curriculum.boardId,
      gradeId: curriculum.gradeId,
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
          context.l10n.practiceChooseSubject,
          style: AppTextStyles.titleMedium.copyWith(
            fontWeight: FontWeight.w700,
          ),
        ),
        const SizedBox(height: AppDimensions.paddingMD),
        LayoutBuilder(
          builder: (context, constraints) {
            final crossAxisCount = constraints.maxWidth > 600 ? 4 : 2;
            return GridView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: crossAxisCount,
                crossAxisSpacing: AppDimensions.paddingLG,
                mainAxisSpacing: AppDimensions.paddingLG,
                childAspectRatio: 1.05,
              ),
              itemCount: practiceState.availableSubjects.length + 1,
              itemBuilder: (context, index) {
                if (index == 0) {
                  return _buildSubjectCard(
                    context: context,
                    title: context.l10n.allSubjects,
                    color: colorScheme.primary,
                    icon: LucideIcons.layers,
                    onTap: () => onSubjectSelected(null),
                  );
                }
                final subject = practiceState.availableSubjects[index - 1];
                final subjectColor = subject.colorValue != null
                    ? Color(subject.colorValue!)
                    : colorScheme.primary;
                final subjectIcon = AppIconMapper.resolve(subject.iconName);

                return _buildSubjectCard(
                  context: context,
                  title: subject.name,
                  color: subjectColor,
                  icon: subjectIcon,
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

    return AppCard(
      color: colorScheme.surfaceContainerHighest.withValues(alpha: 0.3),
      border: Border.all(color: color.withValues(alpha: 0.3), width: 1.5),
      clipBehavior: Clip.antiAlias,
      onTap: onTap,
      padding: EdgeInsets.zero,
      child: Stack(
        children: [
          Positioned(
            right: -24,
            bottom: -24,
            child: Icon(icon, size: 110, color: color.withValues(alpha: 0.06)),
          ),
          Padding(
            padding: const EdgeInsets.all(AppDimensions.paddingMD),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                AppIconCircle(
                  icon: icon,
                  backgroundColor: color.withValues(alpha: 0.15),
                  iconColor: color,
                  size: 40,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Expanded(
                      child: Text(
                        title,
                        style: AppTextStyles.titleMedium.copyWith(
                          fontWeight: FontWeight.w800,
                          color: colorScheme.onSurface,
                          height: 1.1,
                        ),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    const SizedBox(width: AppDimensions.paddingSM),
                    Container(
                      padding: const EdgeInsets.all(6),
                      decoration: BoxDecoration(
                        color: color.withValues(alpha: 0.1),
                        shape: BoxShape.circle,
                      ),
                      child: Icon(
                        LucideIcons.arrowRight,
                        size: 16,
                        color: color,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
