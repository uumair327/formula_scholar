import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:lucide_icons/lucide_icons.dart';
import 'package:flutter_math_fork/flutter_math.dart';

import '../../../../core/core.dart';
import '../../../../shared/shared.dart';
import '../../../auth/auth.dart';
import '../../../flashcards/flashcards.dart';
import '../../../comparison/comparison.dart';
import '../../domain/domain.dart';
import '../cubit/formulas_cubit.dart';
import '../cubit/formulas_state.dart';
import '../widgets/formula_note_sheet.dart';

/// Formulas page — displays all formulas for a given chapter.
///
/// Renders a list of formula cards with LaTeX expressions,
/// mastery status, and progress tracking.
class FormulasPage extends StatelessWidget {
  const FormulasPage({super.key});

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
                    : AppDimensions.paddingXL;
                final isTwoColumns = isDesktop && state.formulas.length > 1;
                return CustomScrollView(
                  slivers: [
                    _buildAppBar(context, state),
                    SliverPadding(
                      padding: EdgeInsets.symmetric(horizontal: hp),
                      sliver: SliverList(
                        delegate: SliverChildListDelegate([
                          const SizedBox(height: AppDimensions.paddingLG),
                          _buildProgressHeader(context, state),
                          const SizedBox(height: AppDimensions.paddingXXL),
                          if (state.formulas.isEmpty)
                            _buildEmptyFormulasState(context)
                          else if (isTwoColumns)
                            _buildFormulaGrid(context, state)
                          else
                            ...state.formulas.asMap().entries.map(
                              (entry) => Padding(
                                padding: const EdgeInsets.only(
                                  bottom: AppDimensions.paddingLG,
                                ),
                                child: _FormulaCard(
                                  formula: entry.value,
                                  index: entry.key,
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

  Widget _buildEmptyFormulasState(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: AppDimensions.paddingXXL),
      child: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              padding: const EdgeInsets.all(AppDimensions.paddingLG),
              decoration: BoxDecoration(
                color: colorScheme.surfaceContainerHighest,
                shape: BoxShape.circle,
              ),
              child: Icon(
                LucideIcons.fileQuestion,
                size: AppDimensions.iconXL,
                color: colorScheme.onSurfaceVariant,
              ),
            ),
            const SizedBox(height: AppDimensions.paddingLG),
            Text(
              'No formulas available yet',
              style: AppTextStyles.titleMedium,
            ),
            const SizedBox(height: AppDimensions.paddingSM),
            Text(
              'Content for this chapter is being prepared. Check back later!',
              textAlign: TextAlign.center,
              style: AppTextStyles.bodyMedium.copyWith(
                color: colorScheme.onSurfaceVariant,
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ──────────────────────── App Bar ─────────────────────────────

  SliverAppBar _buildAppBar(BuildContext context, FormulasState state) {
    final colorScheme = Theme.of(context).colorScheme;

    return SliverAppBar(
      floating: true,
      snap: true,
      backgroundColor: colorScheme.surfaceContainerLowest.withValues(
        alpha: AppDimensions.opacityAppBar,
      ),
      surfaceTintColor: AppColors.transparent,
      leading: IconButton(
        onPressed: () => context.pop(),
        icon: Icon(LucideIcons.arrowLeft, color: colorScheme.onSurface),
      ),
      title: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            state.chapterName ?? AppStrings.formulasTitle,
            style: AppTextStyles.headlineSmall.copyWith(
              color: AppColors.onPrimaryFixedVariant,
            ),
          ),
          Row(
            children: [
              Text(
                AppStrings.chapterBreadcrumb,
                style: AppTextStyles.overline.copyWith(
                  color: colorScheme.outline,
                  fontSize: AppDimensions.fontSizeXS,
                ),
              ),
              Icon(
                LucideIcons.chevronRight,
                size: AppDimensions.iconXS,
                color: colorScheme.outlineVariant,
              ),
              Text(
                AppStrings.formulasBreadcrumb,
                style: AppTextStyles.overline.copyWith(
                  color: AppColors.primary,
                  fontSize: AppDimensions.fontSizeXS,
                ),
              ),
            ],
          ),
        ],
      ),
      actions: [
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
              icon: AppIconCircle(
                icon: state.isChapterSaved
                    ? Icons.bookmark
                    : LucideIcons.bookmark,
                size: AppDimensions.avatarMD,
                backgroundColor: AppColors.primaryFixed,
                iconColor: state.isChapterSaved
                    ? AppColors.primary
                    : AppColors.primary,
                iconSize: AppDimensions.iconMD,
                borderRadius: AppDimensions.radiusMD,
              ),
            );
          },
        ),
        Tooltip(
          message: 'Generate cheat sheet',
          child: IconButton(
            onPressed: () {
              context.pushNamed(AppRoutes.cheatSheetName);
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
              getIt<FlashcardsCubit>().startSession(
                cards: cards,
                userId: userId,
              );
              context.pushNamed(AppRoutes.flashcardsName);
            },
            icon: Icon(LucideIcons.wand2, color: colorScheme.outline),
          ),
        ),
        const SizedBox(width: AppDimensions.paddingSM),
      ],
    );
  }

  // ──────────────────────── Progress Header ─────────────────────

  Widget _buildProgressHeader(BuildContext context, FormulasState state) {
    final colorScheme = Theme.of(context).colorScheme;

    return Container(
      padding: const EdgeInsets.all(AppDimensions.paddingXXL),
      decoration: signatureGlowDecoration(colorScheme),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    state.chapterName ?? AppStrings.chapterLabel,
                    style: AppTextStyles.headlineMedium.copyWith(
                      color: colorScheme.onPrimary,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                  const SizedBox(height: AppDimensions.paddingXS),
                  Text(
                    AppStrings.formulasMasteredOf(
                      state.masteredCount,
                      state.totalCount,
                    ),
                    style: AppTextStyles.bodySmall.copyWith(
                      color: colorScheme.onPrimary.withValues(
                        alpha: AppDimensions.opacityHigh,
                      ),
                    ),
                  ),
                ],
              ),
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: AppDimensions.paddingLG,
                  vertical: AppDimensions.paddingSM,
                ),
                decoration: BoxDecoration(
                  color: colorScheme.onPrimary.withValues(
                    alpha: AppDimensions.opacitySubtle,
                  ),
                  borderRadius: BorderRadius.circular(AppDimensions.radiusXXL),
                ),
                child: Text(
                  '${state.progressPercent.toInt()}%',
                  style: AppTextStyles.titleLarge.copyWith(
                    color: colorScheme.onPrimary,
                    fontWeight: FontWeight.w800,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: AppDimensions.paddingLG),
          ProgressBar(
            percentage: state.progressPercent,
            barColor: colorScheme.onPrimary,
            backgroundColor: colorScheme.onPrimary.withValues(
              alpha: AppDimensions.opacitySubtle,
            ),
            height: AppDimensions.progressBarSM,
          ),
        ],
      ),
    );
  }

  Widget _buildFormulaGrid(BuildContext context, FormulasState state) {
    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        mainAxisSpacing: AppDimensions.paddingLG,
        crossAxisSpacing: AppDimensions.paddingLG,
        childAspectRatio: 1.4,
      ),
      itemCount: state.formulas.length,
      itemBuilder: (context, index) {
        return _FormulaCard(
          formula: state.formulas[index],
          index: index,
        );
      },
    );
  }
}

// ═══════════════════════════════════════════════════════════════════
//  PRIVATE WIDGET COMPONENTS
// ═══════════════════════════════════════════════════════════════════

/// A single formula card with LaTeX preview, title, and mastery status.
class _FormulaCard extends StatelessWidget {
  const _FormulaCard({required this.formula, required this.index});

  final Formula formula;
  final int index;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return AppCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              IconButton(
                onPressed: () {
                  context.read<FormulasCubit>().toggleMastery(formula);
                },
                icon: AppIconCircle(
                  icon: formula.isMastered
                      ? LucideIcons.checkCircle
                      : LucideIcons.circle,
                  size: AppDimensions.avatarLG,
                  backgroundColor: formula.isMastered
                      ? AppColors.secondaryFixed
                      : colorScheme.surfaceContainerHighest,
                  iconColor: formula.isMastered
                      ? AppColors.secondary
                      : colorScheme.onSurfaceVariant,
                  iconSize: AppDimensions.iconLG,
                  borderRadius: AppDimensions.radiusMD,
                ),
              ),
              const SizedBox(width: AppDimensions.paddingLG),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Flexible(
                          child: Text(
                            formula.title,
                            style: AppTextStyles.titleLarge.copyWith(
                              fontWeight: FontWeight.w700,
                            ),
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                        if (formula.canonicalFormulaId != null &&
                            formula.canonicalFormulaId!.isNotEmpty) ...[
                          Tooltip(
                            message:
                                'Canonical Formula: Linked to global library',
                            child: Icon(
                              LucideIcons.link,
                              size: AppDimensions.iconXS,
                              color: colorScheme.tertiary,
                            ),
                          ),
                        ],
                      ],
                    ),
                    if (formula.isMastered)
                      Text(
                        AppStrings.masteredLabel,
                        style: AppTextStyles.overline.copyWith(
                          color: AppColors.secondary,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                  ],
                ),
              ),
              IconButton(
                onPressed: () {
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
                icon: Icon(
                  formula.isBookmarked ? Icons.bookmark : LucideIcons.bookmark,
                  size: AppDimensions.iconMD,
                  color: formula.isBookmarked
                      ? AppColors.primary
                      : colorScheme.outline,
                ),
              ),
              IconButton(
                onPressed: () {
                  final cubit = context.read<FormulasCubit>();
                  cubit.loadFormulaNote(formula.id);
                  showModalBottomSheet(
                    context: context,
                    isScrollControlled: true,
                    builder: (_) => BlocProvider.value(
                      value: cubit,
                      child: FormulaNoteSheet(
                        formulaId: formula.id,
                        formulaTitle: formula.title,
                      ),
                    ),
                  );
                },
                icon: Icon(
                  LucideIcons.stickyNote,
                  size: AppDimensions.iconMD,
                  color: colorScheme.outline,
                ),
                tooltip: 'Notes',
              ),
              IconButton(
                onPressed: () {
                  final formulasCubit = context.read<FormulasCubit>();
                  final allFormulas = formulasCubit.state.formulas;
                  final otherFormulas = allFormulas
                      .where((f) => f.id != formula.id)
                      .toList();
                  if (otherFormulas.isEmpty) return;

                  showModalBottomSheet(
                    context: context,
                    builder: (sheetContext) {
                      return _CompareFormulaSheet(
                        sourceFormula: formula,
                        formulas: otherFormulas,
                      );
                    },
                  );
                },
                icon: Icon(
                  LucideIcons.gitCompare,
                  size: AppDimensions.iconMD,
                  color: colorScheme.outline,
                ),
                tooltip: 'Compare formula',
              ),
            ],
          ),
          const SizedBox(height: AppDimensions.paddingLG),
          // LaTeX expression box
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(AppDimensions.paddingXL),
            decoration: BoxDecoration(
              color: colorScheme.surfaceContainerLow,
              borderRadius: BorderRadius.circular(AppDimensions.radiusMD),
              border: Border.all(
                color: colorScheme.surfaceContainerHigh,
                width: AppDimensions.borderWidth,
              ),
            ),
            child: Center(
              child: Math.tex(
                formula.latex,
                textStyle: AppTextStyles.headlineSmall.copyWith(
                  color: colorScheme.onSurface,
                ),
              ),
            ),
          ),
          const SizedBox(height: AppDimensions.paddingMD),
          Text(
            formula.description,
            style: AppTextStyles.bodySmall.copyWith(
              color: colorScheme.onSurfaceVariant,
              height: AppDimensions.lineHeightRelaxed,
            ),
          ),
        ],
      ),
    );
  }
}

class _CompareFormulaSheet extends StatelessWidget {
  const _CompareFormulaSheet({
    required this.sourceFormula,
    required this.formulas,
  });

  final Formula sourceFormula;
  final List<Formula> formulas;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.all(AppDimensions.paddingMD),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(LucideIcons.gitCompare, color: colorScheme.primary),
                const SizedBox(width: AppDimensions.paddingSM),
                Text(
                  'Compare "${sourceFormula.title}" with:',
                  style: AppTextStyles.titleMedium.copyWith(
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ],
            ),
            const SizedBox(height: AppDimensions.paddingMD),
            SizedBox(
              height: 200,
              child: ListView.separated(
                itemCount: formulas.length,
                separatorBuilder: (_, _) =>
                    const Divider(height: 1),
                itemBuilder: (context, index) {
                  final f = formulas[index];
                  return ListTile(
                    leading: Icon(
                      LucideIcons.fileText,
                      color: colorScheme.primary,
                    ),
                    title: Text(f.title),
                    subtitle: Text(
                      f.description,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    onTap: () {
                      getIt<ComparisonCubit>().setFormulas(sourceFormula, f);
                      context.pushNamed(AppRoutes.comparisonName);
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
