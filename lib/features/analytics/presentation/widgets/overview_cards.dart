import 'package:flutter/material.dart';
import 'package:lucide_icons/lucide_icons.dart';

import '../../../../../core/core.dart';
import '../../../../../shared/shared.dart';
import '../../domain/entities/analytics_data.dart';
import 'analytics_section_header.dart';
import 'analytics_stat_box.dart';

class OverviewCards extends StatelessWidget {
  const OverviewCards({
    super.key,
    required this.data,
  });

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
            Wrap(
              spacing: AppDimensions.paddingMD,
              runSpacing: AppDimensions.paddingMD,
              children: [
                AnalyticsStatBox(value: '${data.totalFormulas}', label: 'Total Formulas', icon: LucideIcons.calculator),
                AnalyticsStatBox(value: '${data.daysStreak}', label: 'Day Streak', icon: LucideIcons.zap),
                AnalyticsStatBox(value: '${(data.quizAccuracy * 100).toInt()}%', label: 'Accuracy', icon: LucideIcons.award),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
