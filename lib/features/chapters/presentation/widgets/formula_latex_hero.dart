import 'package:flutter/material.dart';
import 'package:flutter_math_fork/flutter_math.dart';
import '../../domain/domain.dart';
import '../../../../core/core.dart';

class FormulaLatexHero extends StatelessWidget {
  const FormulaLatexHero({super.key, required this.formula});

  final Formula formula;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Padding(
      padding: const EdgeInsetsDirectional.fromSTEB(
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
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: isDark
                ? [
                    const Color(0xFF111827), // Deep cool gray
                    const Color(0xFF1F2937),
                  ]
                : [
                    colorScheme.surfaceContainerHighest.withValues(alpha: 0.3),
                    colorScheme.surfaceContainerHighest.withValues(alpha: 0.1),
                  ],
          ),
          borderRadius: BorderRadius.circular(AppDimensions.radiusXL),
          border: Border.all(
            color: isDark
                ? colorScheme.primary.withValues(alpha: 0.3)
                : colorScheme.primary.withValues(alpha: 0.15),
            width: AppDimensions.borderWidth,
          ),
          boxShadow: isDark
              ? [
                  BoxShadow(
                    color: colorScheme.primary.withValues(alpha: 0.1),
                    blurRadius: 20,
                    spreadRadius: -5,
                  ),
                ]
              : null,
        ),
        child: Center(
          child: SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Math.tex(
              formula.latex,
              textStyle: AppTextStyles.headlineMedium.copyWith(
                color: isDark ? Colors.white : colorScheme.onSurface,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
