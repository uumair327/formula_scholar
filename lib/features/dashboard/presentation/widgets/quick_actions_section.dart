library;

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:lucide_icons/lucide_icons.dart';

import '../../../../core/core.dart';
import '../../../../shared/shared.dart';
import 'tool_card.dart';

class QuickActionsSection extends StatelessWidget {
  const QuickActionsSection({super.key});

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SectionHeader(
          title: AppStrings.exploreTools,
          actionLabel: null,
        ),
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
                label: 'Study Planner',
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
                label: 'Analytics',
                color: colorScheme.tertiary,
                onTap: () => context.pushNamed(AppRoutes.analyticsName),
              ),
            ),
            const SizedBox(width: AppDimensions.paddingMD),
            Expanded(
              child: ToolCard(
                icon: LucideIcons.layers,
                label: 'Flashcards',
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
