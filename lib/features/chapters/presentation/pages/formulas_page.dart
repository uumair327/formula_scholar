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
          prev.status != curr.status || prev.formulas != curr.formulas,
      builder: (context, state) {
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
                  context.read<FormulasCubit>().loadFormulas(
                    subjectId: state.subjectId!,
                    chapterId: state.chapterId!,
                    chapterName: state.chapterName,
                  );
                }
              },
            ),
          );
        }

        return Scaffold(
          backgroundColor: AppColors.surfaceContainerLowest,
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
                    _buildProgressHeader(state),
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
    return SliverAppBar(
      floating: true,
      snap: true,
      backgroundColor: AppColors.surfaceContainerLowest.withValues(
        alpha: AppDimensions.opacityAppBar,
      ),
      surfaceTintColor: AppColors.transparent,
      leading: IconButton(
        onPressed: () => context.pop(),
        icon: const Icon(LucideIcons.arrowLeft, color: AppColors.onSurface),
      ),
      title: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            state.chapterName ?? 'Formulas',
            style: AppTextStyles.headlineSmall.copyWith(
              color: AppColors.onPrimaryFixedVariant,
            ),
          ),
          Row(
            children: [
              Text(
                'CHAPTER',
                style: AppTextStyles.overline.copyWith(
                  color: AppColors.outline,
                  fontSize: AppDimensions.fontSizeXS,
                ),
              ),
              const Icon(
                LucideIcons.chevronRight,
                size: AppDimensions.iconXS,
                color: AppColors.slate400,
              ),
              Text(
                'FORMULAS',
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
        AppIconCircle(
          icon: LucideIcons.bookmark,
          size: AppDimensions.avatarMD,
          backgroundColor: AppColors.primaryFixed,
          iconColor: AppColors.primary,
          iconSize: AppDimensions.iconMD,
          borderRadius: AppDimensions.radiusMD,
        ),
        const SizedBox(width: AppDimensions.paddingLG),
      ],
    );
  }

  // ──────────────────────── Progress Header ─────────────────────

  Widget _buildProgressHeader(FormulasState state) {
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
                    state.chapterName ?? 'Chapter',
                    style: AppTextStyles.headlineMedium.copyWith(
                      color: AppColors.white,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                  const SizedBox(height: AppDimensions.paddingXS),
                  Text(
                    '${state.masteredCount} of ${state.totalCount} formulas mastered',
                    style: AppTextStyles.bodySmall.copyWith(
                      color: AppColors.blue50,
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
                  color: AppColors.white.withValues(
                    alpha: AppDimensions.opacitySubtle,
                  ),
                  borderRadius: BorderRadius.circular(AppDimensions.radiusXXL),
                ),
                child: Text(
                  '${state.progressPercent.toInt()}%',
                  style: AppTextStyles.titleLarge.copyWith(
                    color: AppColors.white,
                    fontWeight: FontWeight.w800,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: AppDimensions.paddingLG),
          ProgressBar(
            percentage: state.progressPercent,
            barColor: AppColors.white,
            backgroundColor: AppColors.white.withValues(
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
  final Formula formula;
  final int index;

  const _FormulaCard({required this.formula, required this.index});

  @override
  Widget build(BuildContext context) {
    return AppCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              AppIconCircle(
                icon: formula.isMastered
                    ? LucideIcons.checkCircle
                    : LucideIcons.circle,
                size: AppDimensions.avatarLG,
                backgroundColor: formula.isMastered
                    ? AppColors.secondaryFixed
                    : AppColors.surfaceContainerHighest,
                iconColor: formula.isMastered
                    ? AppColors.secondary
                    : AppColors.onSurfaceVariant,
                iconSize: AppDimensions.iconLG,
                borderRadius: AppDimensions.radiusMD,
              ),
              const SizedBox(width: AppDimensions.paddingLG),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      formula.title,
                      style: AppTextStyles.titleLarge.copyWith(
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    if (formula.isMastered)
                      Text(
                        'MASTERED',
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
                      'Unknown Subject';
                  context.read<FormulasCubit>().toggleBookmark(
                    formula,
                    subjectName,
                  );
                },
                icon: Icon(
                  formula.isBookmarked ? Icons.bookmark : LucideIcons.bookmark,
                  size: AppDimensions.iconMD,
                  color: formula.isBookmarked
                      ? AppColors.primary
                      : AppColors.outline,
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
              color: AppColors.surfaceContainerLow,
              borderRadius: BorderRadius.circular(AppDimensions.radiusMD),
              border: Border.all(
                color: AppColors.surfaceContainerHigh,
                width: 1,
              ),
            ),
            child: Center(
              child: Math.tex(
                formula.latex,
                textStyle: AppTextStyles.headlineSmall.copyWith(
                  color: AppColors.onSurface,
                ),
              ),
            ),
          ),
          const SizedBox(height: AppDimensions.paddingMD),
          Text(
            formula.description,
            style: AppTextStyles.bodySmall.copyWith(
              color: AppColors.onSurfaceVariant,
              height: AppDimensions.lineHeightRelaxed,
            ),
          ),
        ],
      ),
    );
  }
}
