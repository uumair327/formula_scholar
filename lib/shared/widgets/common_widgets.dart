import 'package:flutter/material.dart';

import '../../core/core.dart';

/// Gradient box decoration matching the React app's `.signature-glow`.
///
/// Enhanced with richer gradient colors and subtle glow shadow.
BoxDecoration signatureGlowDecoration(ColorScheme colorScheme) {
  return BoxDecoration(
    gradient: LinearGradient(
      begin: Alignment.topLeft,
      end: Alignment.bottomRight,
      colors: [
        colorScheme.primary,
        colorScheme.primaryContainer,
      ],
    ),
    borderRadius: BorderRadius.circular(AppDimensions.radiusLG),
    boxShadow: [AppShadows.glow(colorScheme.primary)],
  );
}

/// Ghost shadow matching the React app's `.ghost-shadow`.
BoxDecoration ghostShadowDecoration({
  required Color color,
  double borderRadius = AppDimensions.radiusLG,
}) {
  return BoxDecoration(
    color: color,
    borderRadius: BorderRadius.circular(borderRadius),
    boxShadow: const [AppShadows.ghost],
  );
}

/// Animated gradient progress bar with shimmer effect.
///
/// Renders a horizontal progress bar with a gradient fill that
/// animates width changes smoothly.
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

  /// Optional gradient for the fill bar (overrides [barColor]).
  final Gradient? barGradient;

  final Color? backgroundColor;
  final double height;

  /// Whether to show a shimmer animation on the active bar.
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
      child: AnimatedFractionallySizedBox(
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

/// Category chip/tag widget with animated press state.
class CategoryChip extends StatelessWidget {
  const CategoryChip({
    super.key,
    required this.label,
    this.backgroundColor,
    this.textColor,
    this.icon,
  });
  final String label;
  final Color? backgroundColor;
  final Color? textColor;
  final IconData? icon;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: AppDimensions.paddingMD,
        vertical: AppDimensions.paddingXS,
      ),
      decoration: BoxDecoration(
        color: backgroundColor ?? colorScheme.primaryContainer.withValues(alpha: 0.2),
        borderRadius: BorderRadius.circular(AppDimensions.radiusXL),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (icon != null) ...[
            Icon(
              icon,
              size: AppDimensions.iconXS,
              color: textColor ?? colorScheme.primary,
            ),
            const SizedBox(width: AppDimensions.paddingXXS),
          ],
          Text(
            label.toUpperCase(),
            style: AppTextStyles.overline.copyWith(
              color: textColor ?? colorScheme.primary,
            ),
          ),
        ],
      ),
    );
  }
}

/// Section header with optional action and animated entrance.
class SectionHeader extends StatelessWidget {
  const SectionHeader({
    super.key,
    required this.title,
    this.actionLabel,
    this.onAction,
    this.subtitle,
  });
  final String title;
  final String? actionLabel;
  final VoidCallback? onAction;

  /// Optional subtitle below the title.
  final String? subtitle;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Expanded(
              child: Text(
                title,
                style: AppTextStyles.headlineMedium.copyWith(
                  fontWeight: FontWeight.w800,
                ),
              ),
            ),
            if (actionLabel != null)
              GestureDetector(
                onTap: onAction,
                behavior: HitTestBehavior.opaque,
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      actionLabel!,
                      style: AppTextStyles.labelLarge.copyWith(
                        color: colorScheme.primary,
                      ),
                    ),
                    const SizedBox(width: AppDimensions.paddingXXS),
                    Icon(
                      Icons.arrow_forward,
                      size: AppDimensions.iconSM,
                      color: colorScheme.primary,
                    ),
                  ],
                ),
              ),
          ],
        ),
        if (subtitle != null) ...[
          const SizedBox(height: AppDimensions.paddingXXS),
          Text(
            subtitle!,
            style: AppTextStyles.bodySmall.copyWith(
              color: colorScheme.onSurfaceVariant,
            ),
          ),
        ],
      ],
    );
  }
}

/// Animated fractionaly sized box for smooth progress bar transitions.
class AnimatedFractionallySizedBox extends ImplicitlyAnimatedWidget {
  const AnimatedFractionallySizedBox({
    super.key,
    required super.duration,
    super.curve = Curves.linear,
    this.alignment = Alignment.center,
    this.widthFactor,
    this.heightFactor,
    this.child,
  });

  final AlignmentGeometry alignment;
  final double? widthFactor;
  final double? heightFactor;
  final Widget? child;

  @override
  AnimatedWidgetBaseState<AnimatedFractionallySizedBox> createState() =>
      _AnimatedFractionallySizedBoxState();
}

class _AnimatedFractionallySizedBoxState
    extends AnimatedWidgetBaseState<AnimatedFractionallySizedBox> {
  Tween<double>? _widthFactor;
  Tween<double>? _heightFactor;

  @override
  void forEachTween(TweenVisitor<dynamic> visitor) {
    _widthFactor = visitor(
      _widthFactor,
      widget.widthFactor ?? 0.0,
      (value) => Tween<double>(begin: value as double),
    ) as Tween<double>?;
    _heightFactor = visitor(
      _heightFactor,
      widget.heightFactor ?? 0.0,
      (value) => Tween<double>(begin: value as double),
    ) as Tween<double>?;
  }

  @override
  Widget build(BuildContext context) {
    return FractionallySizedBox(
      alignment: widget.alignment,
      widthFactor: _widthFactor?.evaluate(animation),
      heightFactor: _heightFactor?.evaluate(animation),
      child: widget.child,
    );
  }
}
