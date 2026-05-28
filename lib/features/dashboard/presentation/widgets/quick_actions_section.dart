library;

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:lucide_icons/lucide_icons.dart';

import '../../../../core/core.dart';
import '../../../../shared/shared.dart';
import 'tool_card.dart';

class QuickActionsSection extends StatelessWidget {
  const QuickActionsSection({
    super.key,
    this.sectionTitle = AppStrings.exploreTools,
    this.studyPlannerLabel = AppStrings.studyPlanner,
    this.analyticsLabel = AppStrings.viewAnalytics,
    this.flashcardsLabel = AppStrings.flashcards,
  });

  final String sectionTitle;
  final String studyPlannerLabel;
  final String analyticsLabel;
  final String flashcardsLabel;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SectionHeader(title: sectionTitle, actionLabel: null),
        const SizedBox(height: AppDimensions.paddingLG),
        Row(
          children: [
            Expanded(
              child: ToolCard(
                icon: LucideIcons.box,
                label: AppStrings.visualizer3d,
                color: colorScheme.primary,
                onTap: () => context.pushNamed(AppRoutes.visualizer3dName),
              ),
            ),
            const SizedBox(width: AppDimensions.paddingMD),
            Expanded(
              child: ToolCard(
                icon: LucideIcons.calendarCheck,
                label: studyPlannerLabel,
                color: colorScheme.secondary,
                onTap: () => context.pushNamed(AppRoutes.studyPlannerName),
              ),
            ),
          ],
        ),
        const SizedBox(height: AppDimensions.paddingMD),
        Row(
          children: [
            Expanded(
              child: ToolCard(
                icon: LucideIcons.barChart3,
                label: analyticsLabel,
                color: colorScheme.tertiary,
                onTap: () => context.pushNamed(AppRoutes.analyticsName),
              ),
            ),
            const SizedBox(width: AppDimensions.paddingMD),
            Expanded(
              child: ToolCard(
                icon: LucideIcons.layers,
                label: flashcardsLabel,
                color: colorScheme.primary,
                onTap: () => context.pushNamed(AppRoutes.flashcardsName),
              ),
            ),
          ],
        ),
      ],
    );
  }
}
