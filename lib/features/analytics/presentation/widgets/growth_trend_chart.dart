import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:lucide_icons/lucide_icons.dart';

import '../../../../../core/core.dart';

import '../../domain/entities/growth_metrics.dart';
import 'analytics_empty_state.dart';
import 'analytics_section_header.dart';

class GrowthTrendChart extends StatelessWidget {
  const GrowthTrendChart({
    super.key,
    required this.weeklyGrowth,
    required this.selectedMetric,
    this.onMetricChanged,
  });

  final List<WeeklyGrowthPoint> weeklyGrowth;
  final String selectedMetric;
  final void Function(String)? onMetricChanged;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    if (weeklyGrowth.isEmpty ||
        weeklyGrowth.every(
          (p) => p.sessions == 0 && p.minutes == 0 && p.formulasLearned == 0,
        )) {
      return const AppCard(
        child: Padding(
          padding: EdgeInsets.all(AppDimensions.paddingMD),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              AnalyticsSectionHeader(
                icon: LucideIcons.trendingUp,
                title: 'Growth Trend',
              ),
              SizedBox(height: AppDimensions.paddingMD),
              AnalyticsEmptyState(
                icon: LucideIcons.trendingUp,
                title: 'No Growth Data Yet',
                message:
                    'Start learning formulas to see your growth trend over time.',
                height: 200,
              ),
            ],
          ),
        ),
      );
    }

    final spots = weeklyGrowth.asMap().entries.map((entry) {
      final value = switch (selectedMetric) {
        'sessions' => entry.value.sessions.toDouble(),
        'minutes' => entry.value.minutes.toDouble(),
        'accuracy' => entry.value.accuracy * 100,
        'formulas' => entry.value.formulasLearned.toDouble(),
        _ => entry.value.sessions.toDouble(),
      };
      return FlSpot(entry.key.toDouble(), value);
    }).toList();

    var maxY = spots.map((s) => s.y).reduce((a, b) => a > b ? a : b);
    var minY = spots.map((s) => s.y).reduce((a, b) => a < b ? a : b);

    if (maxY == minY) {
      maxY += 10;
      minY = (minY - 10).clamp(0, double.infinity);
    }

    return AppCard(
      child: Padding(
        padding: const EdgeInsets.all(AppDimensions.paddingMD),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                const AnalyticsSectionHeader(
                  icon: LucideIcons.trendingUp,
                  title: 'Growth Trend',
                ),
                const Spacer(),
                _MetricChip(
                  label: 'Sessions',
                  selected: selectedMetric == 'sessions',
                  onTap: () => onMetricChanged?.call('sessions'),
                ),
                const SizedBox(width: 4),
                _MetricChip(
                  label: 'Minutes',
                  selected: selectedMetric == 'minutes',
                  onTap: () => onMetricChanged?.call('minutes'),
                ),
                const SizedBox(width: 4),
                _MetricChip(
                  label: 'Accuracy',
                  selected: selectedMetric == 'accuracy',
                  onTap: () => onMetricChanged?.call('accuracy'),
                ),
              ],
            ),
            const SizedBox(height: AppDimensions.paddingMD),
            SizedBox(
              height: 200,
              child: LineChart(
                LineChartData(
                  minY: (minY - (maxY - minY) * 0.1).clamp(0, double.infinity),
                  maxY: maxY + (maxY - minY) * 0.2,
                  lineTouchData: LineTouchData(
                    enabled: true,
                    touchTooltipData: LineTouchTooltipData(
                      getTooltipItems: (touchedSpots) {
                        return touchedSpots.map((spot) {
                          final point = weeklyGrowth[spot.spotIndex];
                          return LineTooltipItem(
                            '${point.weekLabel}\n${spot.y.toStringAsFixed(1)}',
                            TextStyle(
                              color: colorScheme.onInverseSurface,
                              fontWeight: FontWeight.w600,
                              fontSize: 12,
                            ),
                          );
                        }).toList();
                      },
                    ),
                  ),
                  titlesData: FlTitlesData(
                    show: true,
                    bottomTitles: AxisTitles(
                      sideTitles: SideTitles(
                        showTitles: true,
                        reservedSize: 22,
                        interval: 1,
                        getTitlesWidget: (value, meta) {
                          final idx = value.toInt();
                          if (idx < 0 || idx >= weeklyGrowth.length) {
                            return const SizedBox.shrink();
                          }
                          if (weeklyGrowth.length > 6 && idx % 2 != 0) {
                            return const SizedBox.shrink();
                          }
                          return Padding(
                            padding: const EdgeInsets.only(top: 4),
                            child: Text(
                              weeklyGrowth[idx].weekLabel,
                              style: AppTextStyles.overline.copyWith(
                                color: colorScheme.onSurfaceVariant,
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                    leftTitles: AxisTitles(
                      sideTitles: SideTitles(
                        showTitles: true,
                        reservedSize: 40,
                        getTitlesWidget: (value, meta) {
                          return Text(
                            selectedMetric == 'accuracy'
                                ? '${value.toInt()}%'
                                : value.toInt().toString(),
                            style: AppTextStyles.overline.copyWith(
                              color: colorScheme.onSurfaceVariant,
                            ),
                          );
                        },
                      ),
                    ),
                    topTitles: const AxisTitles(
                      sideTitles: SideTitles(showTitles: false),
                    ),
                    rightTitles: const AxisTitles(
                      sideTitles: SideTitles(showTitles: false),
                    ),
                  ),
                  gridData: FlGridData(
                    show: true,
                    drawVerticalLine: false,
                    getDrawingHorizontalLine: (value) {
                      return FlLine(
                        color: colorScheme.outlineVariant.withValues(
                          alpha: 0.3,
                        ),
                        strokeWidth: 1,
                      );
                    },
                  ),
                  borderData: FlBorderData(show: false),
                  lineBarsData: [
                    LineChartBarData(
                      spots: spots,
                      isCurved: true,
                      preventCurveOverShooting: true,
                      color: colorScheme.primary,
                      barWidth: 3,
                      isStrokeCapRound: true,
                      dotData: FlDotData(
                        show: true,
                        getDotPainter: (spot, percent, barData, index) {
                          return FlDotCirclePainter(
                            radius: 4,
                            color: colorScheme.primary,
                            strokeWidth: 2,
                            strokeColor: colorScheme.surface,
                          );
                        },
                      ),
                      belowBarData: BarAreaData(
                        show: true,
                        color: colorScheme.primary.withValues(alpha: 0.1),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _MetricChip extends StatelessWidget {
  const _MetricChip({
    required this.label,
    required this.selected,
    required this.onTap,
  });

  final String label;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
        decoration: BoxDecoration(
          color: selected ? colorScheme.primaryContainer : Colors.transparent,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: selected ? colorScheme.primary : colorScheme.outlineVariant,
          ),
        ),
        child: Text(
          label,
          style: AppTextStyles.labelSmall.copyWith(
            color: selected
                ? colorScheme.onPrimaryContainer
                : colorScheme.onSurfaceVariant,
            fontWeight: selected ? FontWeight.w700 : FontWeight.w400,
          ),
        ),
      ),
    );
  }
}
