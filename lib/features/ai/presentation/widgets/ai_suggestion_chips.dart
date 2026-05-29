import 'package:flutter/material.dart';
import 'package:lucide_icons/lucide_icons.dart';

import '../../../../core/core.dart';

class AiSuggestionChips extends StatelessWidget {
  const AiSuggestionChips({super.key, required this.onSelected});

  final ValueChanged<String> onSelected;

  static const List<String> _suggestions = [
    'Open practice',
    'Show saved formulas',
    'Open study planner',
    'Take me to profile',
    'Open AI settings',
  ];

  @override
  Widget build(BuildContext context) {
    return Wrap(
      spacing: AppDimensions.paddingSM,
      runSpacing: AppDimensions.paddingSM,
      children: [
        for (final suggestion in _suggestions)
          ActionChip(
            avatar: const Icon(LucideIcons.sparkles, size: 16),
            label: Text(suggestion),
            onPressed: () => onSelected(suggestion),
          ),
      ],
    );
  }
}
