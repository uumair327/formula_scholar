library;

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:lucide_icons/lucide_icons.dart';

import '../../../../core/core.dart';
import '../../../onboarding/onboarding.dart';
import '../../../../shared/shared.dart';
import '../cubit/curriculum_options_cubit.dart';
import '../cubit/curriculum_options_state.dart';
import 'curriculum_badge.dart';
import 'curriculum_chip_row.dart';
import 'curriculum_error_row.dart';
import 'filter_shimmer.dart';
import 'curriculum_selection_bottom_sheet.dart';

class CurriculumFilterBar extends StatelessWidget {
  const CurriculumFilterBar({super.key});

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return BlocBuilder<CurriculumCubit, CurriculumState>(
      buildWhen: (prev, curr) =>
          prev.curriculum != curr.curriculum ||
          prev.isLoading != curr.isLoading,
      builder: (context, curriculum) {
        final selection = curriculum.curriculum;
        return BlocBuilder<CurriculumOptionsCubit, CurriculumOptionsState>(
          buildWhen: (p, n) => p.status != n.status || p.boards != n.boards || p.grades != n.grades || p.errorMessage != n.errorMessage,
          builder: (context, options) {
            final isBusy = options.status == CurriculumOptionsStatus.loading;

            return Container(
              padding: const EdgeInsets.all(AppDimensions.paddingLG),
              decoration: BoxDecoration(
                color: colorScheme.surfaceContainerLowest.withValues(alpha: 0.5),
                borderRadius: BorderRadius.circular(AppDimensions.radiusXL),
                border: Border.all(
                  color: colorScheme.outlineVariant.withValues(alpha: 0.2),
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          Container(
                            padding: const EdgeInsets.all(AppDimensions.paddingXS),
                            decoration: BoxDecoration(
                              gradient: AppColors.primaryGradientOf(context),
                              borderRadius: BorderRadius.circular(AppDimensions.radiusSM),
                            ),
                            child: const Icon(
                              LucideIcons.slidersHorizontal,
                              size: AppDimensions.iconSM,
                              color: AppColors.white,
                            ),
                          ),
                          const SizedBox(width: AppDimensions.paddingSM),
                          Text(
                            AppStrings.dashboardActiveCurriculum,
                            style: AppTextStyles.labelMedium.copyWith(
                              color: colorScheme.onSurface,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                        ],
                      ),
                      Semantics(
                        label: 'Switch board or grade',
                        button: true,
                        child: GestureDetector(
                          onTap: () {
                            HapticsHelper.lightImpact();
                            showCurriculumSelectionBottomSheet(
                              context,
                              optionsCubit: context.read<CurriculumOptionsCubit>(),
                            );
                          },
                          child: Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: AppDimensions.paddingSM,
                              vertical: AppDimensions.paddingXXS,
                            ),
                            decoration: BoxDecoration(
                              color: Colors.transparent,
                              borderRadius: BorderRadius.circular(AppDimensions.radiusXXL),
                              border: Border.all(
                                color: colorScheme.outlineVariant.withValues(alpha: 0.5),
                              ),
                            ),
                            child: Row(
                              children: [
                                Icon(
                                  LucideIcons.arrowLeftRight,
                                  size: AppDimensions.iconSM,
                                  color: colorScheme.onSurfaceVariant,
                                ),
                                const SizedBox(width: AppDimensions.paddingXXS),
                                Text(
                                  AppStrings.dashboardSwitchBoardGrade,
                                  style: AppTextStyles.labelSmall.copyWith(
                                    color: colorScheme.onSurfaceVariant,
                                    fontWeight: FontWeight.w600,
                                    fontSize: AppDimensions.fontSizeXSPlus,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: AppDimensions.paddingMD),
                  AnimatedSwitcher(
                    duration: AppDurations.animationFast,
                    child: Row(
                      key: ValueKey(
                        'badges_${selection?.boardId}_${selection?.gradeId}',
                      ),
                      children: [
                        CurriculumBadge(
                          icon: LucideIcons.layoutGrid,
                          iconColor: colorScheme.primary,
                          label: selection?.boardName ?? AppStrings.dashboardCurriculumPending,
                          isActive: true,
                          activeColor: colorScheme.primary,
                        ),
                        if (selection != null) ...[
                          const SizedBox(width: AppDimensions.paddingSM),
                          Icon(
                            Directionality.of(context) == TextDirection.rtl
                                ? LucideIcons.chevronLeft
                                : LucideIcons.chevronRight,
                            size: AppDimensions.iconSM,
                            color: colorScheme.outline,
                          ),
                          const SizedBox(width: AppDimensions.paddingSM),
                        ],
                        CurriculumBadge(
                          icon: LucideIcons.graduationCap,
                          iconColor: colorScheme.secondary,
                          label: selection?.gradeLabel ?? AppStrings.dashboardCurriculumPending,
                          isActive: true,
                          activeColor: colorScheme.secondary,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }

}
