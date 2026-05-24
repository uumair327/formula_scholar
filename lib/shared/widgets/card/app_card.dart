import 'package:flutter/material.dart';

import '../../../core/core.dart';

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

  final Widget child;
  final Color? color;
  final double borderRadius;
  final EdgeInsetsGeometry padding;
  final List<BoxShadow> boxShadow;
  final BoxBorder? border;
  final Clip clipBehavior;
  final VoidCallback? onTap;
  final VoidCallback? onLongPress;
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
    if (_interactive) {
      HapticsHelper.selectionClick();
      _controller.forward();
    }
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
