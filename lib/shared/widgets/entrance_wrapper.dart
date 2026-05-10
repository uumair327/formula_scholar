import 'package:flutter/material.dart';

import '../../core/core.dart';

class EntranceWrapper extends StatefulWidget {
  const EntranceWrapper({
    super.key,
    required this.child,
    this.delay = Duration.zero,
    this.offset = const Offset(0, 20),
  });

  final Widget child;
  final Duration delay;
  final Offset offset;

  @override
  State<EntranceWrapper> createState() => _EntranceWrapperState();
}

class _EntranceWrapperState extends State<EntranceWrapper> {
  bool _visible = false;

  @override
  void initState() {
    super.initState();
    Future.delayed(widget.delay, () {
      if (mounted) setState(() => _visible = true);
    });
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedSlide(
      offset: _visible ? Offset.zero : widget.offset,
      duration: AppDurations.animationDefault,
      curve: AppDurations.curveDecelerate,
      child: AnimatedOpacity(
        opacity: _visible ? 1.0 : 0.0,
        duration: AppDurations.animationDefault,
        curve: AppDurations.curveDecelerate,
        child: widget.child,
      ),
    );
  }
}
