library;

import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lucide_icons/lucide_icons.dart';

import '../../../../core/core.dart';
import '../cubit/chapters_cubit.dart';
import '../cubit/chapters_state.dart';

/// Modern, tactile sort pills for Subject Chapters.
class ChapterSortControls extends StatelessWidget {
  const ChapterSortControls({
    super.key,
    required this.state,
    required this.subjectId,
  });

  final ChaptersState state;
  final String subjectId;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    void applySort(String sortBy, bool sortDesc) {
      final curriculumKey = context
          .read<CurriculumCubit>()
          .state
          .curriculum
          ?.curriculumKey;
      if (curriculumKey == null || curriculumKey.isEmpty) return;
      unawaited(
        context.read<ChaptersCubit>().loadChapters(
          subjectId,
          curriculumKey: curriculumKey,
          searchQuery: state.searchQuery,
          sortBy: sortBy,
          sortDesc: sortDesc,
        ),
      );
    }

    final sortOptions = [
      _ChapterSortOption(
        label: context.l10n.sortNameAZ,
        sortBy: 'name',
        sortDesc: false,
        icon: LucideIcons.arrowDown,
      ),
      _ChapterSortOption(
        label: context.l10n.sortNameZA,
        sortBy: 'name',
        sortDesc: true,
        icon: LucideIcons.arrowUp,
      ),
      _ChapterSortOption(
        label: context.l10n.sortProgressHigh,
        sortBy: 'progressPercent',
        sortDesc: true,
        icon: LucideIcons.trendingUp,
      ),
      _ChapterSortOption(
        label: context.l10n.sortProgressLow,
        sortBy: 'progressPercent',
        sortDesc: false,
        icon: LucideIcons.barChart2,
      ),
      _ChapterSortOption(
        label: context.l10n.sortMostFormulas,
        sortBy: 'totalFormulas',
        sortDesc: true,
        icon: LucideIcons.layers,
      ),
      _ChapterSortOption(
        label: context.l10n.sortFewestFormulas,
        sortBy: 'totalFormulas',
        sortDesc: false,
        icon: LucideIcons.list,
      ),
    ];

    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      physics: const BouncingScrollPhysics(),
      clipBehavior: Clip.none,
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Sort category badge indicator
          Container(
            padding: const EdgeInsets.symmetric(
              horizontal: AppDimensions.paddingMD,
              vertical: AppDimensions.paddingSM,
            ),
            decoration: BoxDecoration(
              color: colorScheme.surfaceContainerHighest.withValues(alpha: 0.35),
              borderRadius: BorderRadius.circular(AppDimensions.radiusFull),
              border: Border.all(
                color: colorScheme.outlineVariant.withValues(alpha: 0.2),
              ),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(
                  LucideIcons.arrowDown,
                  size: AppDimensions.iconXS,
                  color: colorScheme.primary,
                ),
                const SizedBox(width: AppDimensions.paddingXS),
                Text(
                  'Sort',
                  style: AppTextStyles.labelSmall.copyWith(
                    color: colorScheme.primary,
                    fontWeight: FontWeight.w700,
                    letterSpacing: 0.5,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: AppDimensions.paddingMD),

          // Sort pills
          ...sortOptions.map((opt) {
            final isSelected =
                state.sortBy == opt.sortBy && state.sortDesc == opt.sortDesc;

            return Padding(
              padding: const EdgeInsetsDirectional.only(
                end: AppDimensions.paddingSM,
              ),
              child: Material(
                color: Colors.transparent,
                child: InkWell(
                  onTap: () => applySort(opt.sortBy, opt.sortDesc),
                  borderRadius: BorderRadius.circular(AppDimensions.radiusFull),
                  child: AnimatedContainer(
                    duration: AppDurations.animationFast,
                    curve: Curves.easeOutCubic,
                    padding: const EdgeInsets.symmetric(
                      horizontal: AppDimensions.paddingLG,
                      vertical: AppDimensions.paddingSM + 1,
                    ),
                    decoration: BoxDecoration(
                      color: isSelected
                          ? colorScheme.primary.withValues(alpha: 0.16)
                          : colorScheme.surfaceContainerHighest.withValues(alpha: 0.4),
                      borderRadius: BorderRadius.circular(AppDimensions.radiusFull),
                      border: Border.all(
                        color: isSelected
                            ? colorScheme.primary.withValues(alpha: 0.8)
                            : colorScheme.outlineVariant.withValues(alpha: 0.25),
                        width: isSelected ? 1.5 : 1,
                      ),
                      boxShadow: isSelected
                          ? [
                              BoxShadow(
                                color: colorScheme.primary.withValues(alpha: 0.15),
                                blurRadius: 8,
                                offset: const Offset(0, 2),
                              ),
                            ]
                          : null,
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(
                          opt.icon,
                          size: AppDimensions.iconSM - 2,
                          color: isSelected
                              ? colorScheme.primary
                              : colorScheme.onSurfaceVariant,
                        ),
                        const SizedBox(width: AppDimensions.paddingSM),
                        Text(
                          opt.label,
                          style: AppTextStyles.labelMedium.copyWith(
                            color: isSelected
                                ? colorScheme.primary
                                : colorScheme.onSurfaceVariant,
                            fontWeight:
                                isSelected ? FontWeight.w700 : FontWeight.w500,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            );
          }),
        ],
      ),
    );
  }
}

class _ChapterSortOption {
  const _ChapterSortOption({
    required this.label,
    required this.sortBy,
    required this.sortDesc,
    required this.icon,
  });

  final String label;
  final String sortBy;
  final bool sortDesc;
  final IconData icon;
}
