import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:lucide_icons/lucide_icons.dart';

import '../../../../core/core.dart';
import '../../../../shared/shared.dart';
import '../../domain/domain.dart';
import '../cubit/chapters_cubit.dart';
import '../cubit/chapters_state.dart';

/// Generic chapters page – renders content for ANY subject.
///
/// The same page UI serves Geometry, Algebra, Physics, Chemistry, etc.
/// Content is driven by data from [ChaptersCubit], not hardcoded per subject.
class ChaptersPage extends StatelessWidget {
  const ChaptersPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocListener<SubjectSelectionCubit, SubjectSelectionState>(
      listener: (context, subjectState) {
        if (subjectState.hasSelection) {
          context.read<ChaptersCubit>().loadChapters(subjectState.subject!.id);
        }
      },
      child: BlocBuilder<SubjectSelectionCubit, SubjectSelectionState>(
        builder: (context, subjectState) {
          final subject = subjectState.subject;

          return Scaffold(
            body: CustomScrollView(
              slivers: [
                _buildAppBar(context, subject),
                _buildSubjectChips(context, subjectState),
                if (!subjectState.hasSelection)
                  const SliverFillRemaining(
                    hasScrollBody: false,
                    child: _NoSubjectSelectedState(),
                  )
                else
                  BlocBuilder<ChaptersCubit, ChaptersState>(
                    buildWhen: (prev, curr) =>
                        prev.status != curr.status ||
                        prev.chapters != curr.chapters,
                    builder: (context, state) {
                      if (state.status == ChaptersStatus.loading ||
                          state.status == ChaptersStatus.initial) {
                        return const SliverFillRemaining(
                          child: AppLoadingState(),
                        );
                      }

                      if (state.status == ChaptersStatus.error) {
                        return SliverFillRemaining(
                          child: AppErrorState(
                            message: state.errorMessage,
                            onRetry: () => context
                                .read<ChaptersCubit>()
                                .loadChapters(subject!.id, forceReload: true),
                          ),
                        );
                      }

                      return SliverPadding(
                        padding: const EdgeInsets.symmetric(
                          horizontal: AppDimensions.paddingXL,
                        ),
                        sliver: SliverList(
                          delegate: SliverChildListDelegate([
                            const SizedBox(height: AppDimensions.paddingLG),
                            _buildHeroSection(subject!),
                            const SizedBox(height: AppDimensions.paddingXXL),
                            _buildChapterCards(state, subject.id),
                            const SizedBox(
                              height: AppDimensions.paddingSection,
                            ),
                            _buildMasteryTools(),
                            const SizedBox(
                              height: AppDimensions.bottomNavPadding,
                            ),
                          ]),
                        ),
                      );
                    },
                  ),
              ],
            ),
            floatingActionButton: subjectState.hasSelection
                ? FloatingActionButton(
                    onPressed: () => ComingSoonSheet.show(
                      context,
                      featureName: AppStrings.quickPractice,
                      description:
                          'Jump into a quick practice session for this '
                          'subject with randomly selected formulas.',
                      icon: LucideIcons.play,
                    ),
                    backgroundColor: AppColors.primary,
                    child: const Icon(LucideIcons.play, color: AppColors.white),
                  )
                : null,
          );
        },
      ),
    );
  }

  // ──────────────────────── App Bar ─────────────────────────────

  SliverAppBar _buildAppBar(BuildContext context, SelectedSubject? subject) {
    return SliverAppBar(
      floating: true,
      snap: true,
      backgroundColor: AppColors.surfaceContainerLowest.withValues(
        alpha: AppDimensions.opacityAppBar,
      ),
      surfaceTintColor: AppColors.transparent,
      title: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            subject?.name ?? AppStrings.selectSubjectTitle,
            style: AppTextStyles.headlineSmall.copyWith(
              color: AppColors.onPrimaryFixedVariant,
            ),
          ),
          if (subject != null)
            Row(
              children: [
                Text(
                  AppStrings.breadcrumbHome,
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
                  subject.name.toUpperCase(),
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
        IconButton(
          onPressed: () => ComingSoonSheet.show(
            context,
            featureName: 'Subject Analytics',
            description:
                'View deep analytics and mastery metrics for this specific subject.',
            icon: LucideIcons.barChart3,
          ),
          icon: AppIconCircle(
            icon: LucideIcons.barChart3,
            size: AppDimensions.avatarMD,
            backgroundColor: AppColors.primaryFixed,
            iconColor: AppColors.primary,
            iconSize: AppDimensions.iconMD,
            borderRadius: AppDimensions.radiusMD,
          ),
        ),
        const SizedBox(width: AppDimensions.paddingMD),
        GestureDetector(
          onTap: () => context.push(AppRoutes.profilePath),
          child: const AppAvatar(
            imageUrl: AppAssets.geometryAvatarUrl,
            placeholderColor: AppColors.surfaceContainerHighest,
          ),
        ),
        const SizedBox(width: AppDimensions.paddingLG),
      ],
    );
  }

  // ──────────────────────── Subject Chips ────────────────────────

  Widget _buildSubjectChips(BuildContext context, SubjectSelectionState state) {
    if (state.availableSubjects.isEmpty) {
      return const SliverToBoxAdapter(child: SizedBox.shrink());
    }

    return SliverToBoxAdapter(
      child: Container(
        height: AppDimensions.chipContainerHeight,
        padding: const EdgeInsets.symmetric(
          horizontal: AppDimensions.paddingXL,
          vertical: AppDimensions.paddingSM,
        ),
        child: ListView.separated(
          scrollDirection: Axis.horizontal,
          itemCount: state.availableSubjects.length,
          separatorBuilder: (context, index) =>
              const SizedBox(width: AppDimensions.paddingMD),
          itemBuilder: (context, index) {
            final subject = state.availableSubjects[index];
            final isSelected = state.subject?.id == subject.id;

            return GestureDetector(
              onTap: () {
                context.read<SubjectSelectionCubit>().selectSubject(
                  id: subject.id,
                  name: subject.name,
                  category: subject.category,
                  description: subject.description,
                );
              },
              child: AnimatedContainer(
                duration: AppDurations.animationFast,
                padding: const EdgeInsets.symmetric(
                  horizontal: AppDimensions.paddingLG,
                ),
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  color: isSelected
                      ? AppColors.primary
                      : AppColors.surfaceContainerLow,
                  borderRadius: BorderRadius.circular(AppDimensions.radiusXXL),
                  border: Border.all(
                    color: isSelected
                        ? AppColors.primary
                        : AppColors.surfaceContainerHigh,
                  ),
                  boxShadow: isSelected ? const [AppShadows.subtle] : null,
                ),
                child: Text(
                  subject.name,
                  style: AppTextStyles.labelLarge.copyWith(
                    color: isSelected
                        ? AppColors.white
                        : AppColors.onSurfaceVariant,
                    fontWeight: isSelected ? FontWeight.w700 : FontWeight.w500,
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }

  // ──────────────────────── Hero Section ────────────────────────

  Widget _buildHeroSection(SelectedSubject subject) {
    return Container(
      padding: const EdgeInsets.all(AppDimensions.paddingHero),
      decoration: const SignatureGlowDecoration(),
      child: Stack(
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              AppInfoChip(
                label: subject.name.toUpperCase(),
                backgroundColor: AppColors.white.withValues(
                  alpha: AppDimensions.opacitySubtle,
                ),
                textColor: AppColors.white,
                textStyle: AppTextStyles.overline.copyWith(
                  color: AppColors.white,
                ),
              ),
              const SizedBox(height: AppDimensions.paddingLG),
              Text(
                subject.name,
                style: AppTextStyles.displayLarge.copyWith(
                  color: AppColors.white,
                ),
              ),
              const SizedBox(height: AppDimensions.paddingSM),
              Text(
                subject.subtitle.isNotEmpty
                    ? '${subject.subtitle}. ${subject.description}'
                    : subject.description,
                style: AppTextStyles.bodySmall.copyWith(
                  color: AppColors.blue50,
                  height: AppDimensions.lineHeightRelaxed,
                ),
              ),
            ],
          ),
          Positioned(
            right: AppDimensions.decorativeOffset,
            bottom: AppDimensions.decorativeOffset,
            child: Opacity(
              opacity: AppDimensions.opacityFaint,
              child: Transform.rotate(
                angle: AppDimensions.rotationSubtle,
                child: const Icon(
                  LucideIcons.compass,
                  size: AppDimensions.iconDecorative,
                  color: AppColors.white,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  // ──────────────────────── Chapter Cards ───────────────────────

  /// Feature flag: set to `false` to re-enable chapter locking.
  static const bool _kUnlockAllChapters = true;

  Widget _buildChapterCards(ChaptersState state, String subjectId) {
    if (state.chapters.isEmpty) return const SizedBox();

    final featured = state.featuredChapter;
    final remaining = state.remainingChapters;

    return Column(
      children: [
        if (featured != null) ...[
          _FeaturedChapterCard(chapter: featured, subjectId: subjectId),
          const SizedBox(height: AppDimensions.paddingLG),
        ],
        ...remaining.map((chapter) {
          // When _kUnlockAllChapters is false, locked chapters
          // show _LockedChapterCard instead.
          final effectivelyLocked = chapter.isLocked && !_kUnlockAllChapters;
          return Padding(
            padding: const EdgeInsets.only(bottom: AppDimensions.paddingLG),
            child: effectivelyLocked
                ? _LockedChapterCard(chapter: chapter)
                : _CompactChapterCard(chapter: chapter, subjectId: subjectId),
          );
        }),
      ],
    );
  }

  // ──────────────────────── Mastery Tools ───────────────────────

  Widget _buildMasteryTools() {
    final tools = [
      _MasteryTool(
        icon: LucideIcons.graduationCap,
        label: AppStrings.videoLessons,
        color: AppColors.primary,
      ),
      _MasteryTool(
        icon: LucideIcons.helpCircle,
        label: AppStrings.practiceQuiz,
        color: AppColors.secondary,
      ),
      _MasteryTool(
        icon: LucideIcons.fileText,
        label: AppStrings.cheatSheets,
        color: AppColors.orange500,
      ),
      _MasteryTool(
        icon: LucideIcons.box,
        label: AppStrings.visualizer3d,
        color: AppColors.tertiary,
      ),
    ];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        AppSectionTitle(
          title: AppStrings.masteryTools,
          leadingIcon: LucideIcons.sparkles,
        ),
        const SizedBox(height: AppDimensions.paddingLG),
        GridView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: AppDimensions.masteryToolsCrossAxisCount,
            mainAxisSpacing: AppDimensions.masteryToolsSpacing,
            crossAxisSpacing: AppDimensions.masteryToolsSpacing,
            childAspectRatio: AppDimensions.masteryToolsAspectRatio,
          ),
          itemCount: tools.length,
          itemBuilder: (context, index) {
            final tool = tools[index];
            return GestureDetector(
              onTap: () => ComingSoonSheet.show(
                context,
                featureName: tool.label,
                icon: tool.icon,
              ),
              child: AppCard(
                color: AppColors.white,
                boxShadow: const [AppShadows.subtle],
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      tool.icon,
                      size: AppDimensions.iconXXL,
                      color: tool.color,
                    ),
                    const SizedBox(height: AppDimensions.paddingSM),
                    Text(
                      tool.label,
                      style: AppTextStyles.bodySmall.copyWith(
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      ],
    );
  }
}

// ═══════════════════════════════════════════════════════════════════
//  PRIVATE WIDGET COMPONENTS
// ═══════════════════════════════════════════════════════════════════

/// Featured card – highest-progress chapter, shown prominently.
class _FeaturedChapterCard extends StatelessWidget {
  final Chapter chapter;
  final String subjectId;
  const _FeaturedChapterCard({required this.chapter, required this.subjectId});

  @override
  Widget build(BuildContext context) {
    return AppCard(
      padding: const EdgeInsets.all(AppDimensions.paddingXXL),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              AppIconCircle(
                icon: LucideIcons.triangle,
                size: AppDimensions.avatarXL,
                backgroundColor: AppColors.primaryFixed,
                iconColor: AppColors.primary,
                iconSize: AppDimensions.iconXL,
                borderRadius: AppDimensions.radiusLG,
              ),
              AppInfoChip(
                label: AppStrings.percentDone(chapter.progressPercent.toInt()),
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
                AppStrings.nearlyThere,
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
                context.goNamed(
                  AppRoutes.formulaDetailName,
                  pathParameters: {
                    'subjectId': subjectId,
                    'chapterId': chapter.id,
                  },
                  queryParameters: {'name': chapter.name},
                );
              },
              icon: const Text(AppStrings.continueLearning),
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
class _CompactChapterCard extends StatelessWidget {
  final Chapter chapter;
  final String subjectId;
  const _CompactChapterCard({required this.chapter, required this.subjectId});

  @override
  Widget build(BuildContext context) {
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
                    Text(chapter.name, style: AppTextStyles.titleLarge),
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
                  context.goNamed(
                    AppRoutes.formulaDetailName,
                    pathParameters: {
                      'subjectId': subjectId,
                      'chapterId': chapter.id,
                    },
                    queryParameters: {'name': chapter.name},
                  );
                },
                child: Text(
                  AppStrings.startNow.toUpperCase(),
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
class _LockedChapterCard extends StatelessWidget {
  final Chapter chapter;
  const _LockedChapterCard({required this.chapter});

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

/// Empty state when no subject is selected.
class _NoSubjectSelectedState extends StatelessWidget {
  const _NoSubjectSelectedState();

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(AppDimensions.paddingSection),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              LucideIcons.bookOpen,
              size: AppDimensions.iconHero,
              color: AppColors.outline.withValues(
                alpha: AppDimensions.opacityMedium,
              ),
            ),
            const SizedBox(height: AppDimensions.paddingXXL),
            Text(
              AppStrings.selectSubjectTitle,
              style: AppTextStyles.headlineSmall.copyWith(
                fontWeight: FontWeight.w700,
              ),
            ),
            const SizedBox(height: AppDimensions.paddingSM),
            Text(
              AppStrings.selectSubjectDesc,
              textAlign: TextAlign.center,
              style: AppTextStyles.bodyMedium.copyWith(
                color: AppColors.onSurfaceVariant,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _MasteryTool {
  final IconData icon;
  final String label;
  final Color color;

  const _MasteryTool({
    required this.icon,
    required this.label,
    required this.color,
  });
}
