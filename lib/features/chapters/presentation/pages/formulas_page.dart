import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:lucide_icons/lucide_icons.dart';

import '../../../../core/core.dart';
import '../../../../shared/shared.dart';
import '../cubit/formulas_cubit.dart';
import '../cubit/formulas_state.dart';
import '../widgets/formula_app_bar_actions.dart';
import '../widgets/formula_mastery_header.dart';
import '../widgets/formula_study_card.dart';

class FormulasPage extends StatefulWidget {
  const FormulasPage({super.key});

  @override
  State<FormulasPage> createState() => _FormulasPageState();
}

class _FormulasPageState extends State<FormulasPage> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final state = GoRouterState.of(context);
      final subjectId = state.pathParameters['subjectId'] ?? '';
      final chapterId = state.pathParameters['chapterId'] ?? '';
      final chapterName = state.uri.queryParameters['name'] ?? 'Formulas';
      final curriculumKey = context
          .read<CurriculumCubit>()
          .state
          .curriculum
          ?.curriculumKey;
      if (subjectId.isNotEmpty && chapterId.isNotEmpty) {
        context.read<FormulasCubit>().loadFormulas(
          subjectId: subjectId,
          chapterId: chapterId,
          chapterName: chapterName,
          curriculumKey: curriculumKey,
        );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<FormulasCubit, FormulasState>(
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
              message: state.errorMessage,
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
          backgroundColor: colorScheme.surfaceContainerLowest,
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
                final isDesktop = constraints.maxWidth >= AppDimensions.breakpointDesktop;
                final hp = isDesktop
                    ? ((constraints.maxWidth - AppDimensions.breakpointMaxContent) / 2).clamp(
                        AppDimensions.paddingSectionLG, double.infinity,
                      )
                    : AppDimensions.paddingLG;
                return CustomScrollView(
                  slivers: [
                    SliverGlassAppBar(
                      leading: IconButton(
                        onPressed: () => context.pop(),
                        icon: Icon(LucideIcons.arrowLeft, color: colorScheme.onSurface),
                      ),
                      titleWidget: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            state.chapterName ?? AppStrings.formulasTitle,
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
                            const Padding(
                              padding: EdgeInsets.symmetric(vertical: AppDimensions.paddingXXL),
                              child: AppEmptyState(
                                icon: LucideIcons.fileQuestion,
                                title: AppStrings.noFormulasAvailable,
                                description: 'Content for this chapter is being prepared. Check back later!',
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
                          const SizedBox(height: AppDimensions.bottomNavPadding),
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
    );
  }
}
