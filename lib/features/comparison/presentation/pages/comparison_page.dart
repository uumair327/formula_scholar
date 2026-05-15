import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_math_fork/flutter_math.dart';
import 'package:lucide_icons/lucide_icons.dart';

import '../../../../core/core.dart';
import '../../../chapters/domain/entities/formula.dart';
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
              children: [
                _FormulaCompareCard(
                  formula: state.formulaA!,
                  label: 'Formula A',
                  color: AppColors.primary,
                ),
                const SizedBox(height: AppDimensions.paddingMD),
                Icon(
                  LucideIcons.arrowDown,
                  size: 24,
                  color: Theme.of(context).colorScheme.outline,
                ),
                const SizedBox(height: AppDimensions.paddingMD),
                _FormulaCompareCard(
                  formula: state.formulaB!,
                  label: 'Formula B',
                  color: AppColors.secondary,
                ),
              ],
            ),
          );
        },
      ),
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
        padding: const EdgeInsets.all(AppDimensions.paddingLG),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: AppDimensions.paddingSM,
                    vertical: AppDimensions.paddingXS,
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
            const SizedBox(height: AppDimensions.paddingMD),
            Text(
              formula.title,
              style: AppTextStyles.titleLarge.copyWith(
                fontWeight: FontWeight.w700,
              ),
            ),
            const SizedBox(height: AppDimensions.paddingLG),
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(AppDimensions.paddingLG),
              decoration: BoxDecoration(
                color: colorScheme.surfaceContainerLow,
                borderRadius: BorderRadius.circular(AppDimensions.radiusMD),
              ),
              child: Center(
                child: FittedBox(
                  fit: BoxFit.scaleDown,
                  child: Math.tex(
                    formula.latex,
                    textStyle: AppTextStyles.headlineMedium.copyWith(
                      color: colorScheme.onSurface,
                    ),
                  ),
                ),
              ),
            ),
            if (formula.description.isNotEmpty) ...[
              const SizedBox(height: AppDimensions.paddingMD),
              Text(
                formula.description,
                style: AppTextStyles.bodyMedium.copyWith(
                  color: colorScheme.onSurfaceVariant,
                  height: 1.5,
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
