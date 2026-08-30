import 'package:flutter/material.dart';

import '../../core/core.dart';
import 'mascot_painter.dart';

/// Reusable Sigma mascot widget with breathing animation.
///
/// Renders the owl-scientist character via [MascotPainter] at
/// the given [size]. The mascot adapts to theme brightness and
/// primary color automatically.
///
/// Usage:
/// ```dart
/// AppMascot(mood: MascotMood.happy, size: AppDimensions.mascotMD)
/// ```
class AppMascot extends StatefulWidget {
  const AppMascot({
    super.key,
    this.mood = MascotMood.happy,
    this.size = AppDimensions.mascotMD,
    this.animate = true,
  });

  /// The mood/expression of the mascot.
  final MascotMood mood;

  /// The width and height of the mascot canvas.
  final double size;

  /// Whether the mascot has a subtle breathing animation.
  final bool animate;

  @override
  State<AppMascot> createState() => _AppMascotState();
}

class _AppMascotState extends State<AppMascot>
    with SingleTickerProviderStateMixin {
  late final AnimationController _breathController;
  late final Animation<double> _breathAnimation;

  @override
  void initState() {
    super.initState();
    _breathController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 2500),
    );
    _breathAnimation = Tween<double>(begin: 0.97, end: 1.03).animate(
      CurvedAnimation(parent: _breathController, curve: Curves.easeInOut),
    );

    if (widget.animate) {
      _breathController.repeat(reverse: true);
    }
  }

  @override
  void didUpdateWidget(covariant AppMascot oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.animate && !_breathController.isAnimating) {
      _breathController.repeat(reverse: true);
    } else if (!widget.animate && _breathController.isAnimating) {
      _breathController.stop();
      _breathController.value = 0.5; // rest at 1.0 scale
    }
  }

  @override
  void dispose() {
    _breathController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return AnimatedBuilder(
      animation: _breathAnimation,
      builder: (context, child) {
        return SizedBox(
          width: widget.size,
          height: widget.size,
          child: CustomPaint(
            painter: MascotPainter(
              mood: widget.mood,
              primaryColor: colorScheme.primary,
              onPrimaryColor: colorScheme.onPrimary,
              surfaceColor: colorScheme.surface,
              isDark: isDark,
              breathScale: widget.animate ? _breathAnimation.value : 1.0,
            ),
          ),
        );
      },
    );
  }
}
