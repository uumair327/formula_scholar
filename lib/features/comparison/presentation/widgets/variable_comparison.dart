import 'package:flutter/material.dart';
import 'package:flutter_math_fork/flutter_math.dart';
import 'package:lucide_icons/lucide_icons.dart';

import '../../../../../core/core.dart';
import '../../domain/entities/formula_comparison.dart';

class VariableComparison extends StatelessWidget {
  const VariableComparison({super.key, required this.comparison});

  final FormulaComparison comparison;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(AppDimensions.paddingMD),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(
                  LucideIcons.variable,
                  size: 18,
                  color: colorScheme.primary,
                ),
                const SizedBox(width: AppDimensions.paddingXS),
                Text(context.l10n.variablesLabel, style: AppTextStyles.titleSmall),
              ],
            ),
            const Divider(),
            if (comparison.hasSharedVariables) ...[
              _buildSection(
                context,
                'Shared',
                comparison.sharedVariables,
                colorScheme.primary,
              ),
              const SizedBox(height: AppDimensions.paddingSM),
            ],
            if (comparison.uniqueToA.isNotEmpty) ...[
              _buildSection(
                context,
                'Only in A',
                comparison.uniqueToA,
                colorScheme.error,
              ),
              const SizedBox(height: AppDimensions.paddingSM),
            ],
            if (comparison.uniqueToB.isNotEmpty)
              _buildSection(
                context,
                'Only in B',
                comparison.uniqueToB,
                colorScheme.secondary,
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildSection(
    BuildContext context,
    String label,
    Set<String> variables,
    Color color,
  ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: AppTextStyles.labelMedium.copyWith(
            color: color,
            fontWeight: FontWeight.w600,
          ),
        ),
        const SizedBox(height: AppDimensions.paddingXS),
        Wrap(
          spacing: AppDimensions.paddingXS,
          runSpacing: AppDimensions.paddingXS / 2,
          children: variables.map((v) {
            return Container(
              padding: const EdgeInsets.symmetric(
                horizontal: AppDimensions.paddingSM,
                vertical: AppDimensions.paddingXS / 2,
              ),
              decoration: BoxDecoration(
                color: color.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(AppDimensions.radiusSM),
                border: Border.all(color: color.withValues(alpha: 0.3)),
              ),
              child: Math.tex(
                v,
                textStyle: AppTextStyles.bodyMedium.copyWith(color: color),
              ),
            );
          }).toList(),
        ),
      ],
    );
  }
}
