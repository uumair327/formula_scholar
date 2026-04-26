import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:lucide_icons/lucide_icons.dart';
import 'package:flutter_math_fork/flutter_math.dart';

import '../../../../core/core.dart';
import '../../../../shared/shared.dart';
import '../../domain/domain.dart';
import '../cubit/formulas_cubit.dart';
import '../cubit/formulas_state.dart';

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
          return const Scaffold(body: AppLoadingState());
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
          body: CustomScrollView(
            slivers: [
              _buildAppBar(context, state),
              SliverPadding(
                padding: const EdgeInsets.symmetric(
                  horizontal: AppDimensions.paddingXL,
                ),
                sliver: SliverList(
                  delegate: SliverChildListDelegate([
                    const SizedBox(height: AppDimensions.paddingLG),
                    _buildProgressHeader(context, state),
                    const SizedBox(height: AppDimensions.paddingXXL),
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
          ),
        );
      },
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
        const SizedBox(width: AppDimensions.paddingSM),
      ],
    );
  }

  // ──────────────────────── Progress Header ─────────────────────

  Widget _buildProgressHeader(BuildContext context, FormulasState state) {
    final colorScheme = Theme.of(context).colorScheme;

    return Container(
      padding: const EdgeInsets.all(AppDimensions.paddingXXL),
      decoration: const SignatureGlowDecoration(),
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
                        if (formula.canonicalFormulaId != null && formula.canonicalFormulaId!.isNotEmpty) ...[
                          const SizedBox(width: AppDimensions.paddingSM),
                          Tooltip(
                            message: 'Canonical Formula: Linked to global library',
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
