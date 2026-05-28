library;

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lucide_icons/lucide_icons.dart';

import '../../../../core/core.dart';

import '../cubit/curriculum_options_cubit.dart';
import '../cubit/curriculum_options_state.dart';
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
      builder: (context, curriculumState) {
        final selection = curriculumState.curriculum;
        return BlocBuilder<CurriculumOptionsCubit, CurriculumOptionsState>(
          buildWhen: (p, n) =>
              p.status != n.status ||
              p.boards != n.boards ||
              p.grades != n.grades ||
              p.errorMessage != n.errorMessage,
          builder: (context, options) {
            return Semantics(
              label:
                  'Change Active Curriculum. Currently selected: ${selection?.boardName ?? "None"} ${selection?.gradeLabel ?? ""}',
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
                  padding: const EdgeInsets.all(AppDimensions.paddingMD),
                  decoration: BoxDecoration(
                    color: colorScheme.surfaceContainerLowest.withValues(
                      alpha: 0.7,
                    ),
                    borderRadius: BorderRadius.circular(AppDimensions.radiusXL),
                    border: Border.all(
                      color: colorScheme.outlineVariant.withValues(alpha: 0.3),
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: colorScheme.shadow.withValues(alpha: 0.03),
                        blurRadius: 15,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                  child: Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(AppDimensions.paddingSM),
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            colors: [
                              colorScheme.primary.withValues(alpha: 0.15),
                              colorScheme.secondary.withValues(alpha: 0.15),
                            ],
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                          ),
                          shape: BoxShape.circle,
                        ),
                        child: Icon(
                          LucideIcons.graduationCap,
                          size: AppDimensions.iconMD,
                          color: colorScheme.primary,
                        ),
                      ),
                      const SizedBox(width: AppDimensions.paddingMD),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              context.l10n.dashboardActiveCurriculum
                                  .toUpperCase(),
                              style: AppTextStyles.labelSmall.copyWith(
                                color: colorScheme.onSurfaceVariant,
                                fontWeight: FontWeight.w800,
                                letterSpacing: 0.8,
                                fontSize: 10,
                              ),
                            ),
                            const SizedBox(height: AppDimensions.paddingXXS),
                            AnimatedSwitcher(
                              duration: AppDurations.animationFast,
                              child: Text(
                                selection != null
                                    ? '${selection.boardName} • ${selection.gradeLabel}'
                                    : context.l10n.dashboardCurriculumPending,
                                key: ValueKey(
                                  'curr_title_${selection?.boardId}_${selection?.gradeId}',
                                ),
                                style: AppTextStyles.titleSmall.copyWith(
                                  color: colorScheme.onSurface,
                                  fontWeight: FontWeight.w700,
                                ),
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(width: AppDimensions.paddingSM),
                      Container(
                        padding: const EdgeInsets.all(AppDimensions.paddingXS),
                        decoration: BoxDecoration(
                          color: colorScheme.surfaceContainerHighest.withValues(
                            alpha: 0.5,
                          ),
                          shape: BoxShape.circle,
                        ),
                        child: Icon(
                          LucideIcons.chevronRight,
                          size: AppDimensions.iconSM,
                          color: colorScheme.onSurfaceVariant,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            );
          },
        );
      },
    );
  }
}
