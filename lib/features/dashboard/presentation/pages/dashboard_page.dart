import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/core.dart';
import '../cubit/dashboard_cubit.dart';
import '../cubit/dashboard_state.dart';
import '../cubit/daily_challenges_cubit.dart';
import '../widgets/widgets.dart';
import '../widgets/dashboard_sections.dart';

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
              SnackBar(
                content: Text(context.l10n.curriculumUpdated),
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
                            DashboardAnnouncementSection(state: state),
                            const SizedBox(
                              height: AppDimensions.paddingSection,
                            ),
                            EntranceWrapper(
                              child: DashboardHeroSection(
                                state: state,
                                onResume: (ctx, s) => resumeLearning(ctx, s),
                              ),
                            ),
                            const SizedBox(
                              height: AppDimensions.paddingSection,
                            ),
                            DashboardBannersSection(state: state),
                            const SizedBox(
                              height: AppDimensions.paddingSection,
                            ),
                            EntranceWrapper(
                              delay: const Duration(milliseconds: 100),
                              child: DashboardQuickActionsSection(state: state),
                            ),
                            const SizedBox(
                              height: AppDimensions.paddingSection,
                            ),
                            EntranceWrapper(
                              delay: const Duration(milliseconds: 100),
                              child: DashboardAcademicPathSection(
                                state: state,
                                onSubjectTap: onSubjectTap,
                                showSubjectAnalytics: showSubjectAnalytics,
                              ),
                            ),
                            const SizedBox(
                              height: AppDimensions.paddingSection,
                            ),
                            EntranceWrapper(
                              delay: const Duration(milliseconds: 150),
                              child: DashboardFormulaVaultSection(state: state),
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
