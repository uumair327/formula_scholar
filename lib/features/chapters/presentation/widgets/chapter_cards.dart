import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:lucide_icons/lucide_icons.dart';

import '../../../../core/core.dart';
import '../../../../shared/shared.dart';
import '../../domain/domain.dart';
import '../cubit/chapters_cubit.dart';

/// Featured card – highest-progress chapter, shown prominently.
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
    final ctaText = chapter.progressPercent > 0
        ? AppStrings.continueLearning
        : AppStrings.startNow;
    return AppCard(
      padding: const EdgeInsets.all(AppDimensions.paddingXXL),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const AppIconCircle(
                icon: LucideIcons.triangle,
                size: AppDimensions.avatarXL,
                backgroundColor: AppColors.primaryFixed,
                iconColor: AppColors.primary,
                iconSize: AppDimensions.iconXL,
                borderRadius: AppDimensions.radiusLG,
              ),
              Row(
                children: [
                  if (chapter.isSaved)
                    const Padding(
                      padding: EdgeInsets.only(right: AppDimensions.paddingSM),
                      child: Icon(
                        LucideIcons.bookmark,
                        size: AppDimensions.iconMD,
                        color: AppColors.primary,
                      ),
                    ),
                  AppInfoChip(
                    label: AppStrings.percentDone(
                      chapter.progressPercent.toInt(),
                    ),
                    backgroundColor: AppColors.secondaryContainer,
                    textColor: AppColors.onSecondaryContainer,
                    textStyle: AppTextStyles.bodySmall.copyWith(
                      color: AppColors.onSecondaryContainer,
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
          Text(chapter.name, style: AppTextStyles.headlineMedium),
          const SizedBox(height: AppDimensions.paddingSM),
          Text(
            chapter.subtitle,
            style: AppTextStyles.bodySmall.copyWith(
              color: AppColors.onSurfaceVariant,
              height: AppDimensions.lineHeightDefault,
            ),
          ),
          const SizedBox(height: AppDimensions.paddingXL),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                AppStrings.completedOfFormulas(
                  chapter.completedFormulas,
                  chapter.totalFormulas,
                ),
                style: AppTextStyles.bodySmall.copyWith(
                  color: AppColors.outline,
                  fontWeight: FontWeight.w700,
                ),
              ),
              Text(
                chapter.progressPercent > 70
                    ? AppStrings.nearlyThere
                    : chapter.progressPercent > 30
                    ? AppStrings.keepGoing
                    : AppStrings.justStarted,
                style: AppTextStyles.bodySmall.copyWith(
                  color: AppColors.primary,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ],
          ),
          const SizedBox(height: AppDimensions.paddingSM),
          ProgressBar(
            percentage: chapter.progressPercent,
            height: AppDimensions.progressBarMD,
            backgroundColor: AppColors.secondaryFixedDim.withValues(
              alpha: AppDimensions.opacityLight,
            ),
          ),
          const SizedBox(height: AppDimensions.paddingXXL),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton.icon(
              onPressed: () {
                final chaptersCubit = context.read<ChaptersCubit>();
                final curriculumKey =
                    context
                        .read<CurriculumCubit>()
                        .state
                        .curriculum
                        ?.curriculumKey ??
                    AppStrings.unknownCurriculum;

                context
                    .pushNamed(
                      AppRoutes.formulaDetailName,
                      pathParameters: {
                        'subjectId': subjectId,
                        'chapterId': chapter.id,
                      },
                      queryParameters: {'name': chapter.name},
                    )
                    .then((_) {
                      chaptersCubit.loadChapters(
                        subjectId,
                        curriculumKey: curriculumKey,
                        forceReload: true,
                      );
                    });
              },
              icon: Text(ctaText),
              label: const Icon(
                LucideIcons.arrowRight,
                size: AppDimensions.iconMD,
              ),
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primary,
                foregroundColor: AppColors.white,
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
}

/// Compact card – regular chapters with progress bar.
class CompactChapterCard extends StatelessWidget {
  const CompactChapterCard({
    super.key,
    required this.chapter,
    required this.subjectId,
  });

  final Chapter chapter;
  final String subjectId;

  @override
  Widget build(BuildContext context) {
    final ctaText = chapter.progressPercent > 0
        ? AppStrings.continueLearning
        : AppStrings.startNow;
    return AppCard(
      child: Column(
        children: [
          Row(
            children: [
              AppIconCircle(
                icon: LucideIcons.bookOpen,
                size: AppDimensions.avatarLG,
                backgroundColor: chapter.isInProgress
                    ? AppColors.tertiaryFixed
                    : AppColors.surfaceContainerHighest,
                iconColor: chapter.isInProgress
                    ? AppColors.tertiary
                    : AppColors.onSurfaceVariant,
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
                          child: Text(
                            chapter.name,
                            style: AppTextStyles.titleLarge,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                        if (chapter.isSaved)
                          const Padding(
                            padding: EdgeInsets.only(
                              left: AppDimensions.paddingXS,
                            ),
                            child: Icon(
                              LucideIcons.bookmark,
                              size: AppDimensions.iconSM,
                              color: AppColors.primary,
                            ),
                          ),
                      ],
                    ),
                    Text(
                      chapter.subtitle,
                      style: AppTextStyles.bodySmall.copyWith(
                        color: AppColors.onSurfaceVariant,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: AppDimensions.paddingLG),
          ProgressBar(
            percentage: chapter.progressPercent,
            barColor: AppColors.primary,
            backgroundColor: AppColors.surfaceContainerHighest,
            height: AppDimensions.progressBarSM,
          ),
          const SizedBox(height: AppDimensions.paddingSM),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                '${chapter.completedFormulas}/${chapter.totalFormulas} ${AppStrings.formulasLabel}',
                style: AppTextStyles.overline.copyWith(
                  color: AppColors.outline,
                ),
              ),
              GestureDetector(
                onTap: () {
                  final chaptersCubit = context.read<ChaptersCubit>();
                  final curriculumKey =
                      context
                          .read<CurriculumCubit>()
                          .state
                          .curriculum
                          ?.curriculumKey ??
                      AppStrings.unknownCurriculum;

                  context
                      .pushNamed(
                        AppRoutes.formulaDetailName,
                        pathParameters: {
                          'subjectId': subjectId,
                          'chapterId': chapter.id,
                        },
                        queryParameters: {'name': chapter.name},
                      )
                      .then((_) {
                        chaptersCubit.loadChapters(
                          subjectId,
                          curriculumKey: curriculumKey,
                          forceReload: true,
                        );
                      });
                },
                child: Text(
                  ctaText.toUpperCase(),
                  style: AppTextStyles.overline.copyWith(
                    color: AppColors.primary,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

/// Locked card – chapter not yet available.
class LockedChapterCard extends StatelessWidget {
  const LockedChapterCard({super.key, required this.chapter});

  final Chapter chapter;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(AppDimensions.paddingXL),
      decoration: BoxDecoration(
        color: AppColors.tertiaryContainer.withValues(
          alpha: AppDimensions.opacitySubtle,
        ),
        borderRadius: BorderRadius.circular(AppDimensions.radiusLG),
        border: Border.all(
          color: AppColors.tertiaryFixedDim.withValues(
            alpha: AppDimensions.opacityLight,
          ),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            chapter.name,
            style: AppTextStyles.labelLarge.copyWith(color: AppColors.tertiary),
          ),
          const SizedBox(height: AppDimensions.paddingXS),
          Text(
            chapter.subtitle,
            style: AppTextStyles.bodySmall.copyWith(
              color: AppColors.onTertiaryContainer.withValues(
                alpha: AppDimensions.opacityHigh,
              ),
            ),
          ),
          const SizedBox(height: AppDimensions.paddingMD),
          Row(
            children: [
              AppInfoChip(
                label: AppStrings.locked,
                backgroundColor: AppColors.white.withValues(
                  alpha: AppDimensions.opacityMediumLight,
                ),
                textColor: AppColors.tertiary,
                textStyle: AppTextStyles.overline.copyWith(
                  color: AppColors.tertiary,
                ),
              ),
              const SizedBox(width: AppDimensions.paddingSM),
              const Icon(
                LucideIcons.lock,
                size: AppDimensions.iconSM,
                color: AppColors.tertiary,
              ),
            ],
          ),
        ],
      ),
    );
  }
}
