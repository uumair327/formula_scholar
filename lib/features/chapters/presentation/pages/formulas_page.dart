import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:lucide_icons/lucide_icons.dart';

import '../../../../core/core.dart';

import '../cubit/formulas_cubit.dart';
import '../cubit/formulas_state.dart';
import '../widgets/formula_app_bar_actions.dart';
import '../widgets/formula_mastery_header.dart';
import '../widgets/formula_study_card.dart';

class FormulasPage extends StatelessWidget {
  const FormulasPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocListener<SubjectSelectionCubit, SubjectSelectionState>(
      listenWhen: (prev, curr) => prev.subject != null && curr.subject == null,
      listener: (context, state) {
        if (context.mounted) {
          context.pop();
        }
      },
      child: BlocBuilder<FormulasCubit, FormulasState>(
        buildWhen: (prev, curr) =>
            prev.status != curr.status ||
            prev.formulas != curr.formulas ||
            prev.isChapterSaved != curr.isChapterSaved,
        builder: (context, state) {
          final colorScheme = Theme.of(context).colorScheme;

          if (state.status == FormulasStatus.loading ||
              state.status == FormulasStatus.initial) {
            return const Scaffold(body: FormulasShimmer());
          }

          if (state.status == FormulasStatus.error) {
            return Scaffold(
              body: AppErrorState(
                message: context.localizedError(fallback: state.errorMessage),
                onRetry: () {
                  if (state.subjectId != null && state.chapterId != null) {
                    final curriculumKey = context
                        .read<CurriculumCubit>()
                        .state
                        .curriculum
                        ?.curriculumKey;
                    context.read<FormulasCubit>().loadFormulas(
                      subjectId: state.subjectId!,
                      chapterId: state.chapterId!,
                      chapterName: state.chapterName,
                      curriculumKey: curriculumKey,
                    );
                  }
                },
              ),
            );
          }

          return Scaffold(
            body: RefreshIndicator(
              onRefresh: () async {
                if (state.subjectId != null && state.chapterId != null) {
                  final curriculumKey = context
                      .read<CurriculumCubit>()
                      .state
                      .curriculum
                      ?.curriculumKey;
                  await context.read<FormulasCubit>().loadFormulas(
                    subjectId: state.subjectId!,
                    chapterId: state.chapterId!,
                    chapterName: state.chapterName,
                    curriculumKey: curriculumKey,
                  );
                }
              },
              child: LayoutBuilder(
                builder: (context, constraints) {
                  final isDesktop =
                      constraints.maxWidth >= AppDimensions.breakpointDesktop;
                  final hp = isDesktop
                      ? ((constraints.maxWidth -
                                    AppDimensions.breakpointMaxContent) /
                                2)
                            .clamp(
                              AppDimensions.paddingSectionLG,
                              double.infinity,
                            )
                      : AppDimensions.paddingLG;
                  return CustomScrollView(
                    slivers: [
                      SliverGlassAppBar(
                        leading: IconButton(
                          onPressed: () => context.pop(),
                          icon: Icon(
                            LucideIcons.arrowLeft,
                            color: colorScheme.onSurface,
                          ),
                          tooltip: MaterialLocalizations.of(
                            context,
                          ).backButtonTooltip,
                        ),
                        titleWidget: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              state.chapterName ?? context.l10n.formulasTitle,
                              style: AppTextStyles.titleLarge.copyWith(
                                color: colorScheme.onSurface,
                                fontWeight: FontWeight.w800,
                              ),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                            const SizedBox(height: AppDimensions.paddingXXS),
                            FormulaMasteryHeader(state: state),
                          ],
                        ),
                        actions: const [FormulaAppBarActions()],
                      ),
                      SliverPadding(
                        padding: EdgeInsets.symmetric(horizontal: hp),
                        sliver: SliverList(
                          delegate: SliverChildListDelegate([
                            const SizedBox(height: AppDimensions.paddingMD),
                            if (state.formulas.isEmpty)
                              Padding(
                                padding: const EdgeInsets.symmetric(
                                  vertical: AppDimensions.paddingXXL,
                                ),
                                child: AppEmptyState(
                                  icon: LucideIcons.fileQuestion,
                                  title: context.l10n.noFormulasAvailable,
                                  description:
                                      'Content for this chapter is being prepared. Check back later!',
                                ),
                              )
                            else
                              ...state.formulas.asMap().entries.map(
                                (entry) => StaggeredFadeSlide(
                                  index: entry.key,
                                  child: Padding(
                                    padding: const EdgeInsets.only(
                                      bottom: AppDimensions.paddingMD,
                                    ),
                                    child: FormulaStudyCard(
                                      formula: entry.value,
                                      index: entry.key,
                                      totalCount: state.formulas.length,
                                    ),
                                  ),
                                ),
                              ),
                            const SizedBox(
                              height: AppDimensions.bottomNavPadding,
                            ),
                          ]),
                        ),
                      ),
                    ],
                  );
                },
              ),
            ),
          );
        },
      ),
    );
  }
}
