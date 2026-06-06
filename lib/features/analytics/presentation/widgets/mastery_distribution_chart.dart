import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:lucide_icons/lucide_icons.dart';

import '../../../../../core/core.dart';

import '../../domain/entities/mastery_distribution.dart';
import 'analytics_empty_state.dart';
import 'analytics_section_header.dart';

class MasteryDistributionChart extends StatelessWidget {
  const MasteryDistributionChart({super.key, required this.distribution});

  final MasteryDistribution distribution;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final dist = distribution;

    return AppCard(
      child: Padding(
        padding: const EdgeInsets.all(AppDimensions.paddingMD),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const AnalyticsSectionHeader(
              icon: LucideIcons.pieChart,
              title: 'Mastery Distribution',
            ),
            if (dist.total == 0)
              const AnalyticsEmptyState(
                icon: LucideIcons.pieChart,
                title: 'No Mastery Data',
                message:
                    'Start learning formulas to see your mastery distribution.',
                height: 180,
              )
            else
              Column(
                children: [
                  SizedBox(
                    height: 180,
                    child: PieChart(
                      PieChartData(
                        sectionsSpace: 2,
                        centerSpaceRadius: 40,
                        sections: [
                          if (dist.mastered > 0)
                            PieChartSectionData(
                              value: dist.mastered.toDouble(),
                              title: '${dist.mastered}',
                              color: colorScheme.secondary,
                              radius: 50,
                              titleStyle: AppTextStyles.labelSmall.copyWith(
                                color: colorScheme.onSecondary,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                          if (dist.inProgress > 0)
                            PieChartSectionData(
                              value: dist.inProgress.toDouble(),
                              title: '${dist.inProgress}',
                              color: colorScheme.tertiary,
                              radius: 50,
                              titleStyle: AppTextStyles.labelSmall.copyWith(
                                color: colorScheme.onTertiary,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                          if (dist.notStarted > 0)
                            PieChartSectionData(
                              value: dist.notStarted.toDouble(),
                              title: '${dist.notStarted}',
                              color: colorScheme.surfaceContainerHighest,
                              radius: 50,
                              titleStyle: AppTextStyles.labelSmall.copyWith(
                                color: colorScheme.onSurfaceVariant,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                        ],
                        pieTouchData: PieTouchData(
                          touchCallback: (event, pieTouchResponse) {},
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: AppDimensions.paddingMD),
                  Wrap(
                    spacing: 16,
                    runSpacing: 8,
                    alignment: WrapAlignment.center,
                    children: [
                      _legendDot(
                        colorScheme.secondary,
                        'Mastered',
                        '${dist.mastered}',
                        (dist.mastered / dist.total * 100).toInt(),
                      ),
                      _legendDot(
                        colorScheme.tertiary,
                        'In Progress',
                        '${dist.inProgress}',
                        (dist.inProgress / dist.total * 100).toInt(),
                      ),
                      _legendDot(
                        colorScheme.surfaceContainerHighest,
                        'Not Started',
                        '${dist.notStarted}',
                        (dist.notStarted / dist.total * 100).toInt(),
                      ),
                    ],
                  ),
                ],
              ),
          ],
        ),
      ),
    );
  }

  Widget _legendDot(Color color, String label, String count, int percent) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: 10,
          height: 10,
          decoration: BoxDecoration(color: color, shape: BoxShape.circle),
        ),
        const SizedBox(width: 6),
        Text('$label $count ($percent%)', style: AppTextStyles.labelSmall),
      ],
    );
  }
}
