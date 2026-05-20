import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_math_fork/flutter_math.dart';
import 'package:lucide_icons/lucide_icons.dart';

import '../../../../core/core.dart';
import '../../../chapters/domain/entities/formula.dart';
import '../../domain/domain.dart';
import '../cubit/comparison_cubit.dart';
import '../cubit/comparison_state.dart';

class ComparisonPage extends StatelessWidget {
  const ComparisonPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Formula Comparison'),
        centerTitle: true,
        actions: [
          IconButton(
            onPressed: () => context.read<ComparisonCubit>().swap(),
            icon: const Icon(LucideIcons.arrowLeftRight),
            tooltip: 'Swap formulas',
          ),
        ],
      ),
      body: BlocBuilder<ComparisonCubit, ComparisonState>(
        builder: (context, state) {
          if (state.status == ComparisonStatus.initial) {
            return const Center(child: Text('Select two formulas to compare'));
          }

          return SingleChildScrollView(
            padding: const EdgeInsets.all(AppDimensions.paddingMD),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                _buildSimilarityBadge(context, state.comparison),
                const SizedBox(height: AppDimensions.paddingLG),
                _buildSideBySideFormulas(context, state),
                if (state.comparison != null) ...[
                  const SizedBox(height: AppDimensions.paddingLG),
                  _buildVariableComparison(context, state.comparison!),
                ],
                const SizedBox(height: 32),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildSimilarityBadge(
    BuildContext context,
    FormulaComparison? comparison,
  ) {
    final colorScheme = Theme.of(context).colorScheme;
    if (comparison == null) return const SizedBox.shrink();

    final score = comparison.similarityScore;
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

  Widget _buildSideBySideFormulas(
    BuildContext context,
    ComparisonState state,
  ) {
    final colorScheme = Theme.of(context).colorScheme;

    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          child: _FormulaCompareCard(
            formula: state.formulaA!,
            label: 'A',
            color: colorScheme.primary,
          ),
        ),
        const SizedBox(width: AppDimensions.paddingSM),
        Expanded(
          child: _FormulaCompareCard(
            formula: state.formulaB!,
            label: 'B',
            color: colorScheme.secondary,
          ),
        ),
      ],
    );
  }

  Widget _buildVariableComparison(
    BuildContext context,
    FormulaComparison comparison,
  ) {
    final colorScheme = Theme.of(context).colorScheme;

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(AppDimensions.paddingMD),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(LucideIcons.variable, size: 18, color: colorScheme.primary),
                const SizedBox(width: AppDimensions.paddingXS),
                Text('Variables', style: AppTextStyles.titleSmall),
              ],
            ),
            const Divider(),
            if (comparison.hasSharedVariables) ...[
              _buildVariableSection(
                context,
                'Shared',
                comparison.sharedVariables,
                colorScheme.primary,
              ),
              const SizedBox(height: AppDimensions.paddingSM),
            ],
            if (comparison.uniqueToA.isNotEmpty) ...[
              _buildVariableSection(
                context,
                'Only in A',
                comparison.uniqueToA,
                colorScheme.error,
              ),
              const SizedBox(height: AppDimensions.paddingSM),
            ],
            if (comparison.uniqueToB.isNotEmpty)
              _buildVariableSection(
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

  Widget _buildVariableSection(
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

class _FormulaCompareCard extends StatelessWidget {
  const _FormulaCompareCard({
    required this.formula,
    required this.label,
    required this.color,
  });

  final Formula formula;
  final String label;
  final Color color;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Card(
      color: color.withValues(alpha: 0.05),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(AppDimensions.radiusMD),
        side: BorderSide(color: color.withValues(alpha: 0.3)),
      ),
      child: Padding(
        padding: const EdgeInsets.all(AppDimensions.paddingMD),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: AppDimensions.paddingSM,
                    vertical: AppDimensions.paddingXS / 2,
                  ),
                  decoration: BoxDecoration(
                    color: color,
                    borderRadius: BorderRadius.circular(AppDimensions.radiusSM),
                  ),
                  child: Text(
                    label,
                    style: AppTextStyles.overline.copyWith(
                      color: AppColors.onPrimary,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: AppDimensions.paddingSM),
            Text(
              formula.title,
              style: AppTextStyles.titleMedium.copyWith(
                fontWeight: FontWeight.w700,
              ),
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
            const SizedBox(height: AppDimensions.paddingMD),
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(AppDimensions.paddingMD),
              decoration: BoxDecoration(
                color: colorScheme.surfaceContainerLow,
                borderRadius: BorderRadius.circular(AppDimensions.radiusMD),
              ),
              child: Center(
                child: FittedBox(
                  fit: BoxFit.scaleDown,
                  child: Math.tex(
                    formula.latex,
                    textStyle: AppTextStyles.headlineSmall.copyWith(
                      color: colorScheme.onSurface,
                    ),
                  ),
                ),
              ),
            ),
            if (formula.description.isNotEmpty) ...[
              const SizedBox(height: AppDimensions.paddingSM),
              Text(
                formula.description,
                style: AppTextStyles.bodySmall.copyWith(
                  color: colorScheme.onSurfaceVariant,
                  height: 1.5,
                ),
                maxLines: 3,
                overflow: TextOverflow.ellipsis,
              ),
            ],
          ],
        ),
      ),
    );
  }
}
