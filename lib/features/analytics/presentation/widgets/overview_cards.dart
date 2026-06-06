import 'package:flutter/material.dart';
import 'package:lucide_icons/lucide_icons.dart';

import '../../../../../core/core.dart';

import '../../domain/entities/analytics_data.dart';
import 'analytics_section_header.dart';
import 'analytics_stat_box.dart';

class OverviewCards extends StatelessWidget {
  const OverviewCards({super.key, required this.data});

  final AnalyticsData data;

  @override
  Widget build(BuildContext context) {
    return AppCard(
      child: Padding(
        padding: const EdgeInsets.all(AppDimensions.paddingMD),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const AnalyticsSectionHeader(
              icon: LucideIcons.barChart3,
              title: 'Overview',
            ),
            const SizedBox(height: AppDimensions.paddingMD),
            LayoutBuilder(
              builder: (context, constraints) {
                // Determine cross axis count based on available width
                final width = constraints.maxWidth;
                int crossAxisCount = 2;
                if (width > 600) {
                  crossAxisCount = 4;
                } else if (width > 400) {
                  crossAxisCount = 3;
                }

                return GridView.count(
                  crossAxisCount: crossAxisCount,
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  mainAxisSpacing: AppDimensions.paddingMD,
                  crossAxisSpacing: AppDimensions.paddingMD,
                  childAspectRatio: 1.1, // slightly wider than tall
                  children: [
                    AnalyticsStatBox(
                      value: '${data.totalFormulas}',
                      label: 'Formulas',
                      icon: LucideIcons.calculator,
                      color: Colors.blue,
                    ),
                    AnalyticsStatBox(
                      value: '${data.daysStreak}',
                      label: 'Day Streak',
                      icon: LucideIcons.zap,
                      color: Colors.orange,
                    ),
                    AnalyticsStatBox(
                      value: '${(data.quizAccuracy * 100).toInt()}%',
                      label: 'Accuracy',
                      icon: LucideIcons.award,
                      color: Colors.green,
                    ),
                    AnalyticsStatBox(
                      value: '${data.completedSessions}',
                      label: 'Sessions',
                      icon: LucideIcons.play,
                      color: Colors.purple,
                    ),
                    AnalyticsStatBox(
                      value: '${data.totalStudyMinutes}',
                      label: 'Study Mins',
                      icon: LucideIcons.clock,
                      color: Colors.teal,
                    ),
                    AnalyticsStatBox(
                      value: '${data.longestStreak}',
                      label: 'Best Streak',
                      icon: LucideIcons.flame,
                      color: Colors.red,
                    ),
                  ],
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
