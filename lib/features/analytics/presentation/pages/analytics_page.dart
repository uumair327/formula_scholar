import 'dart:math';
import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:lucide_icons/lucide_icons.dart';

import '../../../../core/core.dart';
import '../../../profile/profile.dart';

class AnalyticsPage extends StatelessWidget {
  const AnalyticsPage({super.key, required this.stats});

  final List<ProfileStat> stats;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Analytics'), centerTitle: true),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(AppDimensions.paddingMD),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildOverviewCards(context),
            const SizedBox(height: AppDimensions.paddingLG),
            _buildWeeklyChart(context),
            const SizedBox(height: AppDimensions.paddingLG),
            _buildMasteryChart(context),
            const SizedBox(height: AppDimensions.paddingLG),
            _buildRecentActivity(context),
          ],
        ),
      ),
    );
  }

  Widget _buildOverviewCards(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(AppDimensions.paddingLG),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(LucideIcons.barChart3, color: colorScheme.primary),
                const SizedBox(width: AppDimensions.paddingSM),
                Text(
                  'Overview',
                  style: AppTextStyles.titleMedium.copyWith(
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ],
            ),
            const SizedBox(height: AppDimensions.paddingMD),
            SizedBox(
              width: double.infinity,
              child: Wrap(
                spacing: AppDimensions.paddingMD,
                runSpacing: AppDimensions.paddingMD,
                children: stats.map((s) => _buildStatBox(context, s)).toList(),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStatBox(BuildContext context, ProfileStat stat) {
    final colorScheme = Theme.of(context).colorScheme;
    return SizedBox(
      width: (MediaQuery.of(context).size.width - 64) / 2 - 8,
      child: Container(
        padding: const EdgeInsets.all(AppDimensions.paddingMD),
        decoration: BoxDecoration(
          color: colorScheme.surfaceContainerLow,
          borderRadius: BorderRadius.circular(AppDimensions.radiusLG),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Icon(
              _resolveIcon(stat.iconName),
              color: colorScheme.primary,
              size: 22,
            ),
            const SizedBox(height: AppDimensions.paddingSM),
            Text(
              stat.value,
              style: AppTextStyles.headlineSmall.copyWith(
                fontWeight: FontWeight.w800,
              ),
            ),
            Text(
              stat.label,
              style: AppTextStyles.bodySmall.copyWith(
                color: colorScheme.onSurfaceVariant,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildWeeklyChart(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final days = ['Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun'];
    final rng = Random(42);
    final data = List.generate(7, (i) => (rng.nextDouble() * 8 + 1).toInt());

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(AppDimensions.paddingLG),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(LucideIcons.calendar, color: colorScheme.primary),
                const SizedBox(width: AppDimensions.paddingSM),
                Text(
                  'Weekly Activity',
                  style: AppTextStyles.titleMedium.copyWith(
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ],
            ),
            const SizedBox(height: AppDimensions.paddingSM),
            Text(
              'Formulas reviewed per day',
              style: AppTextStyles.bodySmall.copyWith(
                color: colorScheme.onSurfaceVariant,
              ),
            ),
            const SizedBox(height: AppDimensions.paddingLG),
            SizedBox(
              height: 200,
              child: BarChart(
                BarChartData(
                  alignment: BarChartAlignment.spaceAround,
                  maxY: data.reduce(max).toDouble() + 2,
                  barTouchData: BarTouchData(
                    touchTooltipData: BarTouchTooltipData(
                      getTooltipItem: (group, groupIndex, rod, rodIndex) {
                        return BarTooltipItem(
                          '${days[group.x.toInt()]}\n${rod.toY.toInt()} formulas',
                          TextStyle(
                            color: colorScheme.onPrimary,
                            fontWeight: FontWeight.w600,
                          ),
                        );
                      },
                    ),
                  ),
                  titlesData: FlTitlesData(
                    show: true,
                    bottomTitles: AxisTitles(
                      sideTitles: SideTitles(
                        showTitles: true,
                        getTitlesWidget: (value, meta) {
                          if (value.toInt() >= 0 && value.toInt() < 7) {
                            return Padding(
                              padding: const EdgeInsets.only(top: 8),
                              child: Text(
                                days[value.toInt()].substring(0, 1),
                                style: AppTextStyles.overline.copyWith(
                                  color: colorScheme.onSurfaceVariant,
                                ),
                              ),
                            );
                          }
                          return const SizedBox();
                        },
                      ),
                    ),
                    leftTitles: AxisTitles(
                      sideTitles: SideTitles(showTitles: false),
                    ),
                    topTitles: AxisTitles(
                      sideTitles: SideTitles(showTitles: false),
                    ),
                    rightTitles: AxisTitles(
                      sideTitles: SideTitles(showTitles: false),
                    ),
                  ),
                  gridData: FlGridData(
                    show: true,
                    drawVerticalLine: false,
                    horizontalInterval: 2,
                    getDrawingHorizontalLine: (value) => FlLine(
                      color: colorScheme.surfaceContainerHighest,
                      strokeWidth: 1,
                    ),
                  ),
                  borderData: FlBorderData(show: false),
                  barGroups: List.generate(7, (i) => BarChartGroupData(
                    x: i,
                    barRods: [
                      BarChartRodData(
                        toY: data[i].toDouble(),
                        color: colorScheme.primary,
                        width: 20,
                        borderRadius: const BorderRadius.only(
                          topLeft: Radius.circular(4),
                          topRight: Radius.circular(4),
                        ),
                      ),
                    ],
                  )),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMasteryChart(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final formulaStat = stats.where((s) => s.iconName == 'functions').firstOrNull;
    final total = formulaStat != null
        ? int.tryParse(formulaStat.value.replaceAll(RegExp(r'[^0-9]'), '')) ?? 0
        : 0;

    final mastered = total;
    final inProgress = max(3, total ~/ 3);
    final remaining = max(50 - mastered - inProgress, 1);

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(AppDimensions.paddingLG),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(LucideIcons.pieChart, color: colorScheme.primary),
                const SizedBox(width: AppDimensions.paddingSM),
                Text(
                  'Mastery Distribution',
                  style: AppTextStyles.titleMedium.copyWith(
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ],
            ),
            const SizedBox(height: AppDimensions.paddingLG),
            SizedBox(
              height: 180,
              child: Row(
                children: [
                  Expanded(
                    child: PieChart(
                      PieChartData(
                        sectionsSpace: 2,
                        centerSpaceRadius: 40,
                        sections: [
                          PieChartSectionData(
                            value: mastered.toDouble(),
                            color: Colors.green,
                            title: '$mastered',
                            titleStyle: TextStyle(
                              color: Colors.green.shade800,
                              fontWeight: FontWeight.w700,
                              fontSize: 14,
                            ),
                            radius: 30,
                          ),
                          PieChartSectionData(
                            value: inProgress.toDouble(),
                            color: Colors.orange,
                            title: '$inProgress',
                            titleStyle: TextStyle(
                              color: Colors.orange.shade800,
                              fontWeight: FontWeight.w700,
                              fontSize: 14,
                            ),
                            radius: 30,
                          ),
                          PieChartSectionData(
                            value: remaining.toDouble(),
                            color: colorScheme.surfaceContainerHighest,
                            title: '$remaining',
                            titleStyle: TextStyle(
                              color: colorScheme.onSurfaceVariant,
                              fontWeight: FontWeight.w700,
                              fontSize: 14,
                            ),
                            radius: 30,
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(width: AppDimensions.paddingMD),
                  Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _legendDot(Colors.green, 'Mastered'),
                      const SizedBox(height: 8),
                      _legendDot(Colors.orange, 'In Progress'),
                      const SizedBox(height: 8),
                      _legendDot(
                        colorScheme.surfaceContainerHighest,
                        'Not Started',
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildRecentActivity(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(AppDimensions.paddingLG),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(LucideIcons.history, color: colorScheme.primary),
                const SizedBox(width: AppDimensions.paddingSM),
                Text(
                  'Recent Activity',
                  style: AppTextStyles.titleMedium.copyWith(
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ],
            ),
            const SizedBox(height: AppDimensions.paddingMD),
            _activityRow(context, 'Studied Algebra', '2 hours ago', Icons.check_circle, Colors.green),
            const Divider(height: AppDimensions.paddingLG),
            _activityRow(context, 'Completed Quiz: Geometry', 'Yesterday', Icons.check_circle, Colors.green),
            const Divider(height: AppDimensions.paddingLG),
            _activityRow(context, 'Mastered 3 formulas', '2 days ago', Icons.trending_up, Colors.blue),
            const Divider(height: AppDimensions.paddingLG),
            _activityRow(context, 'Studied Calculus', '3 days ago', Icons.access_time, Colors.grey),
          ],
        ),
      ),
    );
  }

  Widget _activityRow(
    BuildContext context,
    String title,
    String time,
    IconData icon,
    Color color,
  ) {
    final colorScheme = Theme.of(context).colorScheme;
    return Row(
      children: [
        Icon(icon, size: 20, color: color),
        const SizedBox(width: AppDimensions.paddingMD),
        Expanded(
          child: Text(
            title,
            style: AppTextStyles.bodyMedium.copyWith(
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
        Text(
          time,
          style: AppTextStyles.overline.copyWith(
            color: colorScheme.onSurfaceVariant,
          ),
        ),
      ],
    );
  }

  Widget _legendDot(Color color, String label) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: 10,
          height: 10,
          decoration: BoxDecoration(color: color, shape: BoxShape.circle),
        ),
        const SizedBox(width: 6),
        Text(label, style: const TextStyle(fontSize: 12)),
      ],
    );
  }

  IconData _resolveIcon(String iconName) {
    return switch (iconName) {
      'functions' => LucideIcons.functionSquare,
      'fire' => LucideIcons.flame,
      'stars' => LucideIcons.sparkles,
      _ => LucideIcons.barChart3,
    };
  }
}
