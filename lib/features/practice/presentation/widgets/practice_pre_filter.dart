import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:lucide_icons/lucide_icons.dart';

import '../../../../core/core.dart';
import '../../../../shared/shared.dart';
import '../../../auth/auth.dart';
import '../cubit/practice_cubit.dart';

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
            _Header(photoUrl: photoUrl),
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
                      AppCard(
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
                                  onSelected: (_) => _startQuiz(
                                    context, curriculumState, null,
                                  ),
                                ),
                                ...subjectState.availableSubjects.map((subject) {
                                  return ChoiceChip(
                                    label: Text(subject.name),
                                    selected: false,
                                    onSelected: (_) => _startQuiz(
                                      context, curriculumState, subject.category,
                                    ),
                                  );
                                }),
                              ],
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: AppDimensions.paddingLG),
                      _TimedModeCard(
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

class _Header extends StatelessWidget {
  const _Header({required this.photoUrl});
  final String photoUrl;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: AppDimensions.paddingXXL,
        vertical: AppDimensions.paddingSM,
      ),
      child: Row(
        children: [
          GestureDetector(
            onTap: () => StatefulNavigationShell.of(context).goBranch(1),
            child: Icon(LucideIcons.x, size: AppDimensions.iconLG,
                color: colorScheme.onSurface),
          ),
          const SizedBox(width: AppDimensions.paddingMD),
          Text(
            AppStrings.formulaFlow,
            style: AppTextStyles.titleLarge.copyWith(
              fontWeight: FontWeight.w800,
              letterSpacing: AppDimensions.letterSpacingTight,
              color: colorScheme.primary,
            ),
          ),
          const Spacer(),
          AppAvatar(
            imageUrl: photoUrl,
            size: AppDimensions.avatarSM,
            fallbackIcon: LucideIcons.userCircle,
            fallbackIconColor: colorScheme.primary,
          ),
        ],
      ),
    );
  }
}

class _TimedModeCard extends StatelessWidget {
  const _TimedModeCard({
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

    return Column(
      children: [
        AppCard(
          child: Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      AppStrings.timedMode,
                      style: AppTextStyles.titleSmall.copyWith(
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    const SizedBox(height: AppDimensions.paddingXXS),
                    Text(
                      AppStrings.timedModeDesc,
                      style: AppTextStyles.bodySmall.copyWith(
                        color: colorScheme.onSurfaceVariant,
                      ),
                    ),
                  ],
                ),
              ),
              Switch(
                value: isTimed,
                onChanged: (v) {
                  onTimedChanged(v);
                  if (!v) onDurationChanged(null);
                },
              ),
            ],
          ),
        ),
        if (isTimed) ...[
          const SizedBox(height: AppDimensions.paddingSM),
          AppCard(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  AppStrings.duration,
                  style: AppTextStyles.titleSmall.copyWith(
                    fontWeight: FontWeight.w700,
                  ),
                ),
                const SizedBox(height: AppDimensions.paddingMD),
                Wrap(
                  spacing: AppDimensions.paddingSM,
                  runSpacing: AppDimensions.paddingSM,
                  children: [5, 10, 15, 30, 60].map((mins) {
                    return ChoiceChip(
                      label: Text('$mins min'),
                      selected: timedDuration == mins * 60,
                      onSelected: (_) => onDurationChanged(mins * 60),
                    );
                  }).toList(),
                ),
              ],
            ),
          ),
        ],
      ],
    );
  }
}
