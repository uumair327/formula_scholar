import 'package:flutter/material.dart';
import 'package:lucide_icons/lucide_icons.dart';

import '../../../../../core/core.dart';

import '../../domain/entities/mastery_distribution.dart';
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
                            Flexible(
                              flex: dist.mastered,
                              child: Container(color: colorScheme.secondary),
                            ),
                          if (dist.inProgress > 0)
                            Flexible(
                              flex: dist.inProgress,
                              child: Container(color: colorScheme.tertiary),
                            ),
                          if (dist.notStarted > 0)
                            Flexible(
                              flex: dist.notStarted,
                              child: Container(
                                color: colorScheme.surfaceContainerHighest,
                              ),
                            ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: AppDimensions.paddingMD),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      _legendDot(
                        colorScheme.secondary,
                        'Mastered',
                        '${dist.mastered}',
                      ),
                      _legendDot(
                        colorScheme.tertiary,
                        'In Progress',
                        '${dist.inProgress}',
                      ),
                      _legendDot(
                        colorScheme.surfaceContainerHighest,
                        'Not Started',
                        '${dist.notStarted}',
                      ),
                    ],
                  ),
                ],
              )
            else
              Padding(
                padding: const EdgeInsets.symmetric(
                  vertical: AppDimensions.paddingLG,
                ),
                child: Center(
                  child: Text(
                    'No data yet',
                    style: AppTextStyles.bodyMedium.copyWith(
                      color: colorScheme.onSurfaceVariant,
                    ),
                  ),
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
        Container(
          width: 10,
          height: 10,
          decoration: BoxDecoration(color: color, shape: BoxShape.circle),
        ),
        const SizedBox(width: 6),
        Text('$label ($count)', style: AppTextStyles.labelSmall),
      ],
    );
  }
}
