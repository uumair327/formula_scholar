import 'package:flutter/material.dart';
import 'package:flutter_math_fork/flutter_math.dart';
import '../../../../core/core.dart';

class NativeFormulaWidget extends StatelessWidget {
  const NativeFormulaWidget({
    super.key,
    required this.latex,
    this.style,
  });

  final String latex;
  final TextStyle? style;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(AppDimensions.paddingXL),
      decoration: BoxDecoration(
        color: colorScheme.surfaceContainerLow,
        borderRadius: BorderRadius.circular(AppDimensions.radiusMD),
        border: Border.all(
          color: colorScheme.surfaceContainerHigh,
          width: AppDimensions.borderWidth,
        ),
      ),
      child: Center(
        child: SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Math.tex(
            latex,
            textStyle: style ??
                AppTextStyles.headlineSmall.copyWith(
                  color: colorScheme.onSurface,
                ),
          ),
        ),
      ),
    );
  }
}
