import 'package:flutter/material.dart';
import 'package:flutter_math_fork/flutter_math.dart';

import '../../../../core/core.dart';
import '../../domain/domain.dart';

class FormulaLatexHero extends StatelessWidget {
  const FormulaLatexHero({
    super.key,
    required this.formula,
  });

  final Formula formula;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    return Padding(
      padding: const EdgeInsets.fromLTRB(
        AppDimensions.paddingXL,
        AppDimensions.paddingLG,
        AppDimensions.paddingXL,
        0,
      ),
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.symmetric(
          horizontal: AppDimensions.paddingXXL,
          vertical: AppDimensions.paddingSection,
        ),
        decoration: BoxDecoration(
          color: colorScheme.surfaceContainerLow,
          borderRadius: BorderRadius.circular(AppDimensions.radiusMD),
          border: Border.all(
            color: colorScheme.primary.withValues(alpha: 0.15),
            width: AppDimensions.borderWidth,
          ),
        ),
        child: Center(
          child: SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Math.tex(
              formula.latex,
              textStyle: AppTextStyles.headlineMedium.copyWith(
                color: colorScheme.onSurface,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
