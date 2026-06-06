import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:lucide_icons/lucide_icons.dart';

import '../../../../../core/core.dart';

import '../../domain/entities/weekly_activity.dart';
import 'analytics_empty_state.dart';
import 'analytics_section_header.dart';

class WeeklyActivityChart extends StatelessWidget {
  const WeeklyActivityChart({super.key, required this.activity});

  final WeeklyActivity activity;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final maxVal = activity.values.reduce((a, b) => a > b ? a : b);

    return AppCard(
      child: Padding(
        padding: const EdgeInsets.all(AppDimensions.paddingMD),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const AnalyticsSectionHeader(
              icon: LucideIcons.calendar,
              title: 'Weekly Activity',
            ),
            const SizedBox(height: 4),
            Text(
              'Formulas reviewed per day',
              style: AppTextStyles.bodySmall.copyWith(
                color: colorScheme.onSurfaceVariant,
              ),
            ),
            const SizedBox(height: AppDimensions.paddingMD),
            if (maxVal == 0)
              const AnalyticsEmptyState(
                icon: LucideIcons.calendar,
                title: 'No Activity This Week',
                message:
                    'Start studying to fill up your weekly activity chart!',
                height: 180,
              )
            else
              SizedBox(
                height: 180,
                child: BarChart(
                  BarChartData(
                    alignment: BarChartAlignment.spaceAround,
                    maxY: (maxVal * 1.3).clamp(5, double.infinity),
                    barTouchData: BarTouchData(
                      enabled: true,
                      touchTooltipData: BarTouchTooltipData(
                        getTooltipItem: (group, groupIndex, rod, rodIndex) {
                          return BarTooltipItem(
                            '${activity.dayLabels[groupIndex]}\n${rod.toY.toInt()} formulas',
                            TextStyle(
                              color: colorScheme.onInverseSurface,
                              fontWeight: FontWeight.w600,
                              fontSize: 12,
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
                            final idx = value.toInt();
                            if (idx < 0 || idx >= activity.dayLabels.length) {
                              return const SizedBox.shrink();
                            }
                            return Padding(
                              padding: const EdgeInsets.only(top: 4),
                              child: Text(
                                activity.dayLabels[idx].substring(0, 3),
                                style: AppTextStyles.overline.copyWith(
                                  color: colorScheme.onSurfaceVariant,
                                ),
                              ),
                            );
                          },
                          reservedSize: 20,
                        ),
                      ),
                      leftTitles: AxisTitles(
                        sideTitles: SideTitles(
                          showTitles: true,
                          reservedSize: 32,
                          getTitlesWidget: (value, meta) {
                            if (value == 0) return const SizedBox.shrink();
                            return Text(
                              value.toInt().toString(),
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
                      horizontalInterval: maxVal > 0
                          ? (maxVal / 4).ceilToDouble()
                          : 1,
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
                    barGroups: List.generate(7, (i) {
                      final isHighest =
                          activity.values[i] == maxVal && maxVal > 0;
                      return BarChartGroupData(
                        x: i,
                        barRods: [
                          BarChartRodData(
                            toY: activity.values[i].toDouble().clamp(
                              4,
                              double.infinity,
                            ),
                            color: isHighest
                                ? colorScheme.primary
                                : (isDark
                                      ? AppColors
                                            .darkPrimaryGradient
                                            .colors
                                            .first
                                      : AppColors.primaryGradient.colors.first),
                            width: 20,
                            borderRadius: const BorderRadius.vertical(
                              top: Radius.circular(4),
                            ),
                            gradient: LinearGradient(
                              begin: Alignment.bottomCenter,
                              end: Alignment.topCenter,
                              colors: [
                                if (isHighest) ...[
                                  colorScheme.primary,
                                  colorScheme.primary.withValues(alpha: 0.6),
                                ] else ...[
                                  isDark
                                      ? AppColors
                                            .darkPrimaryGradient
                                            .colors
                                            .first
                                      : AppColors.primaryGradient.colors.first,
                                  isDark
                                      ? AppColors
                                            .darkPrimaryGradient
                                            .colors
                                            .last
                                      : AppColors.primaryGradient.colors.last,
                                ],
                              ],
                            ),
                          ),
                        ],
                      );
                    }),
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
