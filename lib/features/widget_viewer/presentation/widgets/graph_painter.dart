import 'dart:math' as math;
import 'package:flutter/material.dart';
import '../../../../core/core.dart';
import 'graph_expression_evaluator.dart';

class GraphPainter extends CustomPainter {
  GraphPainter({
    required this.expressions,
    required this.parameters,
    required this.xMinDefault,
    required this.xMaxDefault,
    required this.yMinDefault,
    required this.yMaxDefault,
    required this.panX,
    required this.panY,
    required this.colorScheme,
    required this.textDirection,
  });

  final List<dynamic> expressions;
  final Map<String, double> parameters;
  final double xMinDefault;
  final double xMaxDefault;
  final double yMinDefault;
  final double yMaxDefault;
  final double panX;
  final double panY;
  final ColorScheme colorScheme;
  final TextDirection textDirection;

  @override
  void paint(Canvas canvas, Size size) {
    // Current coordinate limits including pan
    final widthVal = xMaxDefault - xMinDefault;
    final heightVal = yMaxDefault - yMinDefault;

    final double scaleX = size.width / widthVal;
    final double scaleY = size.height / heightVal;

    final double shiftX = panX / scaleX;
    final double shiftY = panY / scaleY;

    final xMin = xMinDefault - shiftX;
    final xMax = xMaxDefault - shiftX;
    final yMin = yMinDefault + shiftY;
    final yMax = yMaxDefault + shiftY;

    // Projection helpers
    Offset toScreen(double x, double y) {
      final sx = ((x - xMin) / (xMax - xMin)) * size.width;
      final sy = size.height - (((y - yMin) / (yMax - yMin)) * size.height);
      return Offset(sx, sy);
    }

    // Grid Painter
    final gridPaint = Paint()
      ..color = colorScheme.outline.withValues(alpha: 0.1)
      ..strokeWidth = 1.0;

    final axisPaint = Paint()
      ..color = colorScheme.onSurface.withValues(alpha: 0.4)
      ..strokeWidth = 2.0;

    final textPainter = TextPainter(textDirection: textDirection);

    // Draw vertical grid lines
    final stepX = _calculateStep(xMax - xMin);
    final double startX = (xMin / stepX).floor() * stepX;
    for (double x = startX; x <= xMax; x += stepX) {
      final p1 = toScreen(x, yMin);
      final p2 = toScreen(x, yMax);
      canvas.drawLine(p1, p2, gridPaint);

      // Label
      if (x != 0 && p1.dx > 10 && p1.dx < size.width - 10) {
        final origin = toScreen(x, 0);
        final labelY = origin.dy.clamp(10.0, size.height - 20.0);
        textPainter.text = TextSpan(
          text: x.toStringAsFixed(x.abs() < 1 ? 1 : 0),
          style: TextStyle(color: colorScheme.outline, fontSize: 10),
        );
        textPainter.layout();
        textPainter.paint(
          canvas,
          Offset(p1.dx - textPainter.width / 2, labelY + 2),
        );
      }
    }

    // Draw horizontal grid lines
    final stepY = _calculateStep(yMax - yMin);
    final double startY = (yMin / stepY).floor() * stepY;
    for (double y = startY; y <= yMax; y += stepY) {
      final p1 = toScreen(xMin, y);
      final p2 = toScreen(xMax, y);
      canvas.drawLine(p1, p2, gridPaint);

      // Label
      if (y != 0 && p1.dy > 10 && p1.dy < size.height - 20) {
        final origin = toScreen(0, y);
        final labelX = origin.dx.clamp(5.0, size.width - 25.0);
        textPainter.text = TextSpan(
          text: y.toStringAsFixed(y.abs() < 1 ? 1 : 0),
          style: TextStyle(color: colorScheme.outline, fontSize: 10),
        );
        textPainter.layout();
        textPainter.paint(
          canvas,
          Offset(labelX + 4, p1.dy - textPainter.height / 2),
        );
      }
    }

    // Draw axes
    final origin = toScreen(0, 0);
    // Y-Axis
    if (origin.dx >= 0 && origin.dx <= size.width) {
      canvas.drawLine(
        Offset(origin.dx, 0),
        Offset(origin.dx, size.height),
        axisPaint,
      );
    }
    // X-Axis
    if (origin.dy >= 0 && origin.dy <= size.height) {
      canvas.drawLine(
        Offset(0, origin.dy),
        Offset(size.width, origin.dy),
        axisPaint,
      );
    }

    // Plot Expressions
    for (final expr in expressions) {
      if (expr is! Map<String, dynamic>) continue;
      final colorHex = expr['color'] as String? ?? '#3B82F6';
      final latex = expr['latex'] as String? ?? '';

      final graphPaint = Paint()
        ..color = _parseColor(colorHex)
        ..style = PaintingStyle.stroke
        ..strokeWidth = 2.5
        ..strokeCap = StrokeCap.round;

      final path = Path();
      bool first = true;
      const pointCount = 200;

      for (int i = 0; i <= pointCount; i++) {
        final double t = i / pointCount;
        final double x = xMin + t * (xMax - xMin);
        final double? y = _evaluate(latex, x, parameters);

        if (y != null && !y.isNaN && !y.isInfinite) {
          final pt = toScreen(x, y);
          if (pt.dy >= -100 && pt.dy <= size.height + 100) {
            if (first) {
              path.moveTo(pt.dx, pt.dy);
              first = false;
            } else {
              path.lineTo(pt.dx, pt.dy);
            }
          } else {
            first = true; // Break continuity
          }
        } else {
          first = true;
        }
      }
      canvas.drawPath(path, graphPaint);

      // Draw Roots / Special Features (if highlighted)
      _drawRoots(canvas, latex, parameters, toScreen, colorScheme);
    }
  }

  double _calculateStep(double range) {
    if (range < 5) return 0.5;
    if (range < 25) return 2.0;
    if (range < 100) return 10.0;
    return 50.0;
  }

  Color _parseColor(String hex) {
    try {
      final clean = hex.replaceAll('#', '');
      return Color(int.parse('FF$clean', radix: 16));
    } catch (_) {
      return AppColors.primary;
    }
  }

  double? _evaluate(String latex, double x, Map<String, double> params) {
    return GraphExpressionEvaluator.evaluate(latex, x, params);
  }

  void _drawRoots(
    Canvas canvas,
    String latex,
    Map<String, double> params,
    Offset Function(double, double) toScreen,
    ColorScheme colorScheme,
  ) {
    final lower = latex.toLowerCase().replaceAll(' ', '');
    if (lower.contains('x^2') &&
        !lower.contains('sin') &&
        !lower.contains('cos')) {
      // Draw roots for quadratic y = ax^2 + bx + c
      final double a = params['a'] ?? 1.0;
      final double b = params['b'] ?? 0.0;
      final double c = params['c'] ?? 0.0;

      final discriminant = b * b - 4 * a * c;
      if (discriminant >= 0) {
        final r1 = (-b + math.sqrt(discriminant)) / (2 * a);
        final r2 = (-b - math.sqrt(discriminant)) / (2 * a);

        final rootPaint = Paint()
          ..color = AppColors.secondary
          ..style = PaintingStyle.fill;

        final glowPaint = Paint()
          ..color = AppColors.secondary.withValues(alpha: 0.3)
          ..style = PaintingStyle.fill;

        void drawRootPoint(double rx) {
          final pt = toScreen(rx, 0);
          canvas.drawCircle(pt, 8.0, glowPaint);
          canvas.drawCircle(pt, 4.0, rootPaint);
        }

        drawRootPoint(r1);
        if (r1 != r2) {
          drawRootPoint(r2);
        }
      }
    }
  }

  @override
  bool shouldRepaint(covariant GraphPainter oldDelegate) {
    return oldDelegate.panX != panX ||
        oldDelegate.panY != panY ||
        oldDelegate.parameters != parameters ||
        oldDelegate.expressions != expressions;
  }
}

