import 'package:flutter/material.dart';
import 'package:lucide_icons/lucide_icons.dart';

import '../../../../core/core.dart';

class AiSuggestionChips extends StatelessWidget {
  const AiSuggestionChips({super.key, required this.onSelected});

  final ValueChanged<String> onSelected;

  static const List<({String label, IconData icon, String subtitle})>
  _suggestions = [
    (
      label: 'Open practice',
      icon: LucideIcons.pencil,
      subtitle: 'Solve math and science practice quizzes',
    ),
    (
      label: 'Show saved formulas',
      icon: LucideIcons.bookmark,
      subtitle: 'View formulas you have bookmarked',
    ),
    (
      label: 'Open study planner',
      icon: LucideIcons.calendar,
      subtitle: 'Manage your study tasks and schedule',
    ),
    (
      label: 'Take me to profile',
      icon: LucideIcons.user,
      subtitle: 'View profile stats and settings',
    ),
    (
      label: 'Open AI settings',
      icon: LucideIcons.settings,
      subtitle: 'Configure your AI API keys and models',
    ),
  ];

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: AppDimensions.paddingXS,
          ),
          child: Text(
            'Quick Suggestions',
            style: AppTextStyles.labelLarge.copyWith(
              color: colorScheme.outline,
              fontWeight: FontWeight.w700,
              letterSpacing: AppDimensions.letterSpacingNormal,
            ),
          ),
        ),
        const SizedBox(height: AppDimensions.paddingMD),
        ListView.separated(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: _suggestions.length,
          separatorBuilder: (context, index) =>
              const SizedBox(height: AppDimensions.paddingSM),
          itemBuilder: (context, index) {
            final item = _suggestions[index];
            return AppCard(
              padding: const EdgeInsets.symmetric(
                horizontal: AppDimensions.paddingLG,
                vertical: AppDimensions.paddingMD,
              ),
              onTap: () => onSelected(item.label),
              child: Row(
                children: [
                  AppIconCircle(
                    icon: item.icon,
                    backgroundColor: colorScheme.primary.withValues(alpha: 0.1),
                    iconColor: colorScheme.primary,
                  ),
                  const SizedBox(width: AppDimensions.paddingMD),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          item.label,
                          style: AppTextStyles.labelLarge.copyWith(
                            color: colorScheme.onSurface,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                        const SizedBox(height: AppDimensions.paddingXXS),
                        Text(
                          item.subtitle,
                          style: AppTextStyles.bodySmall.copyWith(
                            color: colorScheme.onSurfaceVariant,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Icon(
                    LucideIcons.chevronRight,
                    size: AppDimensions.iconSM,
                    color: colorScheme.outline.withValues(alpha: 0.5),
                  ),
                ],
              ),
            );
          },
        ),
      ],
    );
  }
}
