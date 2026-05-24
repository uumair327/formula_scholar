import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:lucide_icons/lucide_icons.dart';

import '../../../../core/core.dart';
import '../../../../shared/shared.dart';
import '../../domain/domain.dart';
import '../cubit/chapters_cubit.dart';

class CompactChapterCard extends StatelessWidget {
  const CompactChapterCard({super.key, required this.chapter, required this.subjectId});

  final Chapter chapter;
  final String subjectId;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final ctaText = chapter.progressPercent > 0 ? AppStrings.continueLearning : AppStrings.startNow;

    return AppCard(
      child: Column(
        children: [
          Row(
            children: [
              AppIconCircle(
                icon: LucideIcons.bookOpen,
                size: AppDimensions.avatarLG,
                backgroundColor: chapter.isInProgress ? colorScheme.tertiaryContainer : colorScheme.surfaceContainerHighest,
                iconColor: chapter.isInProgress ? colorScheme.tertiary : colorScheme.onSurfaceVariant,
                iconSize: AppDimensions.iconLG,
                borderRadius: AppDimensions.radiusMD,
              ),
              const SizedBox(width: AppDimensions.paddingLG),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Expanded(
                          child: Text(chapter.name, style: AppTextStyles.titleLarge, maxLines: 1, overflow: TextOverflow.ellipsis),
                        ),
                        Padding(
                          padding: const EdgeInsetsDirectional.only(start: AppDimensions.paddingXS),
                          child: _BookmarkButton(chapter: chapter),
                        ),
                      ],
                    ),
                    Text(chapter.subtitle, style: AppTextStyles.bodySmall.copyWith(color: colorScheme.onSurfaceVariant),
                      maxLines: 1, overflow: TextOverflow.ellipsis),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: AppDimensions.paddingLG),
          ProgressBar(percentage: chapter.progressPercent, barColor: colorScheme.primary,
            backgroundColor: colorScheme.surfaceContainerHighest, height: AppDimensions.progressBarSM),
          const SizedBox(height: AppDimensions.paddingSM),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('${chapter.completedFormulas}/${chapter.totalFormulas} ${AppStrings.formulasLabel}',
                style: AppTextStyles.overline.copyWith(color: colorScheme.outline)),
              GestureDetector(
                onTap: () => _navigateToFormulas(context, ctaText),
                child: Text(ctaText.toUpperCase(), style: AppTextStyles.overline.copyWith(color: colorScheme.primary)),
              ),
            ],
          ),
        ],
      ),
    );
  }

  void _navigateToFormulas(BuildContext context, String ctaText) {
    final chaptersCubit = context.read<ChaptersCubit>();
    final curriculumKey = context.read<CurriculumCubit>().state.curriculum?.curriculumKey;
    context.pushNamed(
      AppRoutes.formulaDetailName,
      pathParameters: {'subjectId': subjectId, 'chapterId': chapter.id},
      queryParameters: {'name': chapter.name},
    ).then((_) {
      if (curriculumKey == null || curriculumKey.isEmpty) return;
      chaptersCubit.loadChapters(subjectId, curriculumKey: curriculumKey,
        searchQuery: chaptersCubit.state.searchQuery,
        sortBy: chaptersCubit.state.sortBy, sortDesc: chaptersCubit.state.sortDesc, forceReload: true);
    });
  }
}

class _BookmarkButton extends StatelessWidget {
  const _BookmarkButton({required this.chapter});

  final Chapter chapter;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    return IconButton(
      padding: EdgeInsets.zero,
      constraints: const BoxConstraints(),
      onPressed: () {
        final subjectName = context.read<SubjectSelectionCubit>().state.subject?.name ?? AppStrings.unknownSubject;
        final curriculumKey = context.read<CurriculumCubit>().state.curriculum?.curriculumKey;
        if (curriculumKey == null || curriculumKey.isEmpty) return;
        context.read<ChaptersCubit>().toggleChapterBookmark(chapter, subjectName, curriculumKey: curriculumKey);
      },
      icon: Icon(chapter.isSaved ? Icons.bookmark : LucideIcons.bookmark,
        size: AppDimensions.iconSM, color: chapter.isSaved ? AppColors.primary : colorScheme.outline),
    );
  }
}
