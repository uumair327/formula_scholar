import 'package:flutter/material.dart';

import '../../core/core.dart';

/// Premium gradient-filled button with press animation and loading state.
///
/// Replaces standard ElevatedButton for primary CTAs. Provides:
/// - Gradient background with customizable colors
/// - Press-down scale animation
/// - Loading spinner state
/// - Optional leading icon
class AppGradientButton extends StatefulWidget {
  const AppGradientButton({
    super.key,
    required this.label,
    required this.onPressed,
    this.gradient,
    this.icon,
    this.isLoading = false,
    this.isExpanded = true,
    this.height = 52.0,
    this.borderRadius = AppDimensions.radiusXL,
  });

  /// Button label text.
  final String label;

  /// Tap callback (disabled when [isLoading] is true).
  final VoidCallback? onPressed;

  /// Custom gradient (defaults to [AppColors.primaryGradient]).
  final Gradient? gradient;

  /// Optional leading icon.
  final IconData? icon;

  /// Whether the button shows a loading spinner.
  final bool isLoading;

  /// Whether the button expands to fill available width.
  final bool isExpanded;

  /// Button height.
  final double height;

  /// Corner radius.
  final double borderRadius;

  @override
  State<AppGradientButton> createState() => _AppGradientButtonState();
}

class _AppGradientButtonState extends State<AppGradientButton>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  late final Animation<double> _scaleAnimation;
  bool _isPressed = false;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: AppDurations.instant,
    );
    _scaleAnimation = Tween<double>(begin: 1.0, end: 0.96).animate(
      CurvedAnimation(parent: _controller, curve: AppDurations.curveSnap),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _handleTapDown(TapDownDetails details) {
    if (!widget.isLoading && widget.onPressed != null) {
      HapticsHelper.lightImpact();
      setState(() => _isPressed = true);
      _controller.forward();
    }
  }

  void _handleTapUp(TapUpDetails details) {
    _controller.reverse();
    setState(() => _isPressed = false);
  }

  void _handleTapCancel() {
    _controller.reverse();
    setState(() => _isPressed = false);
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final gradient = widget.gradient ??
        (isDark ? AppColors.darkPrimaryGradient : AppColors.primaryGradient);

    final isDisabled = widget.isLoading || widget.onPressed == null;

    return AnimatedBuilder(
      animation: _scaleAnimation,
      builder: (context, child) {
        return Transform.scale(
          scale: _scaleAnimation.value,
          child: child,
        );
      },
      child: GestureDetector(
        onTapDown: _handleTapDown,
        onTapUp: _handleTapUp,
        onTapCancel: _handleTapCancel,
        onTap: isDisabled ? null : widget.onPressed,
        child: AnimatedContainer(
          duration: AppDurations.animationFast,
          curve: AppDurations.curvePremium,
          height: widget.height,
          width: widget.isExpanded ? double.infinity : null,
          padding: EdgeInsets.symmetric(
            horizontal: widget.isExpanded
                ? AppDimensions.paddingXXL
                : AppDimensions.paddingSection,
          ),
          decoration: BoxDecoration(
            gradient: isDisabled ? null : gradient,
            color: isDisabled
                ? Theme.of(context).colorScheme.surfaceContainerHigh
                : null,
            borderRadius: BorderRadius.circular(widget.borderRadius),
            boxShadow: isDisabled || _isPressed
                ? null
                : [AppShadows.glow(Theme.of(context).colorScheme.primary)],
          ),
          child: Center(
            child: widget.isLoading
                ? SizedBox(
                    width: AppDimensions.iconDefault,
                    height: AppDimensions.iconDefault,
                    child: CircularProgressIndicator(
                      strokeWidth: AppDimensions.borderWidth,
                      color: Theme.of(context).colorScheme.onPrimary,
                    ),
                  )
                : Row(
                    mainAxisSize:
                        widget.isExpanded ? MainAxisSize.max : MainAxisSize.min,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      if (widget.icon != null) ...[
                        Icon(
                          widget.icon,
                          size: AppDimensions.iconMD,
                          color: isDisabled
                              ? Theme.of(context).colorScheme.onSurfaceVariant
                              : AppColors.white,
                        ),
                        const SizedBox(width: AppDimensions.paddingSM),
                      ],
                      Text(
                        widget.label,
                        style: AppTextStyles.labelLarge.copyWith(
                          color: isDisabled
                              ? Theme.of(context).colorScheme.onSurfaceVariant
                              : AppColors.white,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ],
                  ),
          ),
        ),
      ),
    );
  }
}
