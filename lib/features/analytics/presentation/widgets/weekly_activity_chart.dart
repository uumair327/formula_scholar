import 'package:flutter/material.dart';
import 'package:lucide_icons/lucide_icons.dart';

import '../../../../../core/core.dart';

import '../../domain/entities/weekly_activity.dart';
import 'analytics_section_header.dart';

class WeeklyActivityChart extends StatelessWidget {
  const WeeklyActivityChart({super.key, required this.activity});

  final WeeklyActivity activity;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

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
            SizedBox(
              height: 160,
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: List.generate(7, (i) {
                  final maxVal = activity.values.reduce(
                    (a, b) => a > b ? a : b,
                  );
                  final height = maxVal > 0
                      ? (activity.values[i] / maxVal) * 120
                      : 0.0;
                  return Expanded(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 4),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          Text(
                            '${activity.values[i]}',
                            style: AppTextStyles.overline.copyWith(
                              color: colorScheme.onSurfaceVariant,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Container(
                            height: height.clamp(4, 120),
                            decoration: BoxDecoration(
                              gradient:
                                  Theme.of(context).brightness ==
                                      Brightness.dark
                                  ? AppColors.darkPrimaryGradient
                                  : AppColors.primaryGradient,
                              borderRadius: const BorderRadius.vertical(
                                top: Radius.circular(4),
                              ),
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            activity.dayLabels[i].substring(0, 1),
                            style: AppTextStyles.overline.copyWith(
                              color: colorScheme.onSurfaceVariant,
                            ),
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
}
