library;

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:lucide_icons/lucide_icons.dart';

import '../../../../core/core.dart';

import 'tool_card.dart';

class QuickActionsSection extends StatelessWidget {
  const QuickActionsSection({
    super.key,
    this.sectionTitle = '',
    this.studyPlannerLabel = '',
    this.analyticsLabel = '',
    this.flashcardsLabel = '',
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
        SectionHeader(
          title: sectionTitle.isNotEmpty
              ? sectionTitle
              : context.l10n.exploreTools,
          actionLabel: null,
        ),
        const SizedBox(height: AppDimensions.paddingLG),
        Row(
          children: [
            Expanded(
              child: ToolCard(
                icon: LucideIcons.box,
                label: context.l10n.visualizer3d,
                color: colorScheme.primary,
                onTap: () => context.pushNamed(AppRoutes.visualizer3dName),
              ),
            ),
            const SizedBox(width: AppDimensions.paddingMD),
            Expanded(
              child: ToolCard(
                icon: LucideIcons.calendarCheck,
                label: studyPlannerLabel.isNotEmpty
                    ? studyPlannerLabel
                    : context.l10n.studyPlanner,
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
                label: analyticsLabel.isNotEmpty
                    ? analyticsLabel
                    : context.l10n.viewAnalytics,
                color: colorScheme.tertiary,
                onTap: () => context.pushNamed(AppRoutes.analyticsName),
              ),
            ),
            const SizedBox(width: AppDimensions.paddingMD),
            Expanded(
              child: ToolCard(
                icon: LucideIcons.layers,
                label: flashcardsLabel.isNotEmpty
                    ? flashcardsLabel
                    : context.l10n.flashcards,
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
