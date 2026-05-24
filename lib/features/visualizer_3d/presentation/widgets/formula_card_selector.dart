import 'package:flutter/material.dart';
import 'package:lucide_icons/lucide_icons.dart';

import '../../../../core/core.dart';
import '../../../../shared/shared.dart';
import '../../../../core/domain/entities/formula.dart';

class FormulaCardSelector extends StatelessWidget {
  const FormulaCardSelector({
    super.key,
    required this.formula,
    required this.index,
    required this.total,
    required this.onPrevious,
    required this.onNext,
  });

  final Formula formula;
  final int index;
  final int total;
  final VoidCallback onPrevious;
  final VoidCallback onNext;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return AppCard(
      color: colorScheme.surfaceContainerHighest.withValues(alpha: 0.8),
      child: Row(
        children: [
          IconButton(
            icon: Icon(
              Directionality.of(context) == TextDirection.rtl
                  ? LucideIcons.chevronRight
                  : LucideIcons.chevronLeft,
            ),
            onPressed: index > 0 ? onPrevious : null,
          ),
          Expanded(
            child: Column(
              children: [
                Text(
                  formula.title,
                  style: AppTextStyles.bodyMedium.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                  textAlign: TextAlign.center,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: AppDimensions.paddingXS),
                Text(
                  formula.latex,
                  style: AppTextStyles.bodySmall.copyWith(
                    fontFamily: 'monospace',
                    color: colorScheme.primary,
                    fontWeight: FontWeight.bold,
                  ),
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          ),
          IconButton(
            icon: Icon(
              Directionality.of(context) == TextDirection.rtl
                  ? LucideIcons.chevronLeft
                  : LucideIcons.chevronRight,
            ),
            onPressed: index < total - 1 ? onNext : null,
          ),
        ],
      ),
    );
  }
}
