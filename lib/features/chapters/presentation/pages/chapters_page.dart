import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:lucide_icons/lucide_icons.dart';

import '../../../../core/core.dart';
import '../../../dashboard/dashboard.dart';
import '../../../../shared/shared.dart';
import '../../../auth/auth.dart';
import '../../../profile/domain/domain.dart';
import '../../domain/domain.dart';
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
  bool _isLoadingAvailableSubjects = false;
  bool _isAutoSelectScheduled = false;
  String _searchQuery = '';
  Timer? _searchDebounce;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      unawaited(_ensureChaptersLoaded(allowLoadForExistingSelection: true));
    });
  }

  @override
  void dispose() {
    _searchDebounce?.cancel();
    super.dispose();
  }

  /// If a subject is already selected, load its chapters.
  /// If no subject is selected but available subjects exist, auto-select
  /// the first one so the user always sees content on the Chapters tab.
  Future<void> _ensureChaptersLoaded({
    required bool allowLoadForExistingSelection,
  }) async {
    final selectionCubit = context.read<SubjectSelectionCubit>();
    final subjectState = selectionCubit.state;
    final curriculumKey = context
        .read<CurriculumCubit>()
        .state
        .curriculum
        ?.curriculumKey;

    if (curriculumKey == null || curriculumKey.isEmpty) {
      return;
    }

    if (subjectState.hasSelection && allowLoadForExistingSelection) {
      final cubitState = context.read<ChaptersCubit>().state;
      unawaited(
        context.read<ChaptersCubit>().loadChapters(
          subjectState.subject!.id,
          curriculumKey: curriculumKey,
          searchQuery: _searchQuery,
          sortBy: cubitState.sortBy,
          sortDesc: cubitState.sortDesc,
        ),
      );
    } else if (subjectState.hasSelection) {
      // Selection already exists and listener-driven loading will handle it.
      return;
    } else if (subjectState.availableSubjects.isNotEmpty) {
      final first = subjectState.availableSubjects.first;
      selectionCubit.selectSubject(
        id: first.id,
        name: first.name,
        category: first.category,
        description: first.description,
        subtitle: first.subtitle,
      );
    } else {
      await _loadAvailableSubjects();
    }
  }

  Future<void> _loadAvailableSubjects() async {
    if (_isLoadingAvailableSubjects) {
      return;
    }

    final curriculum = context.read<CurriculumCubit>().state.curriculum;
    if (curriculum == null) {
      return;
    }

    final curriculumKey = curriculum.curriculumKey;
    setState(() {
      _isLoadingAvailableSubjects = true;
    });

    try {
      final result = await getIt<GetSubjectsUseCase>().call(
        curriculum.boardId,
        curriculum.gradeId,
      );

      if (!mounted) {
        return;
      }

      if (context.read<CurriculumCubit>().state.curriculum?.curriculumKey !=
          curriculumKey) {
        return;
      }

      if (result case Success<List<Subject>>(:final data)) {
        final selectedSubjects = data
            .map(
              (subject) => SelectedSubject(
                id: subject.id,
                name: subject.name,
                category: subject.category,
                description: subject.description,
                subtitle: subject.subtitle ?? '',
              ),
            )
            .toList();
        context.read<SubjectSelectionCubit>().updateAvailableSubjects(
          selectedSubjects,
        );
      }
    } finally {
      if (mounted) {
        setState(() {
          _isLoadingAvailableSubjects = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<SubjectSelectionCubit, SubjectSelectionState>(
      listenWhen: (prev, curr) {
        final prevId = prev.subject?.id;
        final currId = curr.subject?.id;
        return prevId != currId && currId != null;
      },
      listener: (context, subjectState) {
        if (subjectState.hasSelection) {
          final curriculumKey = context
              .read<CurriculumCubit>()
              .state
              .curriculum
              ?.curriculumKey;
          if (curriculumKey == null || curriculumKey.isEmpty) {
            return;
          }
          final cubitState = context.read<ChaptersCubit>().state;
          unawaited(
            context.read<ChaptersCubit>().loadChapters(
              subjectState.subject!.id,
              curriculumKey: curriculumKey,
              sortBy: cubitState.sortBy,
              sortDesc: cubitState.sortDesc,
            ),
          );
        }
      },
      child: BlocBuilder<SubjectSelectionCubit, SubjectSelectionState>(
        builder: (context, subjectState) {
          final subject = subjectState.subject;

          // If no subject selected yet but subjects are available,
          // auto-select after they arrive (e.g. from dashboard loading).
          if (!subjectState.hasSelection &&
              subjectState.availableSubjects.isNotEmpty &&
              !_isAutoSelectScheduled) {
            _isAutoSelectScheduled = true;
            WidgetsBinding.instance.addPostFrameCallback((_) {
              _isAutoSelectScheduled = false;
              unawaited(
                _ensureChaptersLoaded(allowLoadForExistingSelection: false),
              );
            });
          }

          return Scaffold(
            body: RefreshIndicator(
              onRefresh: () async {
                if (subjectState.hasSelection) {
                  final selectedSubject = subjectState.subject!;
                  final cubitState = context.read<ChaptersCubit>().state;
                  await context.read<ChaptersCubit>().loadChapters(
                    selectedSubject.id,
                    curriculumKey:
                        context
                            .read<CurriculumCubit>()
                            .state
                            .curriculum
                            ?.curriculumKey ??
                        '',
                    searchQuery: _searchQuery,
                    sortBy: cubitState.sortBy,
                    sortDesc: cubitState.sortDesc,
                  );
                }
              },
              child: LayoutBuilder(
                builder: (context, constraints) {
                  final isDesktop = constraints.maxWidth >= AppDimensions.breakpointDesktop;
                  final hp = isDesktop
                      ? ((constraints.maxWidth - AppDimensions.breakpointMaxContent) / 2).clamp(
                          AppDimensions.paddingSectionLG, double.infinity,
                        )
                      : AppDimensions.paddingXL;
                  return CustomScrollView(
                slivers: [
                  _buildAppBar(context, subjectState),
                  _buildSubjectChips(context, subjectState),
                  if (!subjectState.hasSelection &&
                      subjectState.availableSubjects.isEmpty &&
                      _isLoadingAvailableSubjects)
                    const SliverFillRemaining(
                      hasScrollBody: false,
                      child: ChaptersShimmer(),
                    )
                  else if (!subjectState.hasSelection)
                    const SliverFillRemaining(
                      hasScrollBody: false,
                      child: NoSubjectSelectedState(),
                    )
                  else
                    BlocBuilder<ChaptersCubit, ChaptersState>(
                      buildWhen: (prev, curr) =>
                          prev.status != curr.status ||
                          prev.chapters != curr.chapters ||
                          prev.masteryTools != curr.masteryTools ||
                          prev.sortBy != curr.sortBy ||
                          prev.sortDesc != curr.sortDesc,
                      builder: (context, state) {
                        if (state.status == ChaptersStatus.loading ||
                            state.status == ChaptersStatus.initial) {
                          return const SliverFillRemaining(
                            child: ChaptersShimmer(),
                          );
                        }

                        if (state.status == ChaptersStatus.error) {
                          return SliverFillRemaining(
                            child: AppErrorState(
                              message: state.errorMessage,
                              onRetry: () =>
                                  _retryLoadChapters(context, subject!.id),
                            ),
                          );
                        }

                        if (state.chapters.isEmpty) {
                          final colorScheme = Theme.of(context).colorScheme;

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
                                        style: AppTextStyles.bodyMedium
                                            .copyWith(
                                              color:
                                                  colorScheme.onSurfaceVariant,
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
                          padding: EdgeInsets.symmetric(horizontal: hp),
                          sliver: SliverList(
                            delegate: SliverChildListDelegate([
                              const SizedBox(height: AppDimensions.paddingLG),
                              _buildHeroSection(context, subjectState.subject!),
                              const SizedBox(height: AppDimensions.paddingXXL),
                              // Search Bar
                              AppCard(
                                padding: EdgeInsets.zero,
                                child: TextField(
                                  onChanged: (value) {
                                    setState(() {
                                      _searchQuery = value;
                                    });
                                    _searchDebounce?.cancel();
                                    _searchDebounce = Timer(
                                      AppDurations.debounceDefault,
                                      () {
                                        final curriculumKey = context
                                            .read<CurriculumCubit>()
                                            .state
                                            .curriculum
                                            ?.curriculumKey;
                                        final subjectId = subjectState.subject?.id;
                                        if (subjectId == null ||
                                            curriculumKey == null ||
                                            curriculumKey.isEmpty) {
                                          return;
                                        }
                                        final cubitState = context
                                            .read<ChaptersCubit>()
                                            .state;
                                        unawaited(
                                          context
                                              .read<ChaptersCubit>()
                                              .loadChapters(
                                                subjectId,
                                                curriculumKey: curriculumKey,
                                                searchQuery: value,
                                                sortBy: cubitState.sortBy,
                                                sortDesc: cubitState.sortDesc,
                                              ),
                                        );
                                      },
                                    );
                                  },
                                  decoration: InputDecoration(
                                    hintText: AppStrings.searchChaptersHint,
                                    prefixIcon: const Icon(LucideIcons.search),
                                    border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(
                                        AppDimensions.radiusLG,
                                      ),
                                      borderSide: BorderSide.none,
                                    ),
                                    filled: true,
                                    fillColor: Theme.of(
                                      context,
                                    ).colorScheme.surface,
                                  ),
                                ),
                              ),
                              const SizedBox(height: AppDimensions.paddingLG),
                              _buildSortControls(
                                context,
                                state,
                                subjectState.subject!.id,
                              ),
                              const SizedBox(height: AppDimensions.paddingLG),
                              _buildChapterCards(
                                state,
                                subjectState.subject!.id,
                              ),
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
                  );
                },
              ),
            ),
            floatingActionButton: subjectState.hasSelection
                ? FloatingActionButton(
                    onPressed: () {
                      // Navigate to Practice tab (index 2)
                      final shell = StatefulNavigationShell.of(context);
                      shell.goBranch(2);
                    },
                    backgroundColor: AppColors.primary,
                    child: Icon(
                      LucideIcons.play,
                      color: Theme.of(context).colorScheme.onPrimary,
                    ),
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
    final colorScheme = Theme.of(context).colorScheme;

    final subject = subjectState.subject;
    return SliverAppBar(
      floating: true,
      snap: true,
      backgroundColor: colorScheme.surfaceContainerLowest.withValues(
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
                    color: colorScheme.outline,
                    fontSize: AppDimensions.fontSizeXS,
                  ),
                ),
                Icon(
                  LucideIcons.chevronRight,
                  size: AppDimensions.iconXS,
                  color: colorScheme.outlineVariant,
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
          onPressed: () async {
            if (subject == null) {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text(AppStrings.selectSubjectFirst)),
              );
              return;
            }

            unawaited(
              showDialog(
                context: context,
                barrierDismissible: false,
                builder: (_) =>
                    const Center(child: CircularProgressIndicator()),
              ),
            );

            // Fetch current stats to get the dynamic streak
            final statsResult = await getIt<GetProfileStatsUseCase>().call();
            var currentStreak = 0;
            if (statsResult is Success<List<ProfileStat>>) {
              final streakStat = statsResult.data
                  .where((s) => s.id == 'streak')
                  .firstOrNull;
              currentStreak = int.tryParse(streakStat?.value ?? '0') ?? 0;
            }

            if (!context.mounted) return;
            Navigator.of(context).pop(); // Dismiss loading

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
              currentStreak: currentStreak,
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
                placeholderColor: colorScheme.surfaceContainerHighest,
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
    final colorScheme = Theme.of(context).colorScheme;

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
                      : colorScheme.surfaceContainerLow,
                  borderRadius: BorderRadius.circular(AppDimensions.radiusXXL),
                  border: Border.all(
                    color: isSelected
                        ? AppColors.primary
                        : colorScheme.surfaceContainerHigh,
                  ),
                  boxShadow: isSelected ? const [AppShadows.subtle] : null,
                ),
                child: Text(
                  subject.name,
                  style: AppTextStyles.labelLarge.copyWith(
                    color: isSelected
                        ? colorScheme.onPrimary
                        : colorScheme.onSurfaceVariant,
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

  Widget _buildHeroSection(BuildContext context, SelectedSubject subject) {
    final colorScheme = Theme.of(context).colorScheme;

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
                backgroundColor: colorScheme.onPrimary.withValues(
                  alpha: AppDimensions.opacitySubtle,
                ),
                textColor: colorScheme.onPrimary,
                textStyle: AppTextStyles.overline.copyWith(
                  color: colorScheme.onPrimary,
                ),
              ),
              const SizedBox(height: AppDimensions.paddingLG),
              Text(
                subject.name,
                style: AppTextStyles.displayLarge.copyWith(
                  color: colorScheme.onPrimary,
                ),
              ),
              const SizedBox(height: AppDimensions.paddingSM),
              Text(
                subject.subtitle.isNotEmpty
                    ? '${subject.subtitle}. ${subject.description}'
                    : subject.description,
                style: AppTextStyles.bodySmall.copyWith(
                  color: colorScheme.onPrimary.withValues(
                    alpha: AppDimensions.opacityHigh,
                  ),
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
                child: Icon(
                  LucideIcons.compass,
                  size: AppDimensions.iconDecorative,
                  color: colorScheme.onPrimary,
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
    final featured = state.chapters
        .where((c) => c.isInProgress)
        .fold<Chapter?>(
          null,
          (best, c) => best == null || c.progressPercent > best.progressPercent
              ? c
              : best,
        );

    final remaining = featured == null
        ? state.chapters
        : state.chapters.where((c) => c.id != featured.id).toList();

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

  Widget _buildSortControls(
    BuildContext context,
    ChaptersState state,
    String subjectId,
  ) {
    final colorScheme = Theme.of(context).colorScheme;
    final directionIcon = state.sortDesc
        ? LucideIcons.arrowDown
        : LucideIcons.arrowUp;

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

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Wrap(
          spacing: AppDimensions.paddingSM,
          runSpacing: AppDimensions.paddingSM,
          children: [
            ChoiceChip(
              label: const Text('Name A-Z'),
              selected: state.sortBy == 'name' && state.sortDesc == false,
              onSelected: (_) => applySort('name', false),
              selectedColor: colorScheme.primaryContainer,
            ),
            ChoiceChip(
              label: const Text('Name Z-A'),
              selected: state.sortBy == 'name' && state.sortDesc == true,
              onSelected: (_) => applySort('name', true),
              selectedColor: colorScheme.primaryContainer,
            ),
            ChoiceChip(
              label: const Text('Progress High'),
              selected:
                  state.sortBy == 'progressPercent' && state.sortDesc == true,
              onSelected: (_) => applySort('progressPercent', true),
              selectedColor: colorScheme.primaryContainer,
            ),
            ChoiceChip(
              label: const Text('Progress Low'),
              selected:
                  state.sortBy == 'progressPercent' && state.sortDesc == false,
              onSelected: (_) => applySort('progressPercent', false),
              selectedColor: colorScheme.primaryContainer,
            ),
            ChoiceChip(
              label: const Text('Most Formulas'),
              selected:
                  state.sortBy == 'totalFormulas' && state.sortDesc == true,
              onSelected: (_) => applySort('totalFormulas', true),
              selectedColor: colorScheme.primaryContainer,
            ),
            ChoiceChip(
              label: const Text('Fewest Formulas'),
              selected:
                  state.sortBy == 'totalFormulas' && state.sortDesc == false,
              onSelected: (_) => applySort('totalFormulas', false),
              selectedColor: colorScheme.primaryContainer,
            ),
          ],
        ),
        const SizedBox(height: AppDimensions.paddingSM),
        Tooltip(
          message: 'Toggle sort direction',
          child: IconButton.filled(
            onPressed: () {
              final newDesc = !state.sortDesc;
              applySort(state.sortBy, newDesc);
            },
            icon: Icon(directionIcon, size: 20),
            tooltip: state.sortDesc ? 'Descending' : 'Ascending',
          ),
        ),
      ],
    );
  }

  void _retryLoadChapters(BuildContext context, String subjectId) {
    final curriculumKey = context
        .read<CurriculumCubit>()
        .state
        .curriculum
        ?.curriculumKey;
    if (curriculumKey == null || curriculumKey.isEmpty) {
      return;
    }

    unawaited(
      context.read<ChaptersCubit>().loadChapters(
        subjectId,
        curriculumKey: curriculumKey,
        searchQuery: _searchQuery,
        sortBy: context.read<ChaptersCubit>().state.sortBy,
        sortDesc: context.read<ChaptersCubit>().state.sortDesc,
        forceReload: true,
      ),
    );
  }
}
