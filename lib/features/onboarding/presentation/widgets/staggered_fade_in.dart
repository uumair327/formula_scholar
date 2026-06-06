import 'package:flutter/material.dart';

class StaggeredFadeIn extends StatelessWidget {
  const StaggeredFadeIn({
    super.key,
    required this.child,
    required this.index,
    this.delay = const Duration(milliseconds: 50),
    this.duration = const Duration(milliseconds: 400),
    this.offset = const Offset(0, 20),
  });

  final Widget child;
  final int index;
  final Duration delay;
  final Duration duration;
  final Offset offset;

  @override
  Widget build(BuildContext context) {
    final beginDelay = delay * index;
    final totalDuration = beginDelay + duration;

    return TweenAnimationBuilder<double>(
      tween: Tween<double>(begin: 0.0, end: 1.0),
      duration: totalDuration,
      curve: Curves.easeOutCubic,
      builder: (context, value, child) {
        // Calculate the relative progress based on delay
        final double delayFraction =
            beginDelay.inMilliseconds / totalDuration.inMilliseconds;

        double progress = 0.0;
        if (value > delayFraction) {
          progress = (value - delayFraction) / (1.0 - delayFraction);
        }

        return Opacity(
          opacity: progress,
          child: Transform.translate(
            offset: offset * (1 - progress),
            child: child,
          ),
        );
      },
      child: child,
    );
  }
}
