import 'package:flutter/material.dart';

class GridBackgroundPainter extends CustomPainter {
  const GridBackgroundPainter(this.colorScheme);
  final ColorScheme colorScheme;

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = colorScheme.outline.withValues(alpha: 0.04)
      ..strokeWidth = 1.0;

    const divisions = 16;
    final cellWidth = size.width / divisions;
    final cellHeight = size.height / divisions;

    for (int i = 0; i <= divisions; i++) {
      final x = i * cellWidth;
      canvas.drawLine(Offset(x, 0), Offset(x, size.height), paint);
    }
    for (int i = 0; i <= divisions; i++) {
      final y = i * cellHeight;
      canvas.drawLine(Offset(0, y), Offset(size.width, y), paint);
    }

    final centerPaint = Paint()
      ..color = colorScheme.primary.withValues(alpha: 0.1)
      ..strokeWidth = 1.5;
    canvas.drawLine(
      Offset(size.width / 2, 0),
      Offset(size.width / 2, size.height),
      centerPaint,
    );
    canvas.drawLine(
      Offset(0, size.height / 2),
      Offset(size.width, size.height / 2),
      centerPaint,
    );
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
