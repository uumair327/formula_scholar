import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:lucide_icons/lucide_icons.dart';

import '../../../../core/core.dart';
import '../../../../shared/shared.dart';
import '../../../auth/auth.dart';
import '../../../flashcards/flashcards.dart';
import '../cubit/formulas_cubit.dart';
import '../cubit/formulas_state.dart';

class FormulaAppBarActions extends StatelessWidget {
  const FormulaAppBarActions({super.key});

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Row(
      children: [
        BlocBuilder<FormulasCubit, FormulasState>(
          buildWhen: (prev, curr) => prev.isChapterSaved != curr.isChapterSaved,
          builder: (context, state) {
            return IconButton(
              onPressed: () {
                final subjectName =
                    context.read<SubjectSelectionCubit>().state.subject?.name ??
                    AppStrings.unknownSubject;
                final curriculumKey = context
                    .read<CurriculumCubit>()
                    .state
                    .curriculum
                    ?.curriculumKey;

                if (curriculumKey == null || curriculumKey.isEmpty) {
                  return;
                }

                context.read<FormulasCubit>().toggleChapterBookmark(
                  state.chapterName ?? AppStrings.chapterLabel,
                  subjectName,
                  curriculumKey: curriculumKey,
                );
              },
              icon: Icon(
                state.isChapterSaved
                    ? Icons.bookmark
                    : LucideIcons.bookmark,
                size: AppDimensions.iconMD,
                color: state.isChapterSaved
                    ? AppColors.primary
                    : colorScheme.outline,
              ),
              tooltip: state.isChapterSaved
                  ? 'Remove chapter bookmark'
                  : 'Bookmark chapter',
            );
          },
        ),
        Tooltip(
          message: 'Generate cheat sheet',
          child: IconButton(
            onPressed: () {
              context.pushNamed(
                AppRoutes.cheatSheetName,
                extra: context.read<FormulasCubit>(),
              );
            },
            icon: Icon(LucideIcons.fileText, color: colorScheme.outline),
          ),
        ),
        Tooltip(
          message: 'Study as flashcards',
          child: IconButton(
            onPressed: () {
              final allFormulas = context.read<FormulasCubit>().state.formulas;
              if (allFormulas.isEmpty) return;
              final userId =
                  context.read<AuthCubit>().state.user?.uid ?? '';
              final cards = allFormulas.map((f) => Flashcard(
                id: f.id,
                title: f.title,
                latex: f.latex,
                description: f.description,
                subjectId: '',
                subjectName: '',
                chapterId: '',
                chapterName: '',
              )).toList();
              final cubit = getIt<FlashcardsCubit>();
              cubit.startSession(
                cards: cards,
                userId: userId,
              );
              context.pushNamed(AppRoutes.flashcardsName, extra: cubit);
            },
            icon: Icon(LucideIcons.wand2, color: colorScheme.outline),
          ),
        ),
        const SizedBox(width: AppDimensions.paddingXS),
      ],
    );
  }
}
