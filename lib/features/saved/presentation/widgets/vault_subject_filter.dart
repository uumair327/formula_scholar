library;

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lucide_icons/lucide_icons.dart';

import '../../../../core/core.dart';
import '../cubit/saved_cubit.dart';
import '../cubit/saved_state.dart';

/// Horizontal scrollable filter pills for subject-based vault filtering.
class VaultSubjectFilter extends StatelessWidget {
  const VaultSubjectFilter({super.key});

  static IconData _getSubjectIcon(String subject) {
    final lower = subject.toLowerCase();
    if (lower.contains('physic')) return LucideIcons.atom;
    if (lower.contains('chem')) return LucideIcons.flaskConical;
    if (lower.contains('math') ||
        lower.contains('algebra') ||
        lower.contains('calculus') ||
        lower.contains('arithmetic')) {
      return LucideIcons.sigma;
    }
    return LucideIcons.bookOpen;
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<SavedCubit, SavedState>(
      buildWhen: (prev, curr) =>
          prev.availableSubjects != curr.availableSubjects ||
          prev.selectedSubjectFilter != curr.selectedSubjectFilter ||
          prev.bookmarks.length != curr.bookmarks.length ||
          prev.chapters.length != curr.chapters.length,
      builder: (context, state) {
        final subjects = state.availableSubjects.toList()..sort();
        if (subjects.isEmpty) {
          return const SizedBox.shrink();
        }

        final colorScheme = Theme.of(context).colorScheme;
        final cubit = context.read<SavedCubit>();
        final selected = state.selectedSubjectFilter;
        final totalCount = state.bookmarks.length + state.chapters.length;

        return SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          physics: const BouncingScrollPhysics(),
          clipBehavior: Clip.none,
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Filter label badge
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
                      LucideIcons.layers,
                      size: AppDimensions.iconXS,
                      color: colorScheme.secondary,
                    ),
                    const SizedBox(width: AppDimensions.paddingXS),
                    Text(
                      'Subject',
                      style: AppTextStyles.labelSmall.copyWith(
                        color: colorScheme.secondary,
                        fontWeight: FontWeight.w700,
                        letterSpacing: 0.5,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: AppDimensions.paddingMD),

              // "All" filter pill
              _SubjectPill(
                label: context.l10n.vaultFilterAll,
                icon: LucideIcons.layers,
                count: totalCount,
                isSelected: selected == null,
                onTap: () => cubit.setSubjectFilter(null),
              ),

              // Dynamic Subject pills
              ...subjects.map((subject) {
                final formulaCount = state.bookmarks
                    .where((b) => b.subject == subject)
                    .length;
                final chapterCount = state.chapters
                    .where((c) => c.subjectName == subject)
                    .length;
                final count = formulaCount + chapterCount;

                return Padding(
                  padding: const EdgeInsetsDirectional.only(
                    start: AppDimensions.paddingSM,
                  ),
                  child: _SubjectPill(
                    label: subject,
                    icon: _getSubjectIcon(subject),
                    count: count,
                    isSelected: selected == subject,
                    onTap: () => cubit.setSubjectFilter(subject),
                  ),
                );
              }),
            ],
          ),
        );
      },
    );
  }
}

class _SubjectPill extends StatelessWidget {
  const _SubjectPill({
    required this.label,
    required this.icon,
    required this.count,
    required this.isSelected,
    required this.onTap,
  });

  final String label;
  final IconData icon;
  final int count;
  final bool isSelected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    final bgColor = isSelected
        ? colorScheme.secondary.withValues(alpha: 0.16)
        : colorScheme.surfaceContainerHighest.withValues(alpha: 0.4);

    final borderColor = isSelected
        ? colorScheme.secondary.withValues(alpha: 0.8)
        : colorScheme.outlineVariant.withValues(alpha: 0.25);

    final fgColor = isSelected
        ? colorScheme.secondary
        : colorScheme.onSurfaceVariant;

    final badgeBg = isSelected
        ? colorScheme.secondary.withValues(alpha: 0.25)
        : colorScheme.surfaceContainerHighest.withValues(alpha: 0.8);

    final badgeFg = isSelected
        ? colorScheme.secondary
        : colorScheme.onSurfaceVariant;

    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(AppDimensions.radiusFull),
        child: AnimatedContainer(
          duration: AppDurations.animationFast,
          curve: Curves.easeOutCubic,
          padding: const EdgeInsetsDirectional.only(
            start: AppDimensions.paddingLG,
            end: AppDimensions.paddingMD,
            top: AppDimensions.paddingSM - 1,
            bottom: AppDimensions.paddingSM - 1,
          ),
          decoration: BoxDecoration(
            color: bgColor,
            borderRadius: BorderRadius.circular(AppDimensions.radiusFull),
            border: Border.all(
              color: borderColor,
              width: isSelected ? 1.5 : 1,
            ),
            boxShadow: isSelected
                ? [
                    BoxShadow(
                      color: colorScheme.secondary.withValues(alpha: 0.15),
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
                icon,
                size: AppDimensions.iconSM - 2,
                color: fgColor,
              ),
              const SizedBox(width: AppDimensions.paddingSM),
              Text(
                label,
                style: AppTextStyles.labelMedium.copyWith(
                  color: fgColor,
                  fontWeight: isSelected ? FontWeight.w700 : FontWeight.w500,
                ),
              ),
              const SizedBox(width: AppDimensions.paddingSM),
              // Count badge
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: AppDimensions.paddingSM - 2,
                  vertical: 2,
                ),
                decoration: BoxDecoration(
                  color: badgeBg,
                  borderRadius: BorderRadius.circular(AppDimensions.radiusFull),
                ),
                child: Text(
                  '$count',
                  style: AppTextStyles.labelSmall.copyWith(
                    color: badgeFg,
                    fontWeight: FontWeight.w700,
                    fontSize: 11,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
