import 'package:flutter/material.dart';
import 'package:lucide_icons/lucide_icons.dart';

import '../../../../../core/core.dart';
import '../../domain/entities/formula_comparison.dart';

class SimilarityBadge extends StatelessWidget {
  const SimilarityBadge({
    super.key,
    this.comparison,
  });

  final FormulaComparison? comparison;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    if (comparison == null) return const SizedBox.shrink();

    final score = comparison!.similarityScore;
    final label = score > 0.7
        ? 'High Similarity'
        : score > 0.4
            ? 'Moderate Similarity'
            : 'Low Similarity';
    final color = score > 0.7
        ? colorScheme.primary
        : score > 0.4
            ? colorScheme.secondary
            : colorScheme.error;

    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: AppDimensions.paddingMD,
        vertical: AppDimensions.paddingSM,
      ),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(AppDimensions.radiusMD),
        border: Border.all(color: color.withValues(alpha: 0.3)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(LucideIcons.percent, size: 16, color: color),
          const SizedBox(width: AppDimensions.paddingXS),
          Text(
            '$label — ${(score * 100).toInt()}%',
            style: AppTextStyles.labelLarge.copyWith(color: color),
          ),
        ],
      ),
    );
  }
}
