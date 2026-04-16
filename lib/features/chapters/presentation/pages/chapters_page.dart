import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:lucide_icons/lucide_icons.dart';

import '../../../../core/core.dart';
import '../../../../shared/shared.dart';
import '../../../auth/auth.dart';
import '../cubit/chapters_cubit.dart';
import '../cubit/chapters_state.dart';
import '../widgets/chapter_cards.dart';
import '../widgets/mastery_tools_section.dart';
import '../widgets/no_subject_selected_state.dart';
import '../widgets/subject_analytics_sheet.dart';

/// Generic chapters page – renders content for ANY subject.
///
/// The same page UI serves Geometry, Algebra, Physics, Chemistry, etc.
/// Content is driven by data from [ChaptersCubit], not hardcoded per subject.
class ChaptersPage extends StatefulWidget {
  const ChaptersPage({super.key});

  @override
  State<ChaptersPage> createState() => _ChaptersPageState();
}

class _ChaptersPageState extends State<ChaptersPage> {
  @override
  void initState() {
    super.initState();
    // Trigger initial load if a subject is already selected (e.g. hydrated).
    // BlocListener only fires on *changes*, not on existing state.
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _ensureChaptersLoaded();
    });
  }

  /// If a subject is already selected, load its chapters.
  /// If no subject is selected but available subjects exist, auto-select
  /// the first one so the user always sees content on the Chapters tab.
  void _ensureChaptersLoaded() {
    final selectionCubit = context.read<SubjectSelectionCubit>();
    final subjectState = selectionCubit.state;
    final curriculumKey =
        context.read<CurriculumCubit>().state.curriculum?.curriculumKey ??
        AppStrings.unknownCurriculum;

    if (subjectState.hasSelection) {
      context.read<ChaptersCubit>().loadChapters(
        subjectState.subject!.id,
        curriculumKey: curriculumKey,
      );
    } else if (subjectState.availableSubjects.isNotEmpty) {
      final first = subjectState.availableSubjects.first;
      selectionCubit.selectSubject(
        id: first.id,
        name: first.name,
        category: first.category,
        description: first.description,
        subtitle: first.subtitle,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<SubjectSelectionCubit, SubjectSelectionState>(
      listener: (context, subjectState) {
        if (subjectState.hasSelection) {
          final curriculumKey =
              context.read<CurriculumCubit>().state.curriculum?.curriculumKey ??
              AppStrings.unknownCurriculum;
          context.read<ChaptersCubit>().loadChapters(
            subjectState.subject!.id,
            curriculumKey: curriculumKey,
          );
        }
      },
      child: BlocBuilder<SubjectSelectionCubit, SubjectSelectionState>(
        builder: (context, subjectState) {
          final subject = subjectState.subject;

          // If no subject selected yet but subjects are available,
          // auto-select after they arrive (e.g. from dashboard loading).
          if (!subjectState.hasSelection &&
              subjectState.availableSubjects.isNotEmpty) {
            WidgetsBinding.instance.addPostFrameCallback((_) {
              _ensureChaptersLoaded();
            });
          }

          return Scaffold(
            body: CustomScrollView(
              slivers: [
                _buildAppBar(context, subjectState),
                _buildSubjectChips(context, subjectState),
                if (!subjectState.hasSelection)
                  const SliverFillRemaining(
                    hasScrollBody: false,
                    child: NoSubjectSelectedState(),
                  )
                else
                  BlocBuilder<ChaptersCubit, ChaptersState>(
                    buildWhen: (prev, curr) =>
                        prev.status != curr.status ||
                        prev.chapters != curr.chapters ||
                        prev.masteryTools != curr.masteryTools,
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
                            onRetry: () =>
                                context.read<ChaptersCubit>().loadChapters(
                                  subject!.id,
                                  curriculumKey:
                                      context
                                          .read<CurriculumCubit>()
                                          .state
                                          .curriculum
                                          ?.curriculumKey ??
                                      AppStrings.unknownCurriculum,
                                  forceReload: true,
                                ),
                          ),
                        );
                      }

                      if (state.chapters.isEmpty) {
                        return SliverFillRemaining(
                          hasScrollBody: false,
                          child: Padding(
                            padding: const EdgeInsets.symmetric(
                              horizontal: AppDimensions.paddingXXL,
                            ),
                            child: Center(
                              child: AppCard(
                                padding: const EdgeInsets.all(
                                  AppDimensions.paddingXXL,
                                ),
                                child: Column(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    const Icon(
                                      LucideIcons.bookOpen,
                                      size: AppDimensions.imageLG,
                                      color: AppColors.primary,
                                    ),
                                    const SizedBox(
                                      height: AppDimensions.paddingXXL,
                                    ),
                                    Text(
                                      AppStrings.chaptersNoContentTitle,
                                      textAlign: TextAlign.center,
                                      style: AppTextStyles.headlineSmall
                                          .copyWith(
                                            fontWeight: FontWeight.w800,
                                          ),
                                    ),
                                    const SizedBox(
                                      height: AppDimensions.paddingSM,
                                    ),
                                    Text(
                                      AppStrings.chaptersNoContentDescription,
                                      textAlign: TextAlign.center,
                                      style: AppTextStyles.bodyMedium.copyWith(
                                        color: AppColors.onSurfaceVariant,
                                      ),
                                    ),
                                    const SizedBox(
                                      height: AppDimensions.paddingXXL,
                                    ),
                                    ElevatedButton(
                                      onPressed: () {
                                        context
                                            .read<SubjectSelectionCubit>()
                                            .clearSelection();
                                        StatefulNavigationShell.of(
                                          context,
                                        ).goBranch(0);
                                      },
                                      child: const Text(
                                        AppStrings.chaptersBrowseSubjects,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
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
                            _buildHeroSection(subjectState.subject!),
                            const SizedBox(height: AppDimensions.paddingXXL),
                            _buildChapterCards(state, subjectState.subject!.id),
                            const SizedBox(
                              height: AppDimensions.paddingSection,
                            ),
                            MasteryToolsSection(tools: state.masteryTools),
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
                    onPressed: () {
                      // Navigate to Practice tab (index 2)
                      final shell = StatefulNavigationShell.of(context);
                      shell.goBranch(2);
                    },
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

  SliverAppBar _buildAppBar(
    BuildContext context,
    SubjectSelectionState subjectState,
  ) {
    final subject = subjectState.subject;
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
          onPressed: () {
            if (subject == null) {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text(AppStrings.selectSubjectFirst)),
              );
              return;
            }
            final chapterState = context.read<ChaptersCubit>().state;

            // Calculate totals
            var total = 0;
            var completed = 0;
            for (var chapter in chapterState.chapters) {
              total += chapter.totalFormulas;
              completed += chapter.completedFormulas;
            }
            final progress = total > 0
                ? ((completed / total) * 100).toInt()
                : 0;

            SubjectAnalyticsSheet.show(
              context,
              subjectName: subject.name,
              progressPercent: progress,
              completedFormulas: completed,
              totalFormulas: total,
              grade:
                  context.read<CurriculumCubit>().state.gradeLabel ??
                  AppStrings.unknownGrade,
            );
          },
          icon: const AppIconCircle(
            icon: LucideIcons.barChart3,
            size: AppDimensions.avatarMD,
            backgroundColor: AppColors.primaryFixed,
            iconColor: AppColors.primary,
            iconSize: AppDimensions.iconMD,
            borderRadius: AppDimensions.radiusMD,
          ),
        ),
        const SizedBox(width: AppDimensions.paddingMD),
        BlocBuilder<AuthCubit, AuthState>(
          buildWhen: (prev, curr) => prev.user != curr.user,
          builder: (context, authState) {
            final photoUrl =
                authState.user?.photoUrl ??
                AppAssets.dashboardStudentProfileUrl;
            return GestureDetector(
              onTap: () => context.push(AppRoutes.profilePath),
              child: AppAvatar(
                imageUrl: photoUrl,
                placeholderColor: AppColors.surfaceContainerHighest,
              ),
            );
          },
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

  Widget _buildChapterCards(ChaptersState state, String subjectId) {
    final featured = state.featuredChapter;
    final remaining = state.remainingChapters;

    return Column(
      children: [
        if (featured != null) ...[
          FeaturedChapterCard(chapter: featured, subjectId: subjectId),
          const SizedBox(height: AppDimensions.paddingLG),
        ],
        ...remaining.map((chapter) {
          // When unlockAllChapters is false, locked chapters
          // show LockedChapterCard instead.
          final effectivelyLocked =
              chapter.isLocked && !AppFeatureFlags.unlockAllChapters;
          return Padding(
            padding: const EdgeInsets.only(bottom: AppDimensions.paddingLG),
            child: effectivelyLocked
                ? LockedChapterCard(chapter: chapter)
                : CompactChapterCard(chapter: chapter, subjectId: subjectId),
          );
        }),
      ],
    );
  }
}
