import 'package:flutter/material.dart';

import '../../../../core/core.dart';
import '../../../../shared/shared.dart';

class PreFilterTimedModeCard extends StatelessWidget {
  const PreFilterTimedModeCard({
    super.key,
    required this.isTimed,
    required this.timedDuration,
    required this.onTimedChanged,
    required this.onDurationChanged,
  });

  final bool isTimed;
  final int? timedDuration;
  final ValueChanged<bool> onTimedChanged;
  final ValueChanged<int?> onDurationChanged;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Column(
      children: [
        AppCard(
          child: Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      AppStrings.timedMode,
                      style: AppTextStyles.titleSmall.copyWith(
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    const SizedBox(height: AppDimensions.paddingXXS),
                    Text(
                      AppStrings.timedModeDesc,
                      style: AppTextStyles.bodySmall.copyWith(
                        color: colorScheme.onSurfaceVariant,
                      ),
                    ),
                  ],
                ),
              ),
              Switch(
                value: isTimed,
                onChanged: (v) {
                  onTimedChanged(v);
                  if (!v) onDurationChanged(null);
                },
              ),
            ],
          ),
        ),
        if (isTimed) ...[
          const SizedBox(height: AppDimensions.paddingSM),
          AppCard(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  AppStrings.duration,
                  style: AppTextStyles.titleSmall.copyWith(
                    fontWeight: FontWeight.w700,
                  ),
                ),
                const SizedBox(height: AppDimensions.paddingMD),
                Wrap(
                  spacing: AppDimensions.paddingSM,
                  runSpacing: AppDimensions.paddingSM,
                  children: [5, 10, 15, 30, 60].map((mins) {
                    return ChoiceChip(
                      label: Text('$mins min'),
                      selected: timedDuration == mins * 60,
                      onSelected: (_) => onDurationChanged(mins * 60),
                    );
                  }).toList(),
                ),
              ],
            ),
          ),
        ],
      ],
    );
  }
}
