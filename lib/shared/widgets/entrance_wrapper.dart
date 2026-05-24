import 'package:flutter/material.dart';

import '../../core/core.dart';

/// Slide direction for entrance animations.
enum EntranceDirection { up, down, left, right }

/// Animated entrance wrapper with fade + slide/scale effects.
///
/// Wraps a child widget and applies a staggered entrance animation
/// when the widget is first built. Supports:
/// - Configurable slide direction
/// - Stagger delay (for list items)
/// - Scale entrance variant
class EntranceWrapper extends StatefulWidget {
  const EntranceWrapper({
    super.key,
    required this.child,
    this.delay = Duration.zero,
    this.offset = const Offset(0, 20),
    this.direction,
    this.useScale = false,
    this.scaleBegin = 0.95,
  });

  /// Creates an entrance wrapper with stagger delay based on [index].
  factory EntranceWrapper.stagger({
    Key? key,
    required Widget child,
    required int index,
    EntranceDirection direction = EntranceDirection.up,
    bool useScale = false,
  }) {
    return EntranceWrapper(
      key: key,
      delay: AppDurations.staggerDelay(index),
      direction: direction,
      useScale: useScale,
      child: child,
    );
  }

  final Widget child;
  final Duration delay;

  /// Manual offset (used when [direction] is null).
  final Offset offset;

  /// Slide direction (overrides [offset]).
  final EntranceDirection? direction;

  /// Whether to add a scale animation.
  final bool useScale;

  /// Starting scale when [useScale] is true.
  final double scaleBegin;

  @override
  State<EntranceWrapper> createState() => _EntranceWrapperState();
}

class _EntranceWrapperState extends State<EntranceWrapper>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  late final Animation<double> _fadeAnimation;
  late final Animation<double> _scaleAnimation;
  late final Offset _rawSlideOffset;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: AppDurations.animationSlow,
    );

    _rawSlideOffset = _resolveRawOffset();
    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _controller, curve: AppDurations.curvePremium),
    );
    _scaleAnimation = Tween<double>(
      begin: widget.useScale ? widget.scaleBegin : 1.0,
      end: 1.0,
    ).animate(CurvedAnimation(parent: _controller, curve: AppDurations.curvePremium));

    if (widget.delay == Duration.zero) {
      _controller.forward();
    } else {
      Future.delayed(widget.delay, () {
        if (mounted) _controller.forward();
      });
    }
  }

  Offset _resolveRawOffset() {
    if (widget.direction == null) return widget.offset;
    switch (widget.direction!) {
      case EntranceDirection.up:
        return const Offset(0, 24);
      case EntranceDirection.down:
        return const Offset(0, -24);
      case EntranceDirection.left:
        return const Offset(24, 0);
      case EntranceDirection.right:
        return const Offset(-24, 0);
    }
  }

  /// Resolves the slide offset, flipping horizontally in RTL context.
  Offset _effectiveSlideOffset(BuildContext context) {
    final isRtl = Directionality.of(context) == TextDirection.rtl;
    if (!isRtl || _rawSlideOffset.dx == 0) return _rawSlideOffset;
    return Offset(-_rawSlideOffset.dx, _rawSlideOffset.dy);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final slideOffset = _effectiveSlideOffset(context);
    final slideTween = Tween<Offset>(begin: slideOffset, end: Offset.zero).animate(
      CurvedAnimation(parent: _controller, curve: AppDurations.curvePremium),
    );

    return AnimatedBuilder(
      animation: _controller,
      builder: (context, child) {
        return Opacity(
          opacity: _fadeAnimation.value,
          child: Transform.translate(
            offset: slideTween.value,
            child: Transform.scale(
              scale: _scaleAnimation.value,
              child: child,
            ),
          ),
        );
      },
      child: widget.child,
    );
  }
}
