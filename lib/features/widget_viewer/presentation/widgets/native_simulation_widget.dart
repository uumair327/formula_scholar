import 'dart:math' as math;
import 'package:flutter/material.dart';
import '../../../../core/core.dart';

class NativeSimulationWidget extends StatefulWidget {
  const NativeSimulationWidget({
    super.key,
    required this.config,
    required this.parameters,
  });

  final Map<String, dynamic> config;
  final Map<String, double> parameters;

  @override
  State<NativeSimulationWidget> createState() => _NativeSimulationWidgetState();
}

class _NativeSimulationWidgetState extends State<NativeSimulationWidget>
    with SingleTickerProviderStateMixin {
  late final AnimationController _tickerController;
  bool _isPlaying = true;
  double _elapsedSeconds = 0.0;
  DateTime? _lastTick;

  @override
  void initState() {
    super.initState();
    _tickerController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 1),
    )..addListener(_onTick);
    _tickerController.repeat();
    _lastTick = DateTime.now();
  }

  void _onTick() {
    final now = DateTime.now();
    if (_lastTick != null && _isPlaying) {
      final double dt = now.difference(_lastTick!).inMilliseconds / 1000.0;
      setState(() {
        _elapsedSeconds += dt;
      });
    }
    _lastTick = now;
  }

  @override
  void dispose() {
    _tickerController.dispose();
    super.dispose();
  }

  void _togglePlay() {
    setState(() {
      _isPlaying = !_isPlaying;
      if (_isPlaying) {
        _lastTick = DateTime.now();
      }
    });
  }

  void _reset() {
    setState(() {
      _elapsedSeconds = 0.0;
      _lastTick = DateTime.now();
    });
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final textDirection = Directionality.of(context);
    final simulationId =
        widget.config['simulationId'] as String? ?? 'projectile';

    return Stack(
      children: [
        // Simulation painting Canvas
        Positioned.fill(
          child: RepaintBoundary(
            child: CustomPaint(
              painter: _SimulationPainter(
                simulationId: simulationId,
                time: _elapsedSeconds,
                parameters: widget.parameters,
                colorScheme: colorScheme,
                textDirection: textDirection,
              ),
            ),
          ),
        ),

        // Controls bar: Play/Pause and Reset
        Positioned(
          top: AppDimensions.paddingMD,
          right: textDirection == TextDirection.ltr
              ? AppDimensions.paddingMD
              : null,
          left: textDirection == TextDirection.rtl
              ? AppDimensions.paddingMD
              : null,
          child: Row(
            children: [
              IconButton(
                icon: Icon(
                  _isPlaying ? Icons.pause : Icons.play_arrow,
                  color: colorScheme.primary,
                ),
                onPressed: _togglePlay,
                tooltip: _isPlaying ? context.l10n.pause : context.l10n.play,
              ),
              IconButton(
                icon: Icon(Icons.refresh, color: colorScheme.outline),
                onPressed: _reset,
                tooltip: context.l10n.reset,
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class _SimulationPainter extends CustomPainter {
  _SimulationPainter({
    required this.simulationId,
    required this.time,
    required this.parameters,
    required this.colorScheme,
    required this.textDirection,
  });

  final String simulationId;
  final double time;
  final Map<String, double> parameters;
  final ColorScheme colorScheme;
  final TextDirection textDirection;

  @override
  void paint(Canvas canvas, Size size) {
    switch (simulationId) {
      case 'pendulum':
        _paintPendulum(canvas, size);
      case 'wave':
        _paintWave(canvas, size);
      case 'projectile':
      default:
        _paintProjectile(canvas, size);
    }
  }

  // 1. PROJECTILE MOTION SIMULATION
  void _paintProjectile(Canvas canvas, Size size) {
    final double v0 =
        parameters['v0'] ?? parameters['v'] ?? 35.0; // Initial velocity
    final double degrees =
        parameters['theta'] ?? parameters['angle'] ?? 45.0; // Angle
    const double g = 9.8; // Gravity acceleration

    final double theta = degrees * math.pi / 180.0;

    // Kinematics calculations
    final double vx0 = v0 * math.cos(theta);
    final double vy0 = v0 * math.sin(theta);

    // Total flight time
    final double flightTime = (2 * vy0) / g;

    // Position solver at current time (clamped to flightTime)
    final double t = time.clamp(0.0, flightTime);
    final double x = vx0 * t;
    final double y = vy0 * t - 0.5 * g * t * t;

    // Drawing metrics scaling
    // Fit coordinates to canvas: x goes 0 to 150, y goes 0 to 80
    const double originX = 40.0;
    final double originY = size.height - 40.0;
    final double scaleX = (size.width - 80.0) / 150.0;
    final double scaleY = (size.height - 80.0) / 75.0;

    Offset toScreen(double rx, double ry) {
      return Offset(originX + rx * scaleX, originY - ry * scaleY);
    }

    final gridPaint = Paint()
      ..color = colorScheme.outline.withValues(alpha: 0.1)
      ..strokeWidth = 1.0;

    // Draw coordinate ground & vertical grids
    canvas.drawLine(
      Offset(originX, originY),
      Offset(size.width - 20, originY),
      gridPaint,
    );
    for (double gx = 0; gx <= 150; gx += 30) {
      final p = toScreen(gx, 0);
      canvas.drawLine(Offset(p.dx, originY), Offset(p.dx, 20), gridPaint);
    }

    // Paint trajectory curve
    final pathPaint = Paint()
      ..color = colorScheme.primary.withValues(alpha: 0.3)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2.0;

    final path = Path();
    bool first = true;
    for (double stepT = 0.0; stepT <= flightTime; stepT += flightTime / 40) {
      final double tx = vx0 * stepT;
      final double ty = vy0 * stepT - 0.5 * g * stepT * stepT;
      final pt = toScreen(tx, ty);
      if (first) {
        path.moveTo(pt.dx, pt.dy);
        first = false;
      } else {
        path.lineTo(pt.dx, pt.dy);
      }
    }
    canvas.drawPath(path, pathPaint);

    // Paint projectile bob
    final currentPos = toScreen(x, y);
    final ballPaint = Paint()
      ..color = AppColors.error
      ..style = PaintingStyle.fill;
    final glowPaint = Paint()
      ..color = AppColors.error.withValues(alpha: 0.3)
      ..style = PaintingStyle.fill;

    canvas.drawCircle(currentPos, 10.0, glowPaint);
    canvas.drawCircle(currentPos, 5.0, ballPaint);

    // Paint velocity vectors (Vx and Vy) at current position
    final double currentVy = vy0 - g * t;
    final vecPaint = Paint()
      ..color = AppColors.successGreen
      ..strokeWidth = 2.0;

    // Draw Vx vector
    canvas.drawLine(currentPos, currentPos + Offset(vx0 * 0.8, 0), vecPaint);
    // Draw Vy vector
    canvas.drawLine(
      currentPos,
      currentPos + Offset(0, -currentVy * 0.8),
      vecPaint,
    );

    // Draw readout text values
    final textPainter = TextPainter(textDirection: textDirection);
    textPainter.text = TextSpan(
      text:
          'Range = ${(vx0 * flightTime).toStringAsFixed(1)} m\n'
          'Height = ${y.toStringAsFixed(1)} m\n'
          'Time = ${t.toStringAsFixed(2)} s',
      style: TextStyle(
        color: colorScheme.onSurfaceVariant,
        fontSize: 10,
        fontFamily: 'monospace',
      ),
    );
    textPainter.layout();
    textPainter.paint(canvas, const Offset(originX, 20));
  }

  // 2. SIMPLE PENDULUM SIMULATION
  void _paintPendulum(Canvas canvas, Size size) {
    final double L = parameters['L'] ?? 1.5; // string length
    final double g = parameters['g'] ?? 9.8; // gravity
    const double thetaMax = 35.0 * math.pi / 180.0; // max angle (35 degrees)

    final double omega = math.sqrt(g / L);
    final double theta = thetaMax * math.cos(omega * time);

    final double centerX = size.width / 2;
    const double centerY = 40.0;
    final double pixelLength =
        (size.height - 100.0) * (L / 2.0).clamp(0.5, 1.2);

    final Offset pivot = Offset(centerX, centerY);
    final Offset bobPos = Offset(
      centerX + pixelLength * math.sin(theta),
      centerY + pixelLength * math.cos(theta),
    );

    // Paint pivot plate
    final pivotPaint = Paint()
      ..color = colorScheme.outline
      ..style = PaintingStyle.fill;
    canvas.drawRect(
      Rect.fromCenter(center: pivot, width: 30, height: 6),
      pivotPaint,
    );

    // Paint string wire
    final wirePaint = Paint()
      ..color = colorScheme.onSurfaceVariant.withValues(alpha: 0.6)
      ..strokeWidth = 2.0;
    canvas.drawLine(pivot, bobPos, wirePaint);

    // Paint force vectors (Tension and Gravity)
    // Gravity vector (downwards)
    final vectorPaint = Paint()
      ..strokeWidth = 2.0
      ..style = PaintingStyle.stroke;

    // Draw Gravity arrow (down)
    canvas.drawLine(
      bobPos,
      bobPos + const Offset(0, 30),
      vectorPaint..color = AppColors.warningAmber,
    );

    // Draw Tension arrow (inwards along string)
    final Offset tensionDir = (pivot - bobPos);
    final Offset tensionVec = Offset(
      tensionDir.dx / tensionDir.distance * 30,
      tensionDir.dy / tensionDir.distance * 30,
    );
    canvas.drawLine(
      bobPos,
      bobPos + tensionVec,
      vectorPaint..color = AppColors.infoBlue,
    );

    // Draw Bob circle
    final bobPaint = Paint()
      ..color = colorScheme.primary
      ..style = PaintingStyle.fill;
    final bobGlow = Paint()
      ..color = colorScheme.primary.withValues(alpha: 0.3)
      ..style = PaintingStyle.fill;

    canvas.drawCircle(bobPos, 16.0, bobGlow);
    canvas.drawCircle(bobPos, 10.0, bobPaint);

    // Readout
    final textPainter = TextPainter(textDirection: textDirection);
    textPainter.text = TextSpan(
      text:
          'Angle θ = ${(theta * 180 / math.pi).toStringAsFixed(1)}°\n'
          'Period T = ${(2 * math.pi / omega).toStringAsFixed(2)} s',
      style: TextStyle(
        color: colorScheme.onSurfaceVariant,
        fontSize: 10,
        fontFamily: 'monospace',
      ),
    );
    textPainter.layout();
    textPainter.paint(canvas, const Offset(20, 20));
  }

  // 3. WAVE SIMULATION
  void _paintWave(Canvas canvas, Size size) {
    final double amp = parameters['A'] ?? parameters['amplitude'] ?? 25.0;
    final double freq = parameters['f'] ?? parameters['frequency'] ?? 1.5;
    final double wavelength =
        parameters['lambda'] ?? parameters['wavelength'] ?? 120.0;

    final double centerY = size.height / 2 + 10;
    final double k = 2 * math.pi / wavelength;
    final double omega = 2 * math.pi * freq;

    final wavePaint = Paint()
      ..color = colorScheme.secondary
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round
      ..strokeWidth = 3.0;

    // Draw traveling sine wave
    final path = Path();
    bool first = true;
    for (double x = 40.0; x < size.width - 40; x += 4.0) {
      // Wave equation y(x,t) = A * sin(k*x - w*t)
      final double y = centerY + amp * math.sin(k * (x - 40.0) - omega * time);
      if (first) {
        path.moveTo(x, y);
        first = false;
      } else {
        path.lineTo(x, y);
      }
    }
    canvas.drawPath(path, wavePaint);

    // Draw oscillating particles (beads on string) to highlight movement
    final particlePaint = Paint()
      ..color = AppColors.white
      ..style = PaintingStyle.fill;

    for (double x = 50.0; x < size.width - 50; x += 40.0) {
      final double y = centerY + amp * math.sin(k * (x - 40.0) - omega * time);
      canvas.drawCircle(Offset(x, y), 4.0, particlePaint);
    }

    // Readout
    final textPainter = TextPainter(textDirection: textDirection);
    textPainter.text = TextSpan(
      text:
          'Velocity v = ${(freq * wavelength).toStringAsFixed(1)} m/s\n'
          'Freq f = ${freq.toStringAsFixed(1)} Hz\n'
          'Wavelength λ = ${wavelength.toStringAsFixed(0)} m',
      style: TextStyle(
        color: colorScheme.onSurfaceVariant,
        fontSize: 10,
        fontFamily: 'monospace',
      ),
    );
    textPainter.layout();
    textPainter.paint(canvas, const Offset(20, 20));
  }

  @override
  bool shouldRepaint(covariant _SimulationPainter oldDelegate) {
    return oldDelegate.time != time ||
        oldDelegate.parameters != parameters ||
        oldDelegate.simulationId != simulationId;
  }
}
