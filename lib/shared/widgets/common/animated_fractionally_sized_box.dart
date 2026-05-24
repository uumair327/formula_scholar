import 'package:flutter/material.dart';

class AppAnimatedFractionallySizedBox extends ImplicitlyAnimatedWidget {
  const AppAnimatedFractionallySizedBox({
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
  AnimatedWidgetBaseState<AppAnimatedFractionallySizedBox> createState() =>
      _AppAnimatedFractionallySizedBoxState();
}

class _AppAnimatedFractionallySizedBoxState
    extends AnimatedWidgetBaseState<AppAnimatedFractionallySizedBox> {
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
