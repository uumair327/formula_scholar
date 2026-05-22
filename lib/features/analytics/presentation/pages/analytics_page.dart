import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lucide_icons/lucide_icons.dart';

import '../../../../core/core.dart';
import '../../../../shared/shared.dart';
import '../../domain/entities/analytics_data.dart';
import '../../domain/entities/mastery_distribution.dart';
import '../../domain/entities/recent_activity_item.dart';
import '../../domain/entities/weekly_activity.dart';
import '../cubit/analytics_cubit.dart';
import '../cubit/analytics_state.dart';

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
        builder: (context, state) {
          return switch (state.status) {
            AnalyticsStatus.initial || AnalyticsStatus.loading => const Center(
              child: CircularProgressIndicator(),
            ),
            AnalyticsStatus.error => _buildError(state, colorScheme),
            AnalyticsStatus.loaded => _buildContent(state, colorScheme),
          };
        },
      ),
    );
  }

  Widget _buildError(AnalyticsState state, ColorScheme colorScheme) {
    return AppErrorState(
      message: state.errorMessage ?? 'Failed to load analytics',
      onRetry: () => context.read<AnalyticsCubit>().load(),
    );
  }

  Widget _buildContent(AnalyticsState state, ColorScheme colorScheme) {
    final data = state.data!;
    return RefreshIndicator(
      onRefresh: () async {
        context.read<AnalyticsCubit>().load();
      },
      child: SingleChildScrollView(
        physics: const AlwaysScrollableScrollPhysics(),
        padding: const EdgeInsets.all(AppDimensions.paddingMD),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            EntranceWrapper.stagger(
              index: 0,
              child: _overviewCards(data, colorScheme),
            ),
            const SizedBox(height: AppDimensions.paddingMD),
            EntranceWrapper.stagger(
              index: 1,
              child: _weeklyChart(data.weeklyActivity, colorScheme),
            ),
            const SizedBox(height: AppDimensions.paddingMD),
            EntranceWrapper.stagger(
              index: 2,
              child: _masteryChart(data.masteryDistribution, colorScheme),
            ),
            const SizedBox(height: AppDimensions.paddingMD),
            EntranceWrapper.stagger(
              index: 3,
              child: _recentActivity(data.recentActivity, colorScheme),
            ),
          ],
        ),
      ),
    );
  }

  Widget _overviewCards(AnalyticsData data, ColorScheme colorScheme) {
    return AppCard(
      child: Padding(
        padding: const EdgeInsets.all(AppDimensions.paddingMD),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _sectionHeader(LucideIcons.barChart3, 'Overview', colorScheme),
            const SizedBox(height: AppDimensions.paddingMD),
            Wrap(
              spacing: AppDimensions.paddingMD,
              runSpacing: AppDimensions.paddingMD,
              children: [
                _statBox('${data.totalFormulas}', 'Total Formulas', LucideIcons.calculator, colorScheme),
                _statBox('${data.daysStreak}', 'Day Streak', LucideIcons.zap, colorScheme),
                _statBox('${(data.quizAccuracy * 100).toInt()}%', 'Accuracy', LucideIcons.award, colorScheme),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _statBox(String value, String label, IconData icon, ColorScheme colorScheme) {
    return SizedBox(
      width: (MediaQuery.of(context).size.width - 80) / 3 - 8,
      child: Container(
        padding: const EdgeInsets.all(AppDimensions.paddingSM),
        decoration: BoxDecoration(
          color: colorScheme.surfaceContainerLow,
          borderRadius: BorderRadius.circular(AppDimensions.radiusMD),
        ),
        child: Column(
          children: [
            Icon(icon, color: colorScheme.primary, size: 20),
            const SizedBox(height: 4),
            Text(value, style: AppTextStyles.titleLarge.copyWith(fontWeight: FontWeight.w800)),
            Text(label, style: AppTextStyles.labelSmall.copyWith(color: colorScheme.onSurfaceVariant)),
          ],
        ),
      ),
    );
  }

  Widget _weeklyChart(WeeklyActivity activity, ColorScheme colorScheme) {
    return AppCard(
      child: Padding(
        padding: const EdgeInsets.all(AppDimensions.paddingMD),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _sectionHeader(LucideIcons.calendar, 'Weekly Activity', colorScheme),
            const SizedBox(height: 4),
            Text('Formulas reviewed per day',
              style: AppTextStyles.bodySmall.copyWith(color: colorScheme.onSurfaceVariant),
            ),
            const SizedBox(height: AppDimensions.paddingMD),
            SizedBox(
              height: 160,
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: List.generate(7, (i) {
                  final maxVal = activity.values.reduce((a, b) => a > b ? a : b);
                  final height = maxVal > 0 ? (activity.values[i] / maxVal) * 120 : 0.0;
                  return Expanded(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 4),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          Text('${activity.values[i]}',
                            style: AppTextStyles.overline.copyWith(color: colorScheme.onSurfaceVariant),
                          ),
                          const SizedBox(height: 4),
                          Container(
                            height: height.clamp(4, 120),
                            decoration: BoxDecoration(
                              gradient: Theme.of(context).brightness == Brightness.dark
                                  ? AppColors.darkPrimaryGradient
                                  : AppColors.primaryGradient,
                              borderRadius: const BorderRadius.vertical(top: Radius.circular(4)),
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(activity.dayLabels[i].substring(0, 1),
                            style: AppTextStyles.overline.copyWith(color: colorScheme.onSurfaceVariant),
                          ),
                        ],
                      ),
                    ),
                  );
                }),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _masteryChart(MasteryDistribution dist, ColorScheme colorScheme) {
    return AppCard(
      child: Padding(
        padding: const EdgeInsets.all(AppDimensions.paddingMD),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _sectionHeader(LucideIcons.pieChart, 'Mastery Distribution', colorScheme),
            const SizedBox(height: AppDimensions.paddingMD),
            if (dist.total > 0)
              Column(
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(AppDimensions.radiusMD),
                    child: SizedBox(
                      height: 24,
                      child: Row(
                        children: [
                          if (dist.mastered > 0)
                            Flexible(flex: dist.mastered, child: Container(color: colorScheme.secondary)),
                          if (dist.inProgress > 0)
                            Flexible(flex: dist.inProgress, child: Container(color: colorScheme.tertiary)),
                          if (dist.notStarted > 0)
                            Flexible(flex: dist.notStarted, child: Container(color: colorScheme.surfaceContainerHighest)),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: AppDimensions.paddingMD),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      _legendDot(colorScheme.secondary, 'Mastered', '${dist.mastered}'),
                      _legendDot(colorScheme.tertiary, 'In Progress', '${dist.inProgress}'),
                      _legendDot(colorScheme.surfaceContainerHighest, 'Not Started', '${dist.notStarted}'),
                    ],
                  ),
                ],
              )
            else
              Padding(
                padding: const EdgeInsets.symmetric(vertical: AppDimensions.paddingLG),
                child: Center(
                  child: Text('No data yet', style: AppTextStyles.bodyMedium.copyWith(
                    color: colorScheme.onSurfaceVariant,
                  )),
                ),
              ),
          ],
        ),
      ),
    );
  }

  Widget _legendDot(Color color, String label, String count) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(width: 10, height: 10, decoration: BoxDecoration(color: color, shape: BoxShape.circle)),
        const SizedBox(width: 6),
        Text('$label ($count)', style: AppTextStyles.labelSmall),
      ],
    );
  }

  Widget _recentActivity(List<RecentActivityItem> items, ColorScheme colorScheme) {
    return AppCard(
      child: Padding(
        padding: const EdgeInsets.all(AppDimensions.paddingMD),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _sectionHeader(LucideIcons.history, 'Recent Activity', colorScheme),
            const SizedBox(height: AppDimensions.paddingSM),
            if (items.isEmpty)
              Padding(
                padding: const EdgeInsets.symmetric(vertical: AppDimensions.paddingLG),
                child: Center(
                  child: Text('No recent activity',
                    style: AppTextStyles.bodyMedium.copyWith(color: colorScheme.onSurfaceVariant),
                  ),
                ),
              )
            else
              ...items.map((item) => Padding(
                padding: const EdgeInsets.symmetric(vertical: 6),
                child: Row(
                  children: [
                    AppIconCircle(
                      icon: item.isPositive ? LucideIcons.checkCircle : LucideIcons.trendingUp,
                      iconColor: item.isPositive ? colorScheme.secondary : colorScheme.primary,
                      backgroundColor: (item.isPositive ? colorScheme.secondary : colorScheme.primary).withValues(alpha: AppDimensions.opacityFaint),
                    ),
                    const SizedBox(width: AppDimensions.paddingSM),
                    Expanded(child: Text(item.title, style: AppTextStyles.bodyMedium)),
                    Text(item.timeAgo, style: AppTextStyles.labelSmall.copyWith(
                      color: colorScheme.onSurfaceVariant,
                    )),
                  ],
                ),
              )),
          ],
        ),
      ),
    );
  }

  Widget _sectionHeader(IconData icon, String title, ColorScheme colorScheme) {
    return Row(
      children: [
        Icon(icon, size: 18, color: colorScheme.primary),
        const SizedBox(width: 8),
        Text(title, style: AppTextStyles.titleMedium.copyWith(fontWeight: FontWeight.w700)),
      ],
    );
  }
}
