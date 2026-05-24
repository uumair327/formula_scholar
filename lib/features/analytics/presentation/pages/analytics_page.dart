import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/core.dart';
import '../../../../shared/shared.dart';
import '../cubit/analytics_cubit.dart';
import '../cubit/analytics_state.dart';
import '../widgets/mastery_distribution_chart.dart';
import '../widgets/overview_cards.dart';
import '../widgets/recent_activity_list.dart';
import '../widgets/weekly_activity_chart.dart';

class AnalyticsPage extends StatefulWidget {
  const AnalyticsPage({super.key});

  @override
  State<AnalyticsPage> createState() => _AnalyticsPageState();
}

class _AnalyticsPageState extends State<AnalyticsPage> {
  @override
  void initState() {
    super.initState();
    context.read<AnalyticsCubit>().load();
  }

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
              message: state.errorMessage ?? 'Failed to load analytics',
              onRetry: cubit.load,
            ),
            AnalyticsStatus.loaded => _buildContent(state, colorScheme),
          };
        },
      ),
    );
  }

  Widget _buildContent(AnalyticsState state, ColorScheme colorScheme) {
    final data = state.data!;
    return RefreshIndicator(
      onRefresh: () async {
        await context.read<AnalyticsCubit>().load();
      },
      child: SingleChildScrollView(
        physics: const AlwaysScrollableScrollPhysics(),
        padding: const EdgeInsets.all(AppDimensions.paddingMD),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            EntranceWrapper.stagger(
              index: 0,
              child: OverviewCards(data: data),
            ),
            const SizedBox(height: AppDimensions.paddingMD),
            EntranceWrapper.stagger(
              index: 1,
              child: WeeklyActivityChart(activity: data.weeklyActivity),
            ),
            const SizedBox(height: AppDimensions.paddingMD),
            EntranceWrapper.stagger(
              index: 2,
              child: MasteryDistributionChart(distribution: data.masteryDistribution),
            ),
            const SizedBox(height: AppDimensions.paddingMD),
            EntranceWrapper.stagger(
              index: 3,
              child: RecentActivityList(items: data.recentActivity),
            ),
          ],
        ),
      ),
    );
  }
}
