import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lucide_icons/lucide_icons.dart';

import '../../../../core/core.dart';
import '../cubit/analytics_cubit.dart';
import '../cubit/analytics_state.dart';
import '../widgets/growth_trend_chart.dart';
import '../widgets/mastery_distribution_chart.dart';
import '../widgets/overview_cards.dart';
import '../widgets/recent_activity_list.dart';
import '../widgets/subject_performance_chart.dart';
import '../widgets/weekly_activity_chart.dart';

class AnalyticsPage extends StatelessWidget {
  const AnalyticsPage({super.key});

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final cubit = context.read<AnalyticsCubit>();
    return Scaffold(
      appBar: GlassAppBar(
        titleWidget: Text(
          'Analytics',
          style: AppTextStyles.titleMedium.copyWith(
            color: Theme.of(context).colorScheme.onSurface,
            fontWeight: FontWeight.w800,
          ),
        ),
      ),
      body: BlocBuilder<AnalyticsCubit, AnalyticsState>(
        buildWhen: (p, n) => p.status != n.status,
        builder: (context, state) {
          return switch (state.status) {
            AnalyticsStatus.initial || AnalyticsStatus.loading => const Center(
              child: CircularProgressIndicator(),
            ),
            AnalyticsStatus.error => AppErrorState(
              message: context.localizedError(
                fallback: state.errorMessage ?? 'Failed to load analytics',
              ),
              onRetry: cubit.load,
            ),
            AnalyticsStatus.loaded => _buildContent(
              context,
              state,
              colorScheme,
              cubit,
            ),
          };
        },
      ),
    );
  }

  Widget _buildContent(
    BuildContext context,
    AnalyticsState state,
    ColorScheme colorScheme,
    AnalyticsCubit cubit,
  ) {
    final data = state.data!;
    return DefaultTabController(
      length: 3,
      child: Column(
        children: [
          Container(
            color: colorScheme.surface,
            child: TabBar(
              labelColor: colorScheme.primary,
              unselectedLabelColor: colorScheme.onSurfaceVariant,
              indicatorColor: colorScheme.primary,
              indicatorWeight: 3,
              tabs: const [
                Tab(text: 'Overview', icon: Icon(LucideIcons.barChart3)),
                Tab(text: 'Performance', icon: Icon(LucideIcons.target)),
                Tab(text: 'Trends', icon: Icon(LucideIcons.trendingUp)),
              ],
            ),
          ),
          Expanded(
            child: TabBarView(
              children: [
                // TAB 1: Overview
                RefreshIndicator(
                  onRefresh: () async => cubit.load(),
                  child: ListView(
                    padding: const EdgeInsets.all(AppDimensions.paddingMD),
                    children: [
                      EntranceWrapper.stagger(
                        index: 0,
                        child: OverviewCards(data: data),
                      ),
                      const SizedBox(height: AppDimensions.paddingMD),
                      EntranceWrapper.stagger(
                        index: 1,
                        child: RecentActivityList(items: data.recentActivity),
                      ),
                    ],
                  ),
                ),
                // TAB 2: Performance
                RefreshIndicator(
                  onRefresh: () async => cubit.load(),
                  child: ListView(
                    padding: const EdgeInsets.all(AppDimensions.paddingMD),
                    children: [
                      EntranceWrapper.stagger(
                        index: 0,
                        child: MasteryDistributionChart(
                          distribution: data.masteryDistribution,
                        ),
                      ),
                      const SizedBox(height: AppDimensions.paddingMD),
                      if (state.growthMetrics != null)
                        EntranceWrapper.stagger(
                          index: 1,
                          child: SubjectPerformanceChart(
                            subjects: state.growthMetrics!.subjectBreakdown,
                            onSubjectTap: cubit.setSubjectFilter,
                          ),
                        ),
                    ],
                  ),
                ),
                // TAB 3: Trends
                RefreshIndicator(
                  onRefresh: () async => cubit.load(),
                  child: ListView(
                    padding: const EdgeInsets.all(AppDimensions.paddingMD),
                    children: [
                      EntranceWrapper.stagger(
                        index: 0,
                        child: WeeklyActivityChart(
                          activity: data.weeklyActivity,
                        ),
                      ),
                      const SizedBox(height: AppDimensions.paddingMD),
                      if (state.growthMetrics != null)
                        EntranceWrapper.stagger(
                          index: 1,
                          child: GrowthTrendChart(
                            weeklyGrowth: state.growthMetrics!.weeklyGrowth,
                            selectedMetric: state.selectedPeriod,
                            onMetricChanged: cubit.setPeriod,
                          ),
                        ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
