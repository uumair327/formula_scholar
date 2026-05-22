import 'dart:ui';

import 'package:flutter/material.dart';

import '../../core/core.dart';

/// Reusable ghost-shadow card container used across the app.
///
/// Wraps its child in the standard surface card styling with the
/// ghost shadow, rounded corners, and optional padding. Supports:
/// - Press-down scale animation via [onTap]
/// - Hover shadow elevation
/// - Custom borders and gradients
class AppCard extends StatefulWidget {
  const AppCard({
    super.key,
    required this.child,
    this.color,
    this.borderRadius = AppDimensions.radiusLG,
    this.padding = const EdgeInsets.all(AppDimensions.paddingXL),
    this.boxShadow = const [AppShadows.ghost],
    this.border,
    this.clipBehavior = Clip.none,
    this.onTap,
    this.onLongPress,
    this.animate = true,
  });

  /// Child widget rendered inside the card.
  final Widget child;

  /// Card background colour.
  final Color? color;

  /// Corner radius.
  final double borderRadius;

  /// Inner padding.
  final EdgeInsetsGeometry padding;

  /// Optional box shadow override.
  final List<BoxShadow> boxShadow;

  /// Optional border.
  final BoxBorder? border;

  /// Clip behaviour for content that overflows the rounded corners.
  final Clip clipBehavior;

  /// Tap callback — enables press animation.
  final VoidCallback? onTap;

  /// Long-press callback.
  final VoidCallback? onLongPress;

  /// Whether to animate press/hover states.
  final bool animate;

  @override
  State<AppCard> createState() => _AppCardState();
}

class _AppCardState extends State<AppCard>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  late final Animation<double> _scaleAnimation;
  bool _isHovered = false;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: AppDurations.instant,
    );
    _scaleAnimation = Tween<double>(
      begin: 1.0,
      end: AppDimensions.cardPressScale,
    ).animate(
      CurvedAnimation(parent: _controller, curve: AppDurations.curvePremium),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  bool get _interactive =>
      widget.animate && (widget.onTap != null || widget.onLongPress != null);

  void _handleTapDown(TapDownDetails _) {
    if (_interactive) _controller.forward();
  }

  void _handleTapUp(TapUpDetails _) {
    if (_interactive) _controller.reverse();
  }

  void _handleTapCancel() {
    if (_interactive) _controller.reverse();
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final cardColor = widget.color ??
        Theme.of(context).cardTheme.color ??
        colorScheme.surfaceContainerLowest;

    final shadow = _isHovered && _interactive
        ? const [AppShadows.cardHover]
        : widget.boxShadow;

    final Widget card = AnimatedContainer(
      duration: AppDurations.animationFast,
      curve: AppDurations.curvePremium,
      padding: widget.padding,
      clipBehavior: widget.clipBehavior,
      decoration: BoxDecoration(
        color: cardColor,
        borderRadius: BorderRadius.circular(widget.borderRadius),
        border: widget.border,
        boxShadow: shadow,
      ),
      child: widget.child,
    );

    if (!_interactive) return card;

    return MouseRegion(
      cursor: SystemMouseCursors.click,
      onEnter: (_) => setState(() => _isHovered = true),
      onExit: (_) => setState(() => _isHovered = false),
      child: GestureDetector(
        onTapDown: _handleTapDown,
        onTapUp: _handleTapUp,
        onTapCancel: _handleTapCancel,
        onTap: widget.onTap,
        onLongPress: widget.onLongPress,
        behavior: HitTestBehavior.opaque,
        child: AnimatedBuilder(
          animation: _scaleAnimation,
          builder: (context, child) {
            return Transform.scale(
              scale: _scaleAnimation.value,
              child: child,
            );
          },
          child: card,
        ),
      ),
    );
  }
}

/// Glass-morphism card with backdrop blur effect.
///
/// Uses [BackdropFilter] to create a frosted-glass appearance.
/// Ideal for overlays, floating cards, and premium UI elements.
class AppGlassCard extends StatelessWidget {
  const AppGlassCard({
    super.key,
    required this.child,
    this.borderRadius = AppDimensions.radiusLG,
    this.padding = const EdgeInsets.all(AppDimensions.paddingXL),
    this.blurSigma = AppDimensions.glassBlurSigma,
    this.onTap,
  });

  final Widget child;
  final double borderRadius;
  final EdgeInsetsGeometry padding;
  final double blurSigma;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    Widget card = ClipRRect(
      borderRadius: BorderRadius.circular(borderRadius),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: blurSigma, sigmaY: blurSigma),
        child: Container(
          padding: padding,
          decoration: BoxDecoration(
            color: isDark ? AppColors.glassDark : AppColors.glassLight,
            borderRadius: BorderRadius.circular(borderRadius),
            border: Border.all(
              color: isDark
                  ? AppColors.glassBorderDark
                  : AppColors.glassBorderLight,
            ),
          ),
          child: child,
        ),
      ),
    );

    if (onTap != null) {
      card = GestureDetector(
        onTap: onTap,
        behavior: HitTestBehavior.opaque,
        child: card,
      );
    }

    return card;
  }
}

/// Reusable section title row with bold title and optional action label.
///
/// Identical to [SectionHeader] but with a more flexible API: supports
/// custom title style and leading icon.
class AppSectionTitle extends StatelessWidget {
  const AppSectionTitle({
    super.key,
    required this.title,
    this.actionLabel,
    this.onAction,
    this.leadingIcon,
    this.leadingIconColor,
  });

  /// Section title text.
  final String title;

  /// Optional trailing action label.
  final String? actionLabel;

  /// Callback when the action label is tapped.
  final VoidCallback? onAction;

  /// Optional leading icon.
  final IconData? leadingIcon;

  /// Colour of the leading icon.
  final Color? leadingIconColor;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: AppDimensions.paddingXS),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              if (leadingIcon != null) ...[
                Icon(
                  leadingIcon,
                  size: AppDimensions.iconLG,
                  color: leadingIconColor ?? colorScheme.primary,
                ),
                const SizedBox(width: AppDimensions.paddingSM),
              ],
              Text(
                title,
                style: AppTextStyles.titleLarge.copyWith(
                  fontWeight: FontWeight.w800,
                ),
              ),
            ],
          ),
          if (actionLabel != null)
            GestureDetector(
              onTap: onAction,
              child: Text(
                actionLabel!,
                style: AppTextStyles.labelLarge.copyWith(
                  color: colorScheme.primary,
                ),
              ),
            ),
        ],
      ),
    );
  }
}
