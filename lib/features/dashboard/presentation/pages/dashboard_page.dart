import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/core.dart';
import '../cubit/dashboard_cubit.dart';
import '../cubit/dashboard_state.dart';
import '../cubit/daily_challenges_cubit.dart';
import '../widgets/widgets.dart';

class DashboardPage extends StatelessWidget {
  const DashboardPage({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocListener(
      listeners: [
        BlocListener<LocalizationCubit, LocalizationState>(
          listenWhen: (prev, curr) =>
              prev.contentLocalizationEnabled !=
                  curr.contentLocalizationEnabled ||
              prev.contentLocaleCode != curr.contentLocaleCode,
          listener: (context, state) {
            final dashboardCubit = context.read<DashboardCubit>();
            dashboardCubit.setContentLocaleCode(
              state.effectiveContentLocaleCode,
              contentLocalizationEnabled: state.contentLocalizationEnabled,
            );
            if (dashboardCubit.state.status != DashboardStatus.initial) {
              Future.microtask(dashboardCubit.loadDashboard);
            }
          },
        ),
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
                      colorValue: s.colorValue,
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
                  context.localizedError(
                    fallback:
                        state.errorMessage ?? 'Failed to refresh dashboard',
                  ),
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
                  final isDesktop =
                      constraints.maxWidth >= AppDimensions.breakpointDesktop;
                  final hp = isDesktop
                      ? ((constraints.maxWidth -
                                    AppDimensions.breakpointMaxContent) /
                                2)
                            .clamp(
                              AppDimensions.paddingSectionLG,
                              double.infinity,
                            )
                      : AppDimensions.paddingXL;
                  return CustomScrollView(
                    slivers: [
                      const DashboardAppBar(),
                      SliverPadding(
                        padding: EdgeInsets.symmetric(horizontal: hp),
                        sliver: SliverList(
                          delegate: SliverChildListDelegate([
                            if (state.announcements
                                .where(
                                  (a) => a.isUrgent || a.isHighPriority || true,
                                )
                                .isNotEmpty)
                              AnnouncementBanner(
                                announcements: state.announcements,
                                dismissedAnnouncementIds:
                                    state.dismissedAnnouncementIds,
                                currentIndex: state.currentAnnouncementIndex,
                                onPageChanged: (index) => context
                                    .read<DashboardCubit>()
                                    .setAnnouncementIndex(index),
                                onDismiss: (id) => context
                                    .read<DashboardCubit>()
                                    .dismissAnnouncement(id),
                              ),
                            const SizedBox(
                              height: AppDimensions.paddingSection,
                            ),
                            EntranceWrapper(
                              child: Builder(
                                builder: (context) {
                                  final String heroBadge =
                                      (state.localizedContent['dashboard.hero.badge']
                                              ?.trim()
                                              .isNotEmpty ??
                                          false)
                                      ? state
                                            .localizedContent['dashboard.hero.badge']!
                                      : context.l10n.dashboardHeroBadge;

                                  final String heroTitle =
                                      (state.localizedContent['dashboard.hero.title']
                                              ?.trim()
                                              .isNotEmpty ??
                                          false)
                                      ? state
                                            .localizedContent['dashboard.hero.title']!
                                      : context.l10n.dashboardHeroTitle;

                                  final progressVal =
                                      state.progress?.masteryPercentage
                                          .toInt() ??
                                      0;
                                  String heroDescription;
                                  if (state
                                          .localizedContent['dashboard.hero.description']
                                          ?.trim()
                                          .isNotEmpty ??
                                      false) {
                                    heroDescription = state
                                        .localizedContent['dashboard.hero.description']!
                                        .replaceAll(
                                          '{progress}',
                                          progressVal.toString(),
                                        );
                                  } else {
                                    heroDescription = context.l10n
                                        .dashboardHeroDescription(progressVal);
                                  }

                                  final String resumeLabel =
                                      (state.localizedContent['dashboard.hero.resume']
                                              ?.trim()
                                              .isNotEmpty ??
                                          false)
                                      ? state
                                            .localizedContent['dashboard.hero.resume']!
                                      : context.l10n.dashboardResumeLesson;

                                  final String semanticLabel =
                                      (state.localizedContent['dashboard.hero.resumeSemantic']
                                              ?.trim()
                                              .isNotEmpty ??
                                          false)
                                      ? state
                                            .localizedContent['dashboard.hero.resumeSemantic']!
                                      : context.l10n.dashboardResumeSemantic;

                                  return HeroStatusCard(
                                    badge: heroBadge,
                                    title: heroTitle,
                                    description: heroDescription,
                                    resumeLabel: resumeLabel,
                                    semanticLabel: semanticLabel,
                                    onResume: () =>
                                        resumeLearning(context, state),
                                  );
                                },
                              ),
                            ),
                            const SizedBox(
                              height: AppDimensions.paddingSection,
                            ),
                            if (state.banners
                                .where((b) => b.isActive)
                                .isNotEmpty)
                              EntranceWrapper(
                                delay: const Duration(milliseconds: 50),
                                child: CarouselBanners(
                                  banners: state.banners,
                                  currentPage: state.currentBannerIndex,
                                  onPageChanged: (index) => context
                                      .read<DashboardCubit>()
                                      .setBannerIndex(index),
                                ),
                              ),
                            const SizedBox(
                              height: AppDimensions.paddingSection,
                            ),
                            EntranceWrapper(
                              delay: const Duration(milliseconds: 100),
                              child: Builder(
                                builder: (context) {
                                  final sectionTitle =
                                      (state.localizedContent['dashboard.quickActions.title']
                                              ?.trim()
                                              .isNotEmpty ??
                                          false)
                                      ? state
                                            .localizedContent['dashboard.quickActions.title']!
                                      : context.l10n.quickActionsTitle;

                                  final studyPlannerLabel =
                                      (state.localizedContent['dashboard.quickActions.studyPlanner']
                                              ?.trim()
                                              .isNotEmpty ??
                                          false)
                                      ? state
                                            .localizedContent['dashboard.quickActions.studyPlanner']!
                                      : context.l10n.studyPlanner;

                                  final analyticsLabel =
                                      (state.localizedContent['dashboard.quickActions.analytics']
                                              ?.trim()
                                              .isNotEmpty ??
                                          false)
                                      ? state
                                            .localizedContent['dashboard.quickActions.analytics']!
                                      : context.l10n.viewAnalytics;

                                  final flashcardsLabel =
                                      (state.localizedContent['dashboard.quickActions.flashcards']
                                              ?.trim()
                                              .isNotEmpty ??
                                          false)
                                      ? state
                                            .localizedContent['dashboard.quickActions.flashcards']!
                                      : context.l10n.flashcards;

                                  return QuickActionsSection(
                                    sectionTitle: sectionTitle,
                                    studyPlannerLabel: studyPlannerLabel,
                                    analyticsLabel: analyticsLabel,
                                    flashcardsLabel: flashcardsLabel,
                                  );
                                },
                              ),
                            ),
                            const SizedBox(
                              height: AppDimensions.paddingSection,
                            ),
                            EntranceWrapper(
                              delay: const Duration(milliseconds: 100),
                              child: BlocProvider(
                                create: (_) => getIt<DailyChallengesCubit>(),
                                child: AcademicPathSection(
                                  subjects: state.subjects,
                                  onSubjectTap: (subject) =>
                                      onSubjectTap(context, subject),
                                  onShowAnalytics: (subject) =>
                                      showSubjectAnalytics(
                                        context,
                                        state,
                                        subject,
                                      ),
                                  onViewAll: () {
                                    context
                                        .read<SubjectSelectionCubit>()
                                        .clearSelection();
                                    StatefulNavigationShell.of(
                                      context,
                                    ).goBranch(1);
                                  },
                                ),
                              ),
                            ),
                            const SizedBox(
                              height: AppDimensions.paddingSection,
                            ),
                            EntranceWrapper(
                              delay: const Duration(milliseconds: 150),
                              child: Builder(
                                builder: (context) {
                                  final vaultDesc =
                                      (state.localizedContent['dashboard.vault.description']
                                              ?.trim()
                                              .isNotEmpty ??
                                          false)
                                      ? state
                                            .localizedContent['dashboard.vault.description']!
                                      : context.l10n
                                            .dashboardVaultDescWithCounts(
                                              state.subjects.fold<int>(
                                                0,
                                                (sum, s) =>
                                                    sum + s.formulaCount,
                                              ),
                                              state.subjects.length,
                                            );
                                  return FormulaVaultSection(
                                    description: vaultDesc,
                                    vaultItems: state.vaultItems,
                                    subjects: state.subjects,
                                    onSubjectTap: (subject) =>
                                        onSubjectTap(context, subject),
                                  );
                                },
                              ),
                            ),
                            const SizedBox(height: AppDimensions.paddingLG),
                            EntranceWrapper(
                              delay: const Duration(milliseconds: 200),
                              child: ContinueStudyingSection(
                                recentStudies: state.recentStudies,
                                subjects: state.subjects,
                                onSubjectTap: (subject) =>
                                    onSubjectTap(context, subject),
                              ),
                            ),
                            if (state.weakAreas.isNotEmpty) ...[
                              const SizedBox(
                                height: AppDimensions.paddingSection,
                              ),
                              EntranceWrapper(
                                delay: const Duration(milliseconds: 250),
                                child: WeakAreasSection(
                                  weakAreas: state.weakAreas,
                                ),
                              ),
                            ],
                            const SizedBox(
                              height: AppDimensions.bottomNavPadding,
                            ),
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
}
