import 'package:flutter/material.dart';
import '../../../../core/core.dart';

class NativeCircuitWidget extends StatefulWidget {
  const NativeCircuitWidget({
    super.key,
    required this.config,
    required this.parameters,
  });

  final Map<String, dynamic> config;
  final Map<String, double> parameters;

  @override
  State<NativeCircuitWidget> createState() => _NativeCircuitWidgetState();
}

class _NativeCircuitWidgetState extends State<NativeCircuitWidget>
    with SingleTickerProviderStateMixin {
  late final AnimationController _animationController;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    )..repeat();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    // Retrieve parameters: Voltage (V_s / V) and Resistance (R)
    final double v = widget.parameters['V_s'] ?? widget.parameters['V'] ?? 12.0;
    final double r = widget.parameters['R'] ?? 6.0;

    // Calculate Current I = V / R
    final double i = r > 0 ? v / r : 0.0;

    // Dynamic animation rate (current flow speed)
    // Speed increases as current increases. If current is 0, freeze it.
    if (i > 0) {
      final targetDurationMs = (2000 / (i + 0.1)).clamp(200.0, 3000.0).toInt();
      _animationController.duration = Duration(milliseconds: targetDurationMs);
      if (!_animationController.isAnimating) {
        _animationController.repeat();
      }
    } else {
      _animationController.stop();
    }

    return Stack(
      children: [
        // Circuit Diagram Canvas
        Positioned.fill(
          child: AnimatedBuilder(
            animation: _animationController,
            builder: (context, child) {
              return CustomPaint(
                painter: _CircuitPainter(
                  v: v,
                  r: r,
                  i: i,
                  animationValue: _animationController.value,
                  colorScheme: colorScheme,
                ),
              );
            },
          ),
        ),

        // Readout panel in center
        Center(
          child: Container(
            padding: const EdgeInsets.symmetric(
              horizontal: AppDimensions.paddingMD,
              vertical: AppDimensions.paddingSM,
            ),
            decoration: BoxDecoration(
              color: Colors.black.withValues(alpha: 0.7),
              borderRadius: BorderRadius.circular(AppDimensions.radiusMD),
              border: Border.all(
                color: colorScheme.primary.withValues(alpha: 0.3),
              ),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  'OHM\'S LAW CALCULATOR',
                  style: TextStyle(
                    color: colorScheme.primary,
                    fontSize: 8,
                    fontWeight: FontWeight.bold,
                    letterSpacing: 1.2,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  'I = ${i.toStringAsFixed(2)} A',
                  style: AppTextStyles.titleMedium.copyWith(
                    color: Colors.greenAccent,
                    fontWeight: FontWeight.bold,
                    fontFamily: 'monospace',
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  'Power P = ${(v * i).toStringAsFixed(1)} W',
                  style: TextStyle(
                    color: colorScheme.onSurfaceVariant,
                    fontSize: 10,
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}

class _CircuitPainter extends CustomPainter {
  _CircuitPainter({
    required this.v,
    required this.r,
    required this.i,
    required this.animationValue,
    required this.colorScheme,
  });

  final double v;
  final double r;
  final double i;
  final double animationValue;
  final ColorScheme colorScheme;

  @override
  void paint(Canvas canvas, Size size) {
    const double marginX = 60.0;
    const double marginY = 50.0;

    // Define circuit path rectangle coordinates
    const left = marginX;
    final right = size.width - marginX;
    const top = marginY;
    final bottom = size.height - marginY;
    final width = right - left;
    final height = bottom - top;

    final wirePaint = Paint()
      ..color = colorScheme.outline.withValues(alpha: 0.3)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 3.0;

    // 1. Draw loop path wire sections (except where components are placed)
    // We will place Battery on Left segment (bottom-to-top flow)
    // Resistor on Top segment (left-to-right flow)
    
    // Draw wire segments
    // Top segment (left to resistor, resistor to right)
    const resWidth = 60.0;
    final topMidX = left + width / 2;
    canvas.drawLine(const Offset(left, top), Offset(topMidX - resWidth / 2, top), wirePaint);
    canvas.drawLine(Offset(topMidX + resWidth / 2, top), Offset(right, top), wirePaint);

    // Right segment (completely wire)
    canvas.drawLine(Offset(right, top), Offset(right, bottom), wirePaint);

    // Bottom segment (completely wire)
    canvas.drawLine(Offset(right, bottom), Offset(left, bottom), wirePaint);

    // Left segment (bottom to battery, battery to top)
    const batHeight = 40.0;
    final leftMidY = top + height / 2;
    canvas.drawLine(Offset(left, bottom), Offset(left, leftMidY + batHeight / 2), wirePaint);
    canvas.drawLine(Offset(left, leftMidY - batHeight / 2), const Offset(left, top), wirePaint);

    // 2. Draw Battery component (Left mid)
    _drawBattery(canvas, Offset(left, leftMidY), batHeight);

    // 3. Draw Resistor component (Top mid)
    _drawResistor(canvas, Offset(topMidX, top), resWidth);

    // 4. Draw Electron dots moving in circuit (clockwise flow)
    _drawCurrentFlow(canvas, left, right, top, bottom, animationValue);
  }

  void _drawBattery(Canvas canvas, Offset center, double height) {
    final compPaint = Paint()
      ..color = colorScheme.primary
      ..style = PaintingStyle.stroke
      ..strokeWidth = 3.0;

    const double barSpacing = 8.0;

    // Draw positive terminal (longer, thin line at top)
    canvas.drawLine(
      Offset(center.dx - 15, center.dy - barSpacing / 2),
      Offset(center.dx + 15, center.dy - barSpacing / 2),
      compPaint,
    );
    // Draw negative terminal (shorter, thick line at bottom)
    final thickPaint = Paint()
      ..color = colorScheme.primary
      ..style = PaintingStyle.stroke
      ..strokeWidth = 6.0;
    canvas.drawLine(
      Offset(center.dx - 8, center.dy + barSpacing / 2),
      Offset(center.dx + 8, center.dy + barSpacing / 2),
      thickPaint,
    );

    // Text labels (+ and -)
    final textPainter = TextPainter(textDirection: TextDirection.ltr);
    textPainter.text = TextSpan(
      text: '+',
      style: TextStyle(color: colorScheme.primary, fontSize: 14, fontWeight: FontWeight.bold),
    );
    textPainter.layout();
    textPainter.paint(canvas, Offset(center.dx - 30, center.dy - 18));

    textPainter.text = TextSpan(
      text: '${v.toStringAsFixed(1)} V',
      style: TextStyle(color: colorScheme.onSurfaceVariant, fontSize: 10),
    );
    textPainter.layout();
    textPainter.paint(canvas, Offset(center.dx - 45, center.dy - 5));
  }

  void _drawResistor(Canvas canvas, Offset center, double width) {
    final compPaint = Paint()
      ..color = Colors.orangeAccent
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2.5;

    // Draw zigzag
    final path = Path();
    final double step = width / 6;
    const double amplitude = 12.0;

    path.moveTo(center.dx - width / 2, center.dy);
    path.lineTo(center.dx - width / 2 + step / 2, center.dy + amplitude);
    path.lineTo(center.dx - width / 2 + step * 1.5, center.dy - amplitude);
    path.lineTo(center.dx - width / 2 + step * 2.5, center.dy + amplitude);
    path.lineTo(center.dx - width / 2 + step * 3.5, center.dy - amplitude);
    path.lineTo(center.dx - width / 2 + step * 4.5, center.dy + amplitude);
    path.lineTo(center.dx - width / 2 + step * 5.5, center.dy - amplitude);
    path.lineTo(center.dx + width / 2, center.dy);

    canvas.drawPath(path, compPaint);

    // Label
    final textPainter = TextPainter(textDirection: TextDirection.ltr);
    textPainter.text = TextSpan(
      text: '${r.toStringAsFixed(1)} Ω',
      style: TextStyle(color: colorScheme.onSurfaceVariant, fontSize: 10),
    );
    textPainter.layout();
    textPainter.paint(canvas, Offset(center.dx - textPainter.width / 2, center.dy - 28));
  }

  void _drawCurrentFlow(
    Canvas canvas,
    double left,
    double right,
    double top,
    double bottom,
    double progress,
  ) {
    final double width = right - left;
    final double height = bottom - top;
    final double perimeter = 2 * (width + height);

    // Flow directions: Clockwise
    // Top: left to right (from x=left to x=right)
    // Right: top to bottom (from y=top to y=bottom)
    // Bottom: right to left (from x=right to x=left)
    // Left: bottom to top (from y=bottom to y=top)

    final electronPaint = Paint()
      ..color = Colors.yellowAccent
      ..style = PaintingStyle.fill;

    final glowPaint = Paint()
      ..color = Colors.yellowAccent.withValues(alpha: 0.3)
      ..style = PaintingStyle.fill;

    // Number of charges to animate in the loop
    const dotCount = 12;
    for (int k = 0; k < dotCount; k++) {
      // Offset each electron charge along the perimeter loop
      final double fraction = (progress + k / dotCount) % 1.0;
      final double distance = fraction * perimeter;

      Offset pos;
      if (distance < width) {
        // Top edge: moving right
        pos = Offset(left + distance, top);
      } else if (distance < width + height) {
        // Right edge: moving down
        pos = Offset(right, top + (distance - width));
      } else if (distance < 2 * width + height) {
        // Bottom edge: moving left
        pos = Offset(right - (distance - (width + height)), bottom);
      } else {
        // Left edge: moving up
        pos = Offset(left, bottom - (distance - (2 * width + height)));
      }

      // Draw charge with glowing outer shell
      canvas.drawCircle(pos, 6.0, glowPaint);
      canvas.drawCircle(pos, 3.0, electronPaint);
    }
  }

  @override
  bool shouldRepaint(covariant _CircuitPainter oldDelegate) {
    return oldDelegate.animationValue != animationValue ||
        oldDelegate.v != v ||
        oldDelegate.r != r;
  }
}
