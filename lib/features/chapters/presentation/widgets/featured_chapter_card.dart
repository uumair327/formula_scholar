import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:lucide_icons/lucide_icons.dart';

import '../../../../core/core.dart';
import '../../domain/domain.dart';
import '../cubit/chapters_cubit.dart';

class FeaturedChapterCard extends StatelessWidget {
  const FeaturedChapterCard({
    super.key,
    required this.chapter,
    required this.subjectId,
  });

  final Chapter chapter;
  final String subjectId;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final ctaText = chapter.progressPercent > 0
        ? context.l10n.continueLearning
        : context.l10n.startNow;

    return AppCard(
      onTap: () => _navigateToFormulas(context, ctaText),
      padding: const EdgeInsets.all(AppDimensions.paddingXXL),
      border: Border.all(
        color: colorScheme.outlineVariant.withValues(alpha: 0.5),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              AppIconCircle(
                icon: LucideIcons.triangle,
                size: AppDimensions.avatarXL,
                backgroundColor: colorScheme.primaryContainer,
                iconColor: colorScheme.primary,
                iconSize: AppDimensions.iconXL,
                borderRadius: AppDimensions.radiusLG,
              ),
              Row(
                children: [
                  Padding(
                    padding: const EdgeInsetsDirectional.only(
                      end: AppDimensions.paddingSM,
                    ),
                    child: IconButton(
                      padding: EdgeInsets.zero,
                      constraints: const BoxConstraints(),
                      onPressed: _toggleBookmark(context),
                      icon: Icon(
                        chapter.isSaved ? Icons.bookmark : LucideIcons.bookmark,
                        size: AppDimensions.iconMD,
                        color: chapter.isSaved
                            ? colorScheme.primary
                            : colorScheme.outline,
                      ),
                      tooltip: chapter.isSaved
                          ? context.l10n.removeBookmark
                          : context.l10n.bookmarkChapter,
                    ),
                  ),
                  AppInfoChip(
                    label: context.l10n.percentDone(
                      chapter.progressPercent.toInt(),
                    ),
                    backgroundColor: colorScheme.tertiaryContainer,
                    textColor: colorScheme.onTertiaryContainer,
                    textStyle: AppTextStyles.bodySmall.copyWith(
                      color: colorScheme.onTertiaryContainer,
                      fontWeight: FontWeight.w700,
                    ),
                    horizontalPadding: AppDimensions.progressBarLG,
                    verticalPadding: AppDimensions.chipPaddingVertical,
                  ),
                ],
              ),
            ],
          ),
          const SizedBox(height: AppDimensions.paddingXL),
          Text(
            chapter.name,
            style: AppTextStyles.headlineMedium.copyWith(
              color: colorScheme.onSurface,
            ),
          ),
          const SizedBox(height: AppDimensions.paddingSM),
          Text(
            chapter.subtitle,
            style: AppTextStyles.bodySmall.copyWith(
              color: colorScheme.onSurfaceVariant,
              height: AppDimensions.lineHeightDefault,
            ),
          ),
          const SizedBox(height: AppDimensions.paddingXL),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                context.l10n.completedOfFormulas(
                  chapter.completedFormulas,
                  chapter.totalFormulas,
                ),
                style: AppTextStyles.bodySmall.copyWith(
                  color: colorScheme.outline,
                  fontWeight: FontWeight.w700,
                ),
              ),
              Text(
                chapter.progressPercent > 70
                    ? context.l10n.nearlyThere
                    : chapter.progressPercent > 30
                    ? context.l10n.keepGoing
                    : context.l10n.justStarted,
                style: AppTextStyles.bodySmall.copyWith(
                  color: colorScheme.primary,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ],
          ),
          const SizedBox(height: AppDimensions.paddingSM),
          ProgressBar(
            percentage: chapter.progressPercent,
            height: AppDimensions.progressBarMD,
            backgroundColor: colorScheme.secondaryContainer.withValues(
              alpha: AppDimensions.opacityLight,
            ),
          ),
          const SizedBox(height: AppDimensions.paddingXXL),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton.icon(
              onPressed: () => _navigateToFormulas(context, ctaText),
              icon: Text(ctaText),
              label: const Icon(
                LucideIcons.arrowRight,
                size: AppDimensions.iconMD,
              ),
              style: ElevatedButton.styleFrom(
                backgroundColor: colorScheme.primary,
                foregroundColor: colorScheme.onPrimary,
                padding: const EdgeInsets.symmetric(
                  vertical: AppDimensions.paddingLG,
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(AppDimensions.radiusXXL),
                ),
                textStyle: AppTextStyles.labelLarge,
              ),
            ),
          ),
        ],
      ),
    );
  }

  VoidCallback _toggleBookmark(BuildContext context) => () {
    final subjectName =
        context.read<SubjectSelectionCubit>().state.subject?.name ??
        context.l10n.unknownSubject;
    final curriculumKey = context
        .read<CurriculumCubit>()
        .state
        .curriculum
        ?.curriculumKey;
    if (curriculumKey == null || curriculumKey.isEmpty) return;
    context.read<ChaptersCubit>().toggleChapterBookmark(
      chapter,
      subjectName,
      curriculumKey: curriculumKey,
    );
  };

  void _navigateToFormulas(BuildContext context, String ctaText) {
    final chaptersCubit = context.read<ChaptersCubit>();
    final curriculumKey = context
        .read<CurriculumCubit>()
        .state
        .curriculum
        ?.curriculumKey;
    context
        .pushNamed(
          AppRoutes.formulaDetailName,
          pathParameters: {'subjectId': subjectId, 'chapterId': chapter.id},
          queryParameters: {'name': chapter.name},
        )
        .then((_) {
          if (curriculumKey == null || curriculumKey.isEmpty) return;
          chaptersCubit.loadChapters(
            subjectId,
            curriculumKey: curriculumKey,
            searchQuery: chaptersCubit.state.searchQuery,
            sortBy: chaptersCubit.state.sortBy,
            sortDesc: chaptersCubit.state.sortDesc,
            forceReload: true,
          );
        });
  }
}
