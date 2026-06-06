import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lucide_icons/lucide_icons.dart';

import '../../../../core/core.dart';

import '../cubit/practice_cubit.dart';

/// Empty state shown when no questions are available.
class PracticeEmptyState extends StatelessWidget {
  const PracticeEmptyState({super.key, required this.photoUrl});

  final String photoUrl;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            _buildHeader(context, photoUrl),
            Expanded(
              child: Center(
                child: Padding(
                  padding: const EdgeInsets.all(AppDimensions.paddingXXL),
                  child: AppCard(
                    padding: const EdgeInsets.all(AppDimensions.paddingXXL),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Container(
                          width: AppDimensions.imageXL,
                          height: AppDimensions.imageXL,
                          decoration: BoxDecoration(
                            color: colorScheme.primaryContainer,
                            shape: BoxShape.circle,
                          ),
                          child: Icon(
                            LucideIcons.bookOpen,
                            size: AppDimensions.imageLG,
                            color: colorScheme.primary,
                          ),
                        ),
                        const SizedBox(height: AppDimensions.paddingXXL),
                        Text(
                          context.l10n.practiceNoQuestionsTitle,
                          textAlign: TextAlign.center,
                          style: AppTextStyles.headlineSmall.copyWith(
                            fontWeight: FontWeight.w800,
                          ),
                        ),
                        const SizedBox(height: AppDimensions.paddingSM),
                        Text(
                          context.l10n.practiceNoQuestionsDesc,
                          textAlign: TextAlign.center,
                          style: AppTextStyles.bodyMedium.copyWith(
                            color: colorScheme.onSurfaceVariant,
                          ),
                        ),
                        const SizedBox(height: AppDimensions.paddingXXL),
                        Wrap(
                          spacing: AppDimensions.paddingMD,
                          runSpacing: AppDimensions.paddingMD,
                          alignment: WrapAlignment.center,
                          children: [
                            ElevatedButton(
                              onPressed: () {
                                final curr = context
                                    .read<CurriculumCubit>()
                                    .state
                                    .curriculum;
                                if (curr != null) {
                                  context.read<PracticeCubit>().loadQuestions(
                                    curriculumKey: curr.curriculumKey,
                                    boardId: curr.boardId,
                                    gradeId: curr.gradeId,
                                    subjectId: context
                                        .read<PracticeCubit>()
                                        .state
                                        .subjectId,
                                  );
                                }
                              },
                              child: Text(context.l10n.retry),
                            ),
                            OutlinedButton(
                              onPressed: () =>
                                  context.read<PracticeCubit>().resetQuiz(),
                              child: Text(
                                context.l10n.browseChapters,
                              ), // Maybe we should change this text to 'Back', but I will leave it as is or change it to 'Go Back'
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader(BuildContext context, String photoUrl) {
    final colorScheme = Theme.of(context).colorScheme;
    return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: AppDimensions.paddingXXL,
        vertical: AppDimensions.paddingSM,
      ),
      child: Row(
        children: [
          IconButton(
            onPressed: () => context.read<PracticeCubit>().resetQuiz(),
            icon: const Icon(LucideIcons.x, size: AppDimensions.iconLG),
            tooltip: context.l10n.closePractice,
          ),
          const SizedBox(width: AppDimensions.paddingMD),
          Text(
            context.l10n.formulaFlow,
            style: AppTextStyles.titleLarge.copyWith(
              fontWeight: FontWeight.w800,
              letterSpacing: AppDimensions.letterSpacingTight,
              color: colorScheme.primary,
            ),
          ),
          const Spacer(),
          photoUrl.isNotEmpty
              ? AppAvatar(
                  imageUrl: photoUrl,
                  size: AppDimensions.avatarSM,
                  fallbackIcon: LucideIcons.userCircle,
                  fallbackIconColor: colorScheme.primary,
                )
              : Icon(
                  LucideIcons.userCircle,
                  size: AppDimensions.iconLG,
                  color: colorScheme.primary,
                ),
        ],
      ),
    );
  }
}
