import 'package:flutter/material.dart';

import '../../../core/core.dart';
import 'animated_fractionally_sized_box.dart' show AppAnimatedFractionallySizedBox;


class ProgressBar extends StatelessWidget {
  const ProgressBar({
    super.key,
    required this.percentage,
    this.barColor,
    this.barGradient,
    this.backgroundColor,
    this.height = AppDimensions.progressBarDefault,
    this.showShimmer = false,
  });

  final double percentage;
  final Color? barColor;
  final Gradient? barGradient;
  final Color? backgroundColor;
  final double height;
  final bool showShimmer;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final fillFraction = (percentage / 100).clamp(0.0, 1.0);

    return Container(
      height: height,
      decoration: BoxDecoration(
        color: backgroundColor ??
            colorScheme.surfaceContainerHigh.withValues(alpha: 0.5),
        borderRadius: BorderRadius.circular(height),
      ),
      child: AppAnimatedFractionallySizedBox(
        alignment: Alignment.centerLeft,
        widthFactor: fillFraction,
        duration: AppDurations.animationSlow,
        curve: AppDurations.curvePremium,
        child: Container(
          decoration: BoxDecoration(
            gradient: barGradient ??
                (barColor != null
                    ? null
                    : AppColors.accentGradient),
            color: barGradient == null ? barColor : null,
            borderRadius: BorderRadius.circular(height),
          ),
        ),
      ),
    );
  }
}
