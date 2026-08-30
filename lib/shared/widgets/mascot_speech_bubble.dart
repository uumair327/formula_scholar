import 'package:flutter/material.dart';

import '../../core/core.dart';

/// A speech bubble shown above or below the mascot.
///
/// Displays a contextual message with a small triangular pointer.
/// Adapts to theme colors automatically.
class MascotSpeechBubble extends StatelessWidget {
  const MascotSpeechBubble({
    super.key,
    required this.message,
    this.pointDirection = AxisDirection.down,
  });

  /// The text content of the speech bubble.
  final String message;

  /// Direction the pointer points (toward the mascot).
  final AxisDirection pointDirection;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        if (pointDirection == AxisDirection.up)
          _buildPointer(colorScheme, isUp: true),
        Container(
          padding: const EdgeInsets.symmetric(
            horizontal: AppDimensions.paddingLG,
            vertical: AppDimensions.paddingSM,
          ),
          decoration: BoxDecoration(
            color: colorScheme.surfaceContainer,
            borderRadius: BorderRadius.circular(AppDimensions.radiusLG),
            border: Border.all(
              color: colorScheme.outlineVariant.withValues(alpha: 0.3),
            ),
            boxShadow: [AppShadows.soft],
          ),
          child: Text(
            message,
            style: AppTextStyles.labelLarge.copyWith(
              color: colorScheme.onSurface,
              fontWeight: FontWeight.w600,
            ),
            textAlign: TextAlign.center,
          ),
        ),
        if (pointDirection == AxisDirection.down)
          _buildPointer(colorScheme, isUp: false),
      ],
    );
  }

  Widget _buildPointer(ColorScheme colorScheme, {required bool isUp}) {
    return CustomPaint(
      size: const Size(16, 8),
      painter: _BubblePointerPainter(
        color: colorScheme.surfaceContainer,
        isUp: isUp,
      ),
    );
  }
}

class _BubblePointerPainter extends CustomPainter {
  _BubblePointerPainter({required this.color, required this.isUp});

  final Color color;
  final bool isUp;

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..style = PaintingStyle.fill;

    final path = Path();
    if (isUp) {
      path.moveTo(0, size.height);
      path.lineTo(size.width / 2, 0);
      path.lineTo(size.width, size.height);
    } else {
      path.moveTo(0, 0);
      path.lineTo(size.width / 2, size.height);
      path.lineTo(size.width, 0);
    }
    path.close();
    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant _BubblePointerPainter oldDelegate) =>
      oldDelegate.color != color || oldDelegate.isUp != isUp;
}
