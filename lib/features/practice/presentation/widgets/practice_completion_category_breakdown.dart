import 'package:flutter/material.dart';

import '../../../../core/core.dart';

import '../cubit/practice_state.dart';

class CategoryBreakdown extends StatelessWidget {
  const CategoryBreakdown({super.key, required this.state});
  final PracticeState state;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final categories = <String, _CatStats>{};

    for (final r in state.answerRecords) {
      categories.putIfAbsent(r.category, () => _CatStats());
      categories[r.category]!.total++;
      if (r.isCorrect) categories[r.category]!.correct++;
    }

    return AppCard(
      padding: const EdgeInsets.all(AppDimensions.paddingXXL),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            context.l10n.perCategory,
            style: AppTextStyles.titleMedium.copyWith(
              fontWeight: FontWeight.w700,
            ),
          ),
          const SizedBox(height: AppDimensions.paddingMD),
          ...categories.entries.map((entry) {
            final pct = entry.value.total > 0
                ? (entry.value.correct / entry.value.total) * 100
                : 0.0;
            return Padding(
              padding: const EdgeInsets.only(bottom: AppDimensions.paddingMD),
              child: Row(
                children: [
                  Expanded(
                    flex: 2,
                    child: Text(
                      entry.key,
                      style: AppTextStyles.bodySmall.copyWith(
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                  const SizedBox(width: AppDimensions.paddingMD),
                  Expanded(
                    flex: 3,
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(
                        AppDimensions.radiusSM,
                      ),
                      child: LinearProgressIndicator(
                        value: pct / 100,
                        backgroundColor: colorScheme.surfaceContainerHighest,
                        color: pct >= 80
                            ? colorScheme.secondary
                            : pct >= 50
                            ? colorScheme.tertiary
                            : colorScheme.error,
                        minHeight: AppDimensions.progressBarSM,
                      ),
                    ),
                  ),
                  const SizedBox(width: AppDimensions.paddingMD),
                  SizedBox(
                    width: 36,
                    child: Text(
                      '${pct.round()}%',
                      textAlign: TextAlign.end,
                      style: AppTextStyles.labelSmall.copyWith(
                        fontWeight: FontWeight.w700,
                        color: colorScheme.onSurfaceVariant,
                      ),
                    ),
                  ),
                ],
              ),
            );
          }),
        ],
      ),
    );
  }
}

class _CatStats {
  int total = 0;
  int correct = 0;
}
