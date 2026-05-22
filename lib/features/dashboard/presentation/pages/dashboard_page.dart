import 'dart:async';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:lucide_icons/lucide_icons.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../../core/core.dart';
import '../../../../shared/shared.dart';
import '../../../chapters/chapters.dart';
import '../../../auth/auth.dart';
import '../../../onboarding/onboarding.dart';
import '../../domain/domain.dart';
import '../cubit/curriculum_options_cubit.dart';
import '../cubit/curriculum_options_state.dart';
import '../cubit/dashboard_cubit.dart';
import '../cubit/dashboard_state.dart';
import '../widgets/widgets.dart';
import '../data/daily_challenges.dart';

/// Dashboard page – the main landing screen of the app.
///
/// All content sections are **data-driven** — the subject grid,
/// formula vault, and continue-studying list are rendered from
/// state provided by [DashboardCubit]. No UI code references
/// specific subjects (Math, Physics, etc.) ensuring any subject
/// added by the backend renders correctly (Open/Closed Principle).
class DashboardPage extends StatelessWidget {
  const DashboardPage({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocListener(
      listeners: [
        BlocListener<DashboardCubit, DashboardState>(
          listenWhen: (prev, curr) => prev.subjects != curr.subjects,
          listener: (context, state) {
            if (state.subjects.isNotEmpty) {
              final selectedSubjects = state.subjects
                  .map(
                    (s) => SelectedSubject(
                      id: s.id,
                      name: s.name,
                      category: s.category,
                      description: s.description,
                      iconName: s.iconName,
                      subtitle: s.subtitle ?? '',
                    ),
                  )
                  .toList();
              context.read<SubjectSelectionCubit>().updateAvailableSubjects(
                selectedSubjects,
              );
            }
          },
        ),
        BlocListener<DashboardCubit, DashboardState>(
          listenWhen: (prev, curr) =>
              prev.status == DashboardStatus.loaded &&
              curr.status == DashboardStatus.error,
          listener: (context, state) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(
                  state.errorMessage ?? 'Failed to refresh dashboard',
                ),
                behavior: SnackBarBehavior.floating,
              ),
            );
          },
        ),
        BlocListener<CurriculumCubit, CurriculumState>(
          listenWhen: (prev, curr) =>
              prev.isLoading && !curr.isLoading && curr.curriculum != null,
          listener: (context, state) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text('Curriculum updated'),
                behavior: SnackBarBehavior.floating,
              ),
            );
          },
        ),
      ],
      child: BlocBuilder<DashboardCubit, DashboardState>(
        buildWhen: (prev, curr) => prev.status != curr.status,
        builder: (context, state) {
          if (state.status == DashboardStatus.loading ||
              state.status == DashboardStatus.initial) {
            return const Scaffold(body: DashboardShimmer());
          }

          if (state.status == DashboardStatus.error) {
            return Scaffold(
              body: AppErrorState(
                onRetry: () =>
                    context.read<DashboardCubit>().retryLoadDashboard(),
              ),
            );
          }

          return Scaffold(
            body: RefreshIndicator(
              onRefresh: () => context.read<DashboardCubit>().loadDashboard(),
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
                      _buildAppBar(context),
                      SliverPadding(
                        padding: EdgeInsets.symmetric(horizontal: hp),
                        sliver: SliverList(
                          delegate: SliverChildListDelegate([
                            const SizedBox(height: AppDimensions.paddingLG),
                            _buildCurriculumFilterBar(context),
                            const SizedBox(height: AppDimensions.paddingXL),
                            _buildAnnouncementBanner(context, state),
                            const SizedBox(height: AppDimensions.paddingSection),
                            EntranceWrapper(
                              child: _buildHeroStatusCard(context, state),
                            ),
                            const SizedBox(height: AppDimensions.paddingSection),
                            EntranceWrapper(
                              delay: const Duration(milliseconds: 50),
                              child: _buildCarouselBanners(context, state),
                            ),
                            const SizedBox(height: AppDimensions.paddingSection),
                            EntranceWrapper(
                              delay: const Duration(milliseconds: 100),
                              child: _buildQuickActions(context, state),
                            ),
                            const SizedBox(height: AppDimensions.paddingSection),
                            EntranceWrapper(
                              delay: const Duration(milliseconds: 100),
                              child: _buildAcademicPath(context, state),
                            ),
                            const SizedBox(height: AppDimensions.paddingSection),
                            EntranceWrapper(
                              delay: const Duration(milliseconds: 150),
                              child: _buildFormulaVault(context, state),
                            ),
                            const SizedBox(height: AppDimensions.paddingLG),
                            EntranceWrapper(
                              delay: const Duration(milliseconds: 200),
                              child: _buildContinueStudying(context, state),
                            ),
                            if (state.weakAreas.isNotEmpty) ...[
                              const SizedBox(height: AppDimensions.paddingSection),
                              EntranceWrapper(
                                delay: const Duration(milliseconds: 250),
                                child: WeakAreasSection(
                                  weakAreas: state.weakAreas,
                                ),
                              ),
                            ],
                            const SizedBox(height: AppDimensions.bottomNavPadding),
                          ]),
                        ),
                      ),
                    ],
                  );
                },
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildAnnouncementBanner(BuildContext context, DashboardState state) {
    final allVisible = state.announcements.where((a) {
      if (a.isUrgent) return true;
      if (a.isHighPriority) return true;
      return true;
    }).toList();
    if (allVisible.isEmpty) return const SizedBox.shrink();
    return _AnnouncementBanner(announcements: allVisible);
  }

  Widget _buildCarouselBanners(BuildContext context, DashboardState state) {
    final banners = state.banners.where((b) => b.isActive).toList();
    if (banners.isEmpty) return const SizedBox.shrink();
    return _CarouselBanners(banners: banners);
  }

  // ──────────────────────── App Bar ─────────────────────────────

  Widget _buildAppBar(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return BlocBuilder<AuthCubit, AuthState>(
      buildWhen: (prev, curr) => prev.user != curr.user,
      builder: (context, authState) {
        final user = authState.user;
        final userName = user?.displayName ?? AppStrings.dashboardSanctuary;
        final photoUrl = user?.photoUrl ?? AppAssets.dashboardStudentProfileUrl;

        return SliverGlassAppBar(
          titleWidget: GestureDetector(
            onTap: () => context.go(AppRoutes.profilePath),
            behavior: HitTestBehavior.opaque,
            child: Row(
              children: [
                // Gradient ring avatar
                Container(
                  padding: const EdgeInsets.all(2.0),
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    gradient: isDark
                        ? AppColors.darkPrimaryGradient
                        : AppColors.primaryGradient,
                  ),
                  child: Container(
                    width: AppDimensions.avatarMD - 4,
                    height: AppDimensions.avatarMD - 4,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: colorScheme.surface,
                    ),
                    clipBehavior: Clip.antiAlias,
                    child: CachedNetworkImage(
                      imageUrl: photoUrl,
                      fit: BoxFit.cover,
                      placeholder: (context, url) => const SizedBox(),
                      errorWidget: (context, url, error) =>
                          Icon(LucideIcons.user, color: colorScheme.primary),
                    ),
                  ),
                ),
                const SizedBox(width: AppDimensions.paddingMD),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      userName,
                      style: AppTextStyles.titleMedium.copyWith(
                        color: colorScheme.onSurface,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                    Text(
                      'Welcome back ✨',
                      style: AppTextStyles.bodySmall.copyWith(
                        color: colorScheme.onSurfaceVariant,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          actions: [
            Semantics(
              label: 'Search formulas',
              button: true,
              child: Container(
                margin: const EdgeInsets.only(right: AppDimensions.paddingSM),
                decoration: BoxDecoration(
                  color: colorScheme.surfaceContainerHigh.withValues(alpha: 0.5),
                  borderRadius: BorderRadius.circular(AppDimensions.radiusMD),
                ),
                child: IconButton(
                  onPressed: () => context.pushNamed(AppRoutes.searchName),
                  icon: Icon(LucideIcons.search, color: colorScheme.onSurfaceVariant),
                ),
              ),
            ),
          ],
        );
      },
    );
  }

  Widget _buildCurriculumFilterBar(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return BlocBuilder<CurriculumCubit, CurriculumState>(
      buildWhen: (prev, curr) =>
          prev.curriculum != curr.curriculum ||
          prev.isLoading != curr.isLoading,
      builder: (context, curriculum) {
        final selection = curriculum.curriculum;
        return BlocBuilder<CurriculumOptionsCubit, CurriculumOptionsState>(
          builder: (context, options) {
            final isBusy = options.status == CurriculumOptionsStatus.loading;

            return AppCard(
              padding: const EdgeInsets.all(AppDimensions.paddingLG),
              border: Border.all(color: colorScheme.surfaceContainerHigh),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Header row
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          Container(
                            padding: const EdgeInsets.all(
                              AppDimensions.paddingXS,
                            ),
                            decoration: BoxDecoration(
                              color: colorScheme.primaryContainer.withValues(
                                alpha: AppDimensions.opacityFaint,
                              ),
                              borderRadius: BorderRadius.circular(
                                AppDimensions.radiusSM,
                              ),
                            ),
                            child: Icon(
                              LucideIcons.slidersHorizontal,
                              size: AppDimensions.iconSM,
                              color: colorScheme.primary,
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
                          onTap: () => context.go(AppRoutes.onboardingPath),
                          child: Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: AppDimensions.paddingSM,
                              vertical: AppDimensions.paddingXXS,
                            ),
                            decoration: BoxDecoration(
                              color: colorScheme.primaryContainer.withValues(
                                alpha: AppDimensions.opacityFaint,
                              ),
                              borderRadius: BorderRadius.circular(
                                AppDimensions.radiusXXL,
                              ),
                            ),
                            child: Row(
                              children: [
                                Icon(
                                  LucideIcons.arrowLeftRight,
                                  size: AppDimensions.iconSM,
                                  color: colorScheme.primary,
                                ),
                                const SizedBox(width: AppDimensions.paddingXXS),
                                Text(
                                  AppStrings.dashboardSwitchBoardGrade,
                                  style: AppTextStyles.labelSmall.copyWith(
                                    color: colorScheme.primary,
                                    fontWeight: FontWeight.w700,
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
                  // Active curriculum badges
                  AnimatedSwitcher(
                    duration: AppDurations.animationFast,
                    child: Row(
                      key: ValueKey(
                        'badges_${selection?.boardId}_${selection?.gradeId}',
                      ),
                      children: [
                        _CurriculumBadge(
                          icon: LucideIcons.layoutGrid,
                          iconColor: colorScheme.primary,
                          label:
                              selection?.boardName ??
                              AppStrings.dashboardCurriculumPending,
                          isActive: true,
                          activeColor: colorScheme.primary,
                        ),
                        if (selection != null) ...[
                          const SizedBox(width: AppDimensions.paddingSM),
                          Icon(
                            LucideIcons.chevronRight,
                            size: AppDimensions.iconSM,
                            color: colorScheme.outline,
                          ),
                          const SizedBox(width: AppDimensions.paddingSM),
                        ],
                        _CurriculumBadge(
                          icon: LucideIcons.graduationCap,
                          iconColor: colorScheme.secondary,
                          label:
                              selection?.gradeLabel ??
                              AppStrings.dashboardCurriculumPending,
                          isActive: true,
                          activeColor: colorScheme.secondary,
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: AppDimensions.paddingMD),
                  // Divider
                  Container(
                    height: AppDimensions.dividerHeight,
                    color: colorScheme.surfaceContainerHighest,
                  ),
                  const SizedBox(height: AppDimensions.paddingMD),
                  // Boards and Grades
                  if (isBusy && options.boards.isEmpty)
                    _buildFilterShimmer()
                  else ...[
                    _buildCurriculumChipRow<Board>(
                      context: context,
                      label: AppStrings.dashboardAvailableBoards,
                      items: options.boards,
                      selectedId: selection?.boardId,
                      itemId: (board) => board.id,
                      itemLabel: (board) => board.name,
                      itemSubtitle: (Board board) => board.type.name,
                      emptyMessage: AppStrings.dashboardNoBoardsAvailable,
                      isBusy: isBusy,
                      onSelected: (board) => context
                          .read<CurriculumOptionsCubit>()
                          .selectBoard(board),
                    ),
                    const SizedBox(height: AppDimensions.paddingSM),
                    _buildCurriculumChipRow<Grade>(
                      context: context,
                      label: AppStrings.dashboardAvailableClasses,
                      items: options.grades,
                      selectedId: selection?.gradeId,
                      itemId: (grade) => grade.id,
                      itemLabel: (grade) => grade.displayLabel,
                      emptyMessage: AppStrings.dashboardNoClassesAvailable,
                      isBusy: isBusy,
                      onSelected: (grade) => context
                          .read<CurriculumOptionsCubit>()
                          .selectGrade(grade),
                    ),
                  ],
                  if (options.status == CurriculumOptionsStatus.error)
                    Padding(
                      padding: const EdgeInsets.only(
                        top: AppDimensions.paddingSM,
                      ),
                      child: Row(
                        children: [
                          Expanded(
                            child: Text(
                              options.errorMessage ??
                                  AppStrings
                                      .dashboardCurriculumOptionsLoadFailed,
                              style: AppTextStyles.labelSmall.copyWith(
                                color: colorScheme.error,
                              ),
                            ),
                          ),
                          TextButton(
                            onPressed: () => context
                                .read<CurriculumOptionsCubit>()
                                .loadOptions(),
                            child: const Text(
                              AppStrings.dashboardRetryCurriculumOptions,
                            ),
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

  Widget _buildFilterShimmer() {
    return const Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        ShimmerBox(width: 120, height: 12),
        SizedBox(height: AppDimensions.paddingSM),
        Row(
          children: [
            ShimmerBox(width: 80, height: 36, borderRadius: 18),
            SizedBox(width: 8),
            ShimmerBox(width: 100, height: 36, borderRadius: 18),
            SizedBox(width: 8),
            ShimmerBox(width: 90, height: 36, borderRadius: 18),
          ],
        ),
        SizedBox(height: AppDimensions.paddingSM),
        ShimmerBox(width: 100, height: 12),
        SizedBox(height: AppDimensions.paddingSM),
        Row(
          children: [
            ShimmerBox(width: 70, height: 36, borderRadius: 18),
            SizedBox(width: 8),
            ShimmerBox(width: 80, height: 36, borderRadius: 18),
          ],
        ),
      ],
    );
  }

  Widget _buildCurriculumChipRow<T>({
    required BuildContext context,
    required String label,
    required List<T> items,
    required String? selectedId,
    required String Function(T item) itemId,
    required String Function(T item) itemLabel,
    String Function(T item)? itemSubtitle,
    required String emptyMessage,
    required bool isBusy,
    required Future<void> Function(T item) onSelected,
  }) {
    final colorScheme = Theme.of(context).colorScheme;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: AppTextStyles.labelSmall.copyWith(
            color: colorScheme.onSurfaceVariant,
            fontWeight: FontWeight.w700,
          ),
        ),
        const SizedBox(height: AppDimensions.paddingSM),
        if (items.isEmpty)
          Container(
            padding: const EdgeInsets.symmetric(
              vertical: AppDimensions.paddingMD,
            ),
            child: Row(
              children: [
                Icon(
                  LucideIcons.info,
                  size: AppDimensions.iconSM,
                  color: colorScheme.onSurfaceVariant.withValues(
                    alpha: AppDimensions.opacityMedium,
                  ),
                ),
                const SizedBox(width: AppDimensions.paddingSM),
                Text(
                  emptyMessage,
                  style: AppTextStyles.bodySmall.copyWith(
                    color: colorScheme.onSurfaceVariant,
                  ),
                ),
              ],
            ),
          )
        else
          SizedBox(
            height: AppDimensions.chipContainerHeight,
            child: ListView.separated(
              scrollDirection: Axis.horizontal,
              itemCount: items.length,
              separatorBuilder: (_, _) =>
                  const SizedBox(width: AppDimensions.paddingSM),
              itemBuilder: (context, index) {
                final item = items[index];
                final selected = itemId(item) == selectedId;

                return _CurriculumChip(
                  label: itemLabel(item),
                  subtitle: itemSubtitle?.call(item),
                  selected: selected,
                  onTap: isBusy ? null : () => unawaited(onSelected(item)),
                );
              },
            ),
          ),
      ],
    );
  }

  // ──────────────────────── Hero Status Card ────────────────────

  Widget _buildHeroStatusCard(BuildContext context, DashboardState state) {
    final colorScheme = Theme.of(context).colorScheme;
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Container(
      padding: const EdgeInsets.all(AppDimensions.paddingHero),
      decoration: BoxDecoration(
        gradient: isDark ? AppColors.darkHeroGradient : AppColors.heroGradient,
        borderRadius: BorderRadius.circular(AppDimensions.radiusXL),
        boxShadow: [AppShadows.glow(colorScheme.primary)],
      ),
      child: Stack(
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Curriculum badge
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: AppDimensions.chipPaddingHorizontal,
                  vertical: AppDimensions.badgePaddingVertical,
                ),
                decoration: BoxDecoration(
                  color: colorScheme.surface.withValues(
                    alpha: AppDimensions.opacitySubtle,
                  ),
                  borderRadius: BorderRadius.circular(AppDimensions.radiusXXL),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Container(
                      width: AppDimensions.dotIndicatorSize,
                      height: AppDimensions.dotIndicatorSize,
                      decoration: const BoxDecoration(
                        shape: BoxShape.circle,
                        color: AppColors.successGreen,
                      ),
                    ),
                    const SizedBox(width: AppDimensions.paddingSM),
                    Text(
                      state.heroBadge,
                      style: AppTextStyles.labelSmall.copyWith(
                        color: colorScheme.onPrimary,
                        fontWeight: FontWeight.w700,
                        fontSize: AppDimensions.fontSizeXS,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: AppDimensions.paddingLG),
              // Title
              Text(
                state.heroTitle,
                style: AppTextStyles.headlineLarge.copyWith(
                  color: colorScheme.onPrimary,
                  fontWeight: FontWeight.w800,
                  height: AppDimensions.lineHeightCompact,
                ),
              ),
              const SizedBox(height: AppDimensions.paddingSM),
              // Description
              Text(
                state.heroDescription,
                style: AppTextStyles.bodyMedium.copyWith(
                  color: colorScheme.onPrimary.withValues(
                    alpha: AppDimensions.opacityNearOpaque,
                  ),
                ),
              ),
              const SizedBox(height: AppDimensions.paddingXL),
              // Resume button — premium gradient
              Semantics(
                label: 'Resume learning',
                button: true,
                child: GestureDetector(
                  onTap: () => _resumeLearning(context, state),
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: AppDimensions.paddingHero,
                      vertical: AppDimensions.progressBarLG,
                    ),
                    decoration: BoxDecoration(
                      color: AppColors.white,
                      borderRadius: BorderRadius.circular(AppDimensions.radiusXXL),
                      boxShadow: const [AppShadows.medium],
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          AppStrings.dashboardResumeLesson,
                          style: AppTextStyles.labelLarge.copyWith(
                            color: colorScheme.primary,
                            fontWeight: FontWeight.w800,
                          ),
                        ),
                        const SizedBox(width: AppDimensions.paddingSM),
                        Icon(
                          LucideIcons.arrowRight,
                          size: AppDimensions.iconSM,
                          color: colorScheme.primary,
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
          // Decorative circles
          Positioned(
            top: -AppDimensions.paddingSM,
            right: -AppDimensions.paddingSM,
            child: Container(
              width: AppDimensions.glowCircleSizeSM,
              height: AppDimensions.glowCircleSizeSM,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: colorScheme.surface.withValues(
                  alpha: AppDimensions.opacityFaint,
                ),
              ),
            ),
          ),
          Positioned(
            bottom: -20,
            right: 40,
            child: Container(
              width: 60,
              height: 60,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: colorScheme.surface.withValues(alpha: 0.06),
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _resumeLearning(BuildContext context, DashboardState state) {
    final featured = state.subjects.where((s) => s.isFeatured).toList();
    if (featured.isNotEmpty) {
      _onSubjectTap(context, featured.first);
      return;
    }
    if (state.subjects.isNotEmpty) {
      _onSubjectTap(context, state.subjects.first);
      return;
    }
    context.read<SubjectSelectionCubit>().clearSelection();
    StatefulNavigationShell.of(context).goBranch(1);
  }

  // ──────────────────────── Quick Actions ───────────────────────

  Widget _buildQuickActions(BuildContext context, DashboardState state) {
    final colorScheme = Theme.of(context).colorScheme;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SectionHeader(
          title: AppStrings.exploreTools,
          actionLabel: null,
        ),
        const SizedBox(height: AppDimensions.paddingLG),
        Row(
          children: [
            Expanded(
              child: _ToolCard(
                icon: LucideIcons.box,
                label: AppStrings.visualizer3d,
                color: colorScheme.primary,
                onTap: () => context.pushNamed(AppRoutes.visualizer3dName),
              ),
            ),
            const SizedBox(width: AppDimensions.paddingMD),
            Expanded(
              child: _ToolCard(
                icon: LucideIcons.calendarCheck,
                label: 'Study Planner',
                color: colorScheme.secondary,
                onTap: () => context.pushNamed(AppRoutes.studyPlannerName),
              ),
            ),
          ],
        ),
        const SizedBox(height: AppDimensions.paddingMD),
        Row(
          children: [
            Expanded(
              child: _ToolCard(
                icon: LucideIcons.barChart3,
                label: 'Analytics',
                color: colorScheme.tertiary,
                onTap: () => context.pushNamed(AppRoutes.analyticsName),
              ),
            ),
            const SizedBox(width: AppDimensions.paddingMD),
            Expanded(
              child: _ToolCard(
                icon: LucideIcons.layers,
                label: 'Flashcards',
                color: colorScheme.primary,
                onTap: () => context.pushNamed(AppRoutes.flashcardsName),
              ),
            ),
          ],
        ),
      ],
    );
  }

  // ──────────────────────── Academic Path ───────────────────────

  Widget _buildAcademicPath(BuildContext context, DashboardState state) {
    final subjects = state.subjects;
    // Separate featured subject (first card, gets larger layout)
    final featured = subjects.where((s) => s.isFeatured).toList();
    final others = subjects.where((s) => !s.isFeatured).toList();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SectionHeader(
          title: AppStrings.dashboardAcademicPath,
          actionLabel: AppStrings.viewAll,
          onAction: () {
            context.read<SubjectSelectionCubit>().clearSelection();
            StatefulNavigationShell.of(context).goBranch(1);
          },
        ),
        const SizedBox(height: AppDimensions.paddingLG),
        AnimatedSwitcher(
          duration: AppDurations.animationDefault,
          transitionBuilder: (child, animation) {
            return FadeTransition(opacity: animation, child: child);
          },
          child: LayoutBuilder(
            key: ValueKey('subjects_${subjects.length}_${subjects.hashCode}'),
            builder: (context, constraints) {
              final isWide =
                  constraints.maxWidth > AppDimensions.breakpointWide;
              if (isWide) {
                return Column(
                  children: [
                    // Row 1: featured + first other
                    if (featured.isNotEmpty || others.isNotEmpty)
                      IntrinsicHeight(
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            if (featured.isNotEmpty)
                              Expanded(
                                flex: 2,
                                child: SubjectCard(
                                  subject: featured.first,
                                  onTap: () =>
                                      _onSubjectTap(context, featured.first),
                                  onLongPress: () => _showSubjectAnalytics(
                                    context,
                                    state,
                                    featured.first,
                                  ),
                                ),
                              ),
                            if (featured.isNotEmpty && others.isNotEmpty)
                              const SizedBox(width: AppDimensions.paddingLG),
                            if (others.isNotEmpty)
                              Expanded(
                                child: SubjectCard(
                                  subject: others.first,
                                  onTap: () =>
                                      _onSubjectTap(context, others.first),
                                  onLongPress: () => _showSubjectAnalytics(
                                    context,
                                    state,
                                    others.first,
                                  ),
                                ),
                              ),
                          ],
                        ),
                      ),
                    const SizedBox(height: AppDimensions.paddingLG),
                    // Row 2: remaining others + quiz
                    SizedBox(
                      width: double.infinity,
                      child: Wrap(
                        spacing: AppDimensions.paddingLG,
                        runSpacing: AppDimensions.paddingLG,
                        alignment: WrapAlignment.start,
                        children: [
                          ...others.skip(1).map((subject) {
                            // Roughly 50% width minus padding for 2-column layout
                            final itemWidth =
                                (constraints.maxWidth -
                                    AppDimensions.paddingLG) /
                                2.05;
                            return SizedBox(
                              width: itemWidth,
                              child: SubjectCard(
                                subject: subject,
                                onTap: () => _onSubjectTap(context, subject),
                                onLongPress: () => _showSubjectAnalytics(
                                  context,
                                  state,
                                  subject,
                                ),
                              ),
                            );
                          }),
                          SizedBox(
                            width:
                                (constraints.maxWidth -
                                    AppDimensions.paddingLG) /
                                2.05,
                            child: _buildQuizCard(context),
                          ),
                        ],
                      ),
                    ),
                  ],
                );
              }
              // Mobile: stack all subjects vertically
              return Column(
                children: [
                  ...subjects.map(
                    (subject) => Padding(
                      padding: const EdgeInsets.only(
                        bottom: AppDimensions.paddingLG,
                      ),
                      child: SubjectCard(
                        subject: subject,
                        onTap: () => _onSubjectTap(context, subject),
                        onLongPress: () =>
                            _showSubjectAnalytics(context, state, subject),
                      ),
                    ),
                  ),
                  _buildQuizCard(context),
                ],
              );
            },
          ),
        ),
      ],
    );
  }

  /// Handles tap on a subject card — selects the subject and
  /// navigates to the Chapters tab.
  void _onSubjectTap(BuildContext context, Subject subject) {
    context.read<SubjectSelectionCubit>().selectSubject(
      id: subject.id,
      name: subject.name,
      category: subject.category,
      description: subject.description,
      iconName: subject.iconName,
      subtitle: subject.subtitle ?? '',
    );
    context.goNamed(
      AppRoutes.subjectChaptersName,
      pathParameters: {'subjectId': subject.id},
    );
  }

  void _showSubjectAnalytics(
    BuildContext context,
    DashboardState state,
    Subject subject,
  ) {
    final mastery = subject.masteryPercentage ?? 0;
    final progressPercent = mastery.round().clamp(0, 100);
    final completedFormulas = subject.formulaCount == 0
        ? 0
        : ((subject.formulaCount * progressPercent) / 100).round().clamp(
            0,
            subject.formulaCount,
          );

    final grade = state.selectedGradeName.isNotEmpty
        ? 'Grade ${state.selectedGradeName}'
        : AppStrings.dashboardCurriculumPending;

    SubjectAnalyticsSheet.show(
      context,
      subjectName: subject.name,
      progressPercent: progressPercent,
      completedFormulas: completedFormulas,
      totalFormulas: subject.formulaCount,
      grade: grade,
    );
  }

  // ──────────── Quiz Card ────────────

  Widget _buildQuizCard(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return AppCard(
      color: colorScheme.primary.withValues(alpha: AppDimensions.opacityOverlay),
      padding: const EdgeInsets.all(AppDimensions.paddingXXL),
      border: Border.all(
        color: colorScheme.primary.withValues(alpha: AppDimensions.opacityFaint),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              AppIconCircle(
                icon: LucideIcons.helpCircle,
                size: AppDimensions.avatarMD,
                backgroundColor: colorScheme.primaryContainer,
                iconColor: colorScheme.primary,
                iconSize: AppDimensions.iconLG,
                borderRadius: AppDimensions.radiusXL,
              ),
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: AppDimensions.paddingSM,
                  vertical: AppDimensions.paddingXXS,
                ),
                decoration: BoxDecoration(
                  color: colorScheme.error,
                  borderRadius: BorderRadius.circular(AppDimensions.radiusXXL),
                ),
                child: Text(
                  AppStrings.dashboardLive,
                  style: AppTextStyles.labelSmall.copyWith(
                    color: colorScheme.onError,
                    fontSize: AppDimensions.fontSizeXXSPlus,
                    fontWeight: FontWeight.w800,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: AppDimensions.paddingLG),
          Text(
            AppStrings.dashboardBoardReadyQuiz,
            style: AppTextStyles.titleLarge,
          ),
          const SizedBox(height: AppDimensions.paddingXS),
          Text(
            AppStrings.dashboardQuizDesc,
            style: AppTextStyles.bodySmall.copyWith(
              color: colorScheme.onSurfaceVariant,
            ),
          ),
          const SizedBox(height: AppDimensions.paddingLG),
          SizedBox(
            width: double.infinity,
            child: Semantics(
              label: 'Start quiz',
              button: true,
              child: ElevatedButton(
                onPressed: () {
                  final challenge = DailyChallenges.random();
                  DailyChallengeDialog.show(
                    context: context,
                    formulaTitle: challenge.formulaTitle,
                    formulaLatex: challenge.formulaLatex,
                    question: challenge.question,
                    options: challenge.options,
                    correctIndex: challenge.correctIndex,
                  );
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: colorScheme.primary,
                  foregroundColor: colorScheme.onPrimary,
                  padding: const EdgeInsets.symmetric(
                    vertical: AppDimensions.progressBarMD,
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(AppDimensions.radiusXL),
                  ),
                  textStyle: AppTextStyles.labelLarge,
                ),
                child: const Text(AppStrings.startNow),
              ),
            ),
          ),
        ],
      ),
    );
  }

  // ──────────────────────── Formula Vault ───────────────────────

  Widget _buildFormulaVault(BuildContext context, DashboardState state) {
    final colorScheme = Theme.of(context).colorScheme;

    return AppCard(
      padding: const EdgeInsets.all(AppDimensions.paddingXXL),
      border: Border.all(color: colorScheme.surfaceContainerHigh),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(AppDimensions.paddingMD),
                decoration: BoxDecoration(
                  color: colorScheme.surfaceContainerLow,
                  borderRadius: BorderRadius.circular(AppDimensions.radiusLG),
                  boxShadow: const [AppShadows.subtle],
                ),
                child: Icon(
                  LucideIcons.folderOpen,
                  size: AppDimensions.iconLG,
                  color: colorScheme.primary,
                ),
              ),
              const SizedBox(width: AppDimensions.paddingLG),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      AppStrings.dashboardFormulaVault,
                      style: AppTextStyles.titleLarge,
                    ),
                    const SizedBox(height: AppDimensions.paddingXXS),
                    Text(
                      state.vaultDescription,
                      style: AppTextStyles.bodySmall.copyWith(
                        color: colorScheme.onSurfaceVariant,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: AppDimensions.paddingXL),
          if (state.vaultItems.isEmpty)
            _buildVaultEmptyState(context)
          else
            _buildVaultGrid(context, state),
        ],
      ),
    );
  }

  Widget _buildVaultEmptyState(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Container(
      padding: const EdgeInsets.symmetric(
        vertical: AppDimensions.paddingSection,
      ),
      child: Column(
        children: [
          Icon(
            LucideIcons.folderOpen,
            size: AppDimensions.iconDecorative,
            color: colorScheme.surfaceContainerHighest,
          ),
          const SizedBox(height: AppDimensions.paddingLG),
          Text(
            'No formulas yet',
            style: AppTextStyles.titleLarge.copyWith(
              color: colorScheme.onSurfaceVariant,
            ),
          ),
          const SizedBox(height: AppDimensions.paddingXS),
          Text(
            'Select a subject to start learning',
            style: AppTextStyles.bodySmall.copyWith(
              color: colorScheme.onSurfaceVariant,
            ),
          ),
        ],
      ),
    );
  }

  /// Data-driven vault grid — items come from [DashboardState.vaultItems].
  Widget _buildVaultGrid(BuildContext context, DashboardState state) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final colorScheme = Theme.of(context).colorScheme;
        final width = constraints.maxWidth;
        final crossAxisCount = Responsive.gridColumns(
          width,
          mobile: 2,
          tablet: 3,
          desktop: 4,
          wideDesktop: 6,
        );
        // Items from state + an "add" slot
        final vaultItems = state.vaultItems;
        final totalCount = vaultItems.length + 1; // +1 for "add new" card

        return GridView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: crossAxisCount,
            mainAxisSpacing: AppDimensions.paddingMD,
            crossAxisSpacing: AppDimensions.paddingMD,
            childAspectRatio: AppDimensions.vaultGridAspectRatio,
          ),
          itemCount: totalCount,
          itemBuilder: (context, index) {
            // Last card = "Add new" slot
            if (index >= vaultItems.length) {
              return Material(
                color: AppColors.transparent,
                child: InkWell(
                  onTap: () {
                    // Navigate to Saved tab (index 3)
                    final shell = StatefulNavigationShell.of(context);
                    shell.goBranch(3);
                  },
                  borderRadius: BorderRadius.circular(AppDimensions.radiusXL),
                  child: Container(
                    decoration: BoxDecoration(
                      color: colorScheme.surfaceContainerLowest,
                      borderRadius: BorderRadius.circular(
                        AppDimensions.radiusXL,
                      ),
                      border: Border.all(
                        color: colorScheme.surfaceContainerHighest,
                        width: AppDimensions.borderWidth,
                      ),
                      boxShadow: const [AppShadows.subtle],
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          LucideIcons.plus,
                          size: AppDimensions.iconLG,
                          color: colorScheme.outline,
                        ),
                        const SizedBox(height: AppDimensions.paddingXXS),
                        Text(
                          'Add',
                          style: AppTextStyles.labelSmall.copyWith(
                            color: colorScheme.outline,
                            fontSize: AppDimensions.fontSizeXS,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              );
            }
            final item = vaultItems[index];
            return Material(
              color: AppColors.transparent,
              child: InkWell(
                onTap: () {
                  _navigateFromVaultItem(context, state, item);
                },
                borderRadius: BorderRadius.circular(AppDimensions.radiusXL),
                child: Container(
                  padding: const EdgeInsets.all(AppDimensions.paddingLG),
                  decoration: BoxDecoration(
                    color: colorScheme.surfaceContainerLowest,
                    borderRadius: BorderRadius.circular(AppDimensions.radiusXL),
                    border: Border.all(color: colorScheme.surfaceContainerHigh),
                    boxShadow: const [AppShadows.subtle],
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        item.label,
                        style: AppTextStyles.labelSmall.copyWith(
                          color: colorScheme.onSurfaceVariant,
                          fontSize: AppDimensions.fontSizeXS,
                        ),
                      ),
                      const SizedBox(height: AppDimensions.paddingXXS),
                      Text(
                        item.title,
                        style: AppTextStyles.labelLarge,
                        overflow: TextOverflow.ellipsis,
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

  void _navigateFromVaultItem(
    BuildContext context,
    DashboardState state,
    FormulaVaultItem item,
  ) {
    Subject? subject;
    for (final s in state.subjects) {
      if (s.id == item.id) {
        subject = s;
        break;
      }
    }

    if (subject != null) {
      _onSubjectTap(context, subject);
      return;
    }

    StatefulNavigationShell.of(context).goBranch(3);
  }

  // ──────────────────────── Continue Studying ───────────────────

  /// Data-driven recent studies list — uses [RecentStudy.iconName]
  /// and [RecentStudy.colorValue] instead of hardcoded `isMath` checks.
  Widget _buildContinueStudying(BuildContext context, DashboardState state) {
    final colorScheme = Theme.of(context).colorScheme;

    if (state.recentStudies.isEmpty) {
      return AppCard(
        padding: const EdgeInsets.all(AppDimensions.paddingXXL),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              AppStrings.continueStudying,
              style: AppTextStyles.headlineSmall.copyWith(
                fontWeight: FontWeight.w700,
              ),
            ),
            const SizedBox(height: AppDimensions.paddingMD),
            Text(
              AppStrings.dashboardNoRecentTitle,
              style: AppTextStyles.titleLarge,
            ),
            const SizedBox(height: AppDimensions.paddingXS),
            Text(
              AppStrings.dashboardNoRecentDescription,
              style: AppTextStyles.bodySmall.copyWith(
                color: colorScheme.onSurfaceVariant,
              ),
            ),
            const SizedBox(height: AppDimensions.paddingLG),
            ElevatedButton(
              onPressed: () => StatefulNavigationShell.of(context).goBranch(1),
              child: const Text(AppStrings.dashboardOpenChapters),
            ),
          ],
        ),
      );
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          AppStrings.continueStudying,
          style: AppTextStyles.headlineSmall.copyWith(
            fontWeight: FontWeight.w700,
          ),
        ),
        const SizedBox(height: AppDimensions.paddingLG),
        ...state.recentStudies.asMap().entries.map((entry) {
          final index = entry.key;
          final study = entry.value;
          final iconData = AppIconMapper.resolve(study.iconName);
          final accentColor = Color(study.colorValue);
          final bgColor = Color(study.backgroundColorValue);

          return EntranceWrapper(
            delay: Duration(milliseconds: index * 60),
            child: Padding(
              padding: const EdgeInsets.only(bottom: AppDimensions.paddingMD),
              child: Material(
                color: AppColors.transparent,
                child: InkWell(
                  onTap: () {
                    _onRecentStudyTap(context, state, study);
                  },
                  borderRadius: BorderRadius.circular(AppDimensions.radiusLG),
                  child: AppCard(
                    padding: const EdgeInsets.all(AppDimensions.paddingLG),
                    child: Row(
                      children: [
                        AppIconCircle(
                          icon: iconData,
                          size: AppDimensions.avatarLG,
                          backgroundColor: bgColor,
                          iconColor: accentColor,
                          iconSize: AppDimensions.iconLG,
                        ),
                        const SizedBox(width: AppDimensions.paddingLG),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                study.title,
                                style: AppTextStyles.labelLarge,
                                overflow: TextOverflow.ellipsis,
                              ),
                              const SizedBox(height: AppDimensions.paddingXXS),
                              Text(
                                '${study.subject} • ${study.lastViewed}',
                                style: AppTextStyles.bodySmall.copyWith(
                                  color: colorScheme.onSurfaceVariant,
                                ),
                                overflow: TextOverflow.ellipsis,
                              ),
                            ],
                          ),
                        ),
                        Icon(
                          LucideIcons.chevronRight,
                          size: AppDimensions.iconMD,
                          color: colorScheme.outline,
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          );
        }),
      ],
    );
  }

  void _onRecentStudyTap(
    BuildContext context,
    DashboardState state,
    RecentStudy study,
  ) {
    if (study.id == 'practice') {
      StatefulNavigationShell.of(context).goBranch(2);
      return;
    }

    if (study.subjectId.isNotEmpty) {
      // Recent study ID for chapters is formatted as: subjectId_chapterId
      final chapterId = study.id.replaceFirst('${study.subjectId}_', '');

      final byId = state.subjects
          .where((s) => s.id == study.subjectId)
          .toList();

      if (byId.isNotEmpty) {
        final subject = byId.first;

        // Select the subject in the cubit so the Chapters tab works properly
        context.read<SubjectSelectionCubit>().selectSubject(
          id: subject.id,
          name: subject.name,
          category: subject.category,
          description: subject.description,
          iconName: subject.iconName,
          subtitle: subject.subtitle ?? '',
        );

        if (chapterId.isNotEmpty && chapterId != study.id) {
          // Navigate directly to the chapter
          context.goNamed(
            AppRoutes.formulaDetailName,
            pathParameters: {'subjectId': subject.id, 'chapterId': chapterId},
            queryParameters: {'name': study.title},
          );
          return;
        } else {
          // Fallback to just the subject page if chapterId parsing fails
          _onSubjectTap(context, subject);
          return;
        }
      }
    }

    final byName = state.subjects
        .where((s) => s.name.toLowerCase() == study.subject.toLowerCase())
        .toList();
    if (byName.isNotEmpty) {
      _onSubjectTap(context, byName.first);
      return;
    }

    StatefulNavigationShell.of(context).goBranch(1);
  }
}

class _CarouselBanners extends StatefulWidget {
  const _CarouselBanners({required this.banners});
  final List<CarouselItem> banners;

  @override
  State<_CarouselBanners> createState() => _CarouselBannersState();
}

class _CarouselBannersState extends State<_CarouselBanners> {
  int _currentPage = 0;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SectionHeader(
          title: 'Featured Announcements',
          actionLabel: '',
          onAction: () {},
        ),
        const SizedBox(height: AppDimensions.paddingLG),
        CarouselSlider(
          options: CarouselOptions(
            height: 160.0,
            autoPlay: true,
            enlargeCenterPage: true,
            viewportFraction: 0.9,
            aspectRatio: 16 / 9,
            initialPage: 0,
            onPageChanged: (index, _) {
              setState(() => _currentPage = index);
            },
          ),
          items: widget.banners.map((banner) {
            return Builder(
              builder: (BuildContext context) {
                final bgColor = banner.bgColor != null
                    ? Color(
                        int.parse(banner.bgColor!.replaceFirst('#', '0xFF')),
                      )
                    : colorScheme.primaryContainer;
                return GestureDetector(
                  onTap: () async {
                    final uri = Uri.parse(banner.link);
                    if (await canLaunchUrl(uri)) {
                      await launchUrl(uri);
                    }
                  },
                  child: Semantics(
                    button: true,
                    label: banner.title,
                    child: Container(
                      width: MediaQuery.of(context).size.width,
                      margin: const EdgeInsets.symmetric(horizontal: 5.0),
                      decoration: BoxDecoration(
                        color: bgColor,
                        borderRadius: BorderRadius.circular(
                          AppDimensions.radiusXL,
                        ),
                      ),
                      clipBehavior: Clip.antiAlias,
                      child: Stack(
                        fit: StackFit.expand,
                        children: [
                          CachedNetworkImage(
                            imageUrl: banner.imageUrl,
                            fit: BoxFit.cover,
                            placeholder: (_, _) => Container(
                              color: bgColor,
                              child: const Center(
                                child: CircularProgressIndicator(
                                  strokeWidth: 2,
                                ),
                              ),
                            ),
                            errorWidget: (_, _, _) => Container(
                              color: bgColor,
                              child: Center(
                                child: Icon(
                                  LucideIcons.imageOff,
                                  color: colorScheme.onSurfaceVariant,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              },
            );
          }).toList(),
        ),
        if (widget.banners.length > 1)
          Padding(
            padding: const EdgeInsets.only(top: AppDimensions.paddingMD),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: List.generate(widget.banners.length, (i) {
                final isActive = i == _currentPage;
                return Semantics(
                  label: 'Banner ${i + 1} of ${widget.banners.length}',
                  button: true,
                  child: GestureDetector(
                    onTap: () => _currentPage = i,
                    child: AnimatedContainer(
                      duration: AppDurations.animationFast,
                      margin: const EdgeInsets.symmetric(
                        horizontal: AppDimensions.paddingXXS,
                      ),
                      width: isActive
                          ? AppDimensions.paddingXXL
                          : AppDimensions.paddingSM,
                      height: AppDimensions.paddingSM - 2,
                      decoration: BoxDecoration(
                        color: isActive
                            ? colorScheme.primary
                            : colorScheme.surfaceContainerHighest,
                        borderRadius: BorderRadius.circular(
                          AppDimensions.radiusXXL,
                        ),
                      ),
                    ),
                  ),
                );
              }),
            ),
          ),
      ],
    );
  }
}

class _AnnouncementBanner extends StatefulWidget {
  const _AnnouncementBanner({required this.announcements});
  final List<AppAnnouncement> announcements;

  @override
  State<_AnnouncementBanner> createState() => _AnnouncementBannerState();
}

class _AnnouncementBannerState extends State<_AnnouncementBanner> {
  final Set<String> _dismissed = {};

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final visible = widget.announcements
        .where((a) => !_dismissed.contains(a.id))
        .take(3)
        .toList();
    if (visible.isEmpty) return const SizedBox.shrink();

    return Semantics(
      label: 'Announcements',
      child: Column(
        children: visible.map((announcement) {
          final isUrgent = announcement.isUrgent;
          return Dismissible(
            key: ValueKey(announcement.id),
            direction: DismissDirection.horizontal,
            onDismissed: (_) {
              setState(() => _dismissed.add(announcement.id));
            },
            background: Container(
              alignment: Alignment.centerLeft,
              padding: const EdgeInsets.only(left: AppDimensions.paddingMD),
              decoration: BoxDecoration(
                color: colorScheme.surfaceContainerHighest,
                borderRadius: BorderRadius.circular(AppDimensions.radiusLG),
              ),
              child: Icon(Icons.close, color: colorScheme.onSurfaceVariant),
            ),
            child: Container(
              width: double.infinity,
              margin: const EdgeInsets.only(bottom: AppDimensions.paddingSM),
              padding: const EdgeInsets.symmetric(
                horizontal: AppDimensions.paddingMD,
                vertical: AppDimensions.paddingSM,
              ),
              decoration: BoxDecoration(
                color: isUrgent
                    ? colorScheme.errorContainer
                    : colorScheme.primaryContainer,
                borderRadius: BorderRadius.circular(AppDimensions.radiusLG),
                border: isUrgent
                    ? Border.all(
                        color: colorScheme.error.withValues(alpha: 0.5),
                      )
                    : null,
              ),
              child: Row(
                children: [
                  Icon(
                    isUrgent ? Icons.warning_rounded : Icons.campaign_rounded,
                    size: AppDimensions.iconMD,
                    color: isUrgent
                        ? colorScheme.onErrorContainer
                        : colorScheme.onPrimaryContainer,
                  ),
                  const SizedBox(width: AppDimensions.paddingSM),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          announcement.title,
                          style: AppTextStyles.labelMedium.copyWith(
                            fontWeight: FontWeight.w700,
                            color: isUrgent
                                ? colorScheme.onErrorContainer
                                : colorScheme.onPrimaryContainer,
                          ),
                        ),
                        Text(
                          announcement.message,
                          style: AppTextStyles.bodySmall.copyWith(
                            color: isUrgent
                                ? colorScheme.onErrorContainer
                                : colorScheme.onPrimaryContainer,
                          ),
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          );
        }).toList(),
      ),
    );
  }
}

/// A compact pill-shaped badge showing the active curriculum value.
class _CurriculumBadge extends StatelessWidget {
  const _CurriculumBadge({
    required this.icon,
    required this.iconColor,
    required this.label,
    required this.isActive,
    required this.activeColor,
  });
  final IconData icon;
  final Color iconColor;
  final String label;
  final bool isActive;
  final Color activeColor;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: AppDimensions.paddingMD,
        vertical: AppDimensions.paddingXS,
      ),
      decoration: BoxDecoration(
        color: activeColor.withValues(alpha: AppDimensions.opacityFaint),
        borderRadius: BorderRadius.circular(AppDimensions.radiusXXL),
        border: Border.all(
          color: activeColor.withValues(alpha: AppDimensions.opacitySubtle),
        ),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: AppDimensions.iconSM, color: iconColor),
          const SizedBox(width: AppDimensions.paddingXS),
          Text(
            label,
            style: AppTextStyles.labelSmall.copyWith(
              color: activeColor,
              fontWeight: FontWeight.w700,
            ),
          ),
        ],
      ),
    );
  }
}

/// A custom animated pill chip for board/grade selection.
///
/// Uses [AnimatedContainer] for a smooth visual transition between
/// selected and unselected states, providing a more polished feel
/// than the default [ChoiceChip].
class _CurriculumChip extends StatefulWidget {
  const _CurriculumChip({
    required this.label,
    this.subtitle,
    required this.selected,
    this.onTap,
  });

  final String label;
  final String? subtitle;
  final bool selected;
  final VoidCallback? onTap;

  @override
  State<_CurriculumChip> createState() => _CurriculumChipState();
}

class _CurriculumChipState extends State<_CurriculumChip> {
  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final selected = widget.selected;

    return GestureDetector(
      onTap: widget.onTap,
      child: Semantics(
        label: widget.label,
        selected: selected,
        button: true,
        child: AnimatedContainer(
          duration: AppDurations.animationFast,
          curve: AppDurations.curveDefault,
          padding: const EdgeInsets.symmetric(
            horizontal: AppDimensions.paddingLG,
            vertical: AppDimensions.paddingSM,
          ),
          decoration: BoxDecoration(
            color: selected
                ? colorScheme.primary
                : colorScheme.surfaceContainerLow,
            borderRadius: BorderRadius.circular(AppDimensions.radiusXXL),
            border: Border.all(
              color: selected
                  ? colorScheme.primary
                  : colorScheme.surfaceContainerHigh,
            ),
            boxShadow: selected ? const [AppShadows.chip] : null,
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              if (selected)
                Padding(
                  padding: const EdgeInsets.only(
                    right: AppDimensions.paddingXS,
                  ),
                  child: Icon(
                    LucideIcons.check,
                    size: AppDimensions.iconSM,
                    color: colorScheme.onPrimary,
                  ),
                ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    widget.label,
                    style: AppTextStyles.labelMedium.copyWith(
                      color: selected
                          ? colorScheme.onPrimary
                          : colorScheme.onSurface,
                      fontWeight: selected ? FontWeight.w700 : FontWeight.w500,
                    ),
                  ),
                  if (widget.subtitle != null)
                    Text(
                      widget.subtitle!,
                      style: AppTextStyles.labelSmall.copyWith(
                        color: selected
                            ? colorScheme.onPrimary.withValues(
                                alpha: AppDimensions.opacityMedium,
                              )
                            : colorScheme.onSurfaceVariant,
                        fontSize: AppDimensions.fontSizeXS,
                      ),
                    ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _ToolCard extends StatefulWidget {
  const _ToolCard({
    required this.icon,
    required this.label,
    required this.color,
    required this.onTap,
  });

  final IconData icon;
  final String label;
  final Color color;
  final VoidCallback onTap;

  @override
  State<_ToolCard> createState() => _ToolCardState();
}

class _ToolCardState extends State<_ToolCard>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  late final Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: AppDurations.instant,
    );
    _scaleAnimation = Tween<double>(begin: 1.0, end: 0.95).animate(
      CurvedAnimation(parent: _controller, curve: AppDurations.curvePremium),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return GestureDetector(
      onTapDown: (_) {
        HapticsHelper.selectionClick();
        _controller.forward();
      },
      onTapUp: (_) => _controller.reverse(),
      onTapCancel: () => _controller.reverse(),
      onTap: widget.onTap,
      child: AnimatedBuilder(
        animation: _scaleAnimation,
        builder: (context, child) {
          return Transform.scale(
            scale: _scaleAnimation.value,
            child: child,
          );
        },
        child: Container(
          padding: const EdgeInsets.all(AppDimensions.paddingLG),
          decoration: BoxDecoration(
            color: colorScheme.surfaceContainerLowest,
            borderRadius: BorderRadius.circular(AppDimensions.radiusXL),
            border: Border.all(
              color: widget.color.withValues(alpha: 0.15),
            ),
            boxShadow: const [AppShadows.soft],
          ),
          child: Column(
            children: [
              // Gradient icon background
              Container(
                padding: const EdgeInsets.all(AppDimensions.paddingMD),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [
                      widget.color.withValues(alpha: 0.15),
                      widget.color.withValues(alpha: 0.05),
                    ],
                  ),
                  borderRadius: BorderRadius.circular(AppDimensions.radiusMD),
                ),
                child: Icon(
                  widget.icon,
                  size: AppDimensions.iconLG,
                  color: widget.color,
                ),
              ),
              const SizedBox(height: AppDimensions.paddingSM),
              Text(
                widget.label,
                style: AppTextStyles.labelMedium.copyWith(
                  color: colorScheme.onSurface,
                  fontWeight: FontWeight.w600,
                ),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
