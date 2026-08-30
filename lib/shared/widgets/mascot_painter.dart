import 'dart:math' as math;
import 'package:flutter/material.dart';

/// The mood/pose of the Sigma mascot owl.
///
/// Each mood changes the owl's eyes, mouth, wings, and accessories
/// to convey a distinct emotion across the app.
enum MascotMood {
  /// Wide smile, sparkle eyes — dashboard greeting, session complete.
  happy,

  /// Tilted head, hand on chin — loading states, flashcard front.
  thinking,

  /// Arms raised, star eyes — practice completion, achievements.
  celebrating,

  /// Droopy eyes, small frown — error states, empty states.
  sad,

  /// Waving, thumbs up — flashcard start, study planner.
  encouraging,

  /// Closed eyes, zzz — streak lost, inactive.
  sleeping,
}

/// Draws the Sigma mascot owl using vector paths.
///
/// The owl is a friendly scientist character with round glasses,
/// rendered entirely via [CustomPainter] for zero-asset, theme-aware,
/// perfectly-scalable mascot rendering.
class MascotPainter extends CustomPainter {
  MascotPainter({
    required this.mood,
    required this.primaryColor,
    required this.onPrimaryColor,
    required this.surfaceColor,
    required this.isDark,
    this.breathScale = 1.0,
  });

  final MascotMood mood;
  final Color primaryColor;
  final Color onPrimaryColor;
  final Color surfaceColor;
  final bool isDark;
  final double breathScale;

  @override
  void paint(Canvas canvas, Size size) {
    final cx = size.width / 2;
    final cy = size.height / 2;
    final unit = size.width / 200; // Normalize to 200-unit canvas

    canvas.save();
    // Apply breathing scale
    canvas.translate(cx, cy);
    canvas.scale(breathScale, breathScale);
    canvas.translate(-cx, -cy);

    // Tilt for thinking mood
    if (mood == MascotMood.thinking) {
      canvas.translate(cx, cy);
      canvas.rotate(-0.12);
      canvas.translate(-cx, -cy);
    }

    _drawBody(canvas, cx, cy, unit);
    _drawBelly(canvas, cx, cy, unit);
    _drawWings(canvas, cx, cy, unit);
    _drawFeet(canvas, cx, cy, unit);
    _drawEarTufts(canvas, cx, cy, unit);
    _drawFace(canvas, cx, cy, unit);
    _drawGlasses(canvas, cx, cy, unit);
    _drawEyes(canvas, cx, cy, unit);
    _drawBeak(canvas, cx, cy, unit);
    _drawMouth(canvas, cx, cy, unit);
    _drawAccessories(canvas, cx, cy, unit);

    canvas.restore();
  }

  void _drawBody(Canvas canvas, double cx, double cy, double u) {
    final bodyColor = _bodyColor;
    final paint = Paint()
      ..color = bodyColor
      ..style = PaintingStyle.fill;

    // Main body — rounded oval
    final bodyRect = RRect.fromRectAndRadius(
      Rect.fromCenter(
        center: Offset(cx, cy + 10 * u),
        width: 120 * u,
        height: 130 * u,
      ),
      Radius.circular(55 * u),
    );
    canvas.drawRRect(bodyRect, paint);

    // Head — circle overlapping body top
    canvas.drawCircle(Offset(cx, cy - 30 * u), 48 * u, paint);
  }

  void _drawBelly(Canvas canvas, double cx, double cy, double u) {
    final bellyPaint = Paint()
      ..color = isDark
          ? surfaceColor.withValues(alpha: 0.15)
          : Colors.white.withValues(alpha: 0.85)
      ..style = PaintingStyle.fill;

    final bellyRect = RRect.fromRectAndRadius(
      Rect.fromCenter(
        center: Offset(cx, cy + 22 * u),
        width: 72 * u,
        height: 80 * u,
      ),
      Radius.circular(36 * u),
    );
    canvas.drawRRect(bellyRect, bellyPaint);
  }

  void _drawWings(Canvas canvas, double cx, double cy, double u) {
    final wingPaint = Paint()
      ..color = _wingColor
      ..style = PaintingStyle.fill;

    if (mood == MascotMood.celebrating) {
      // Raised wings
      _drawWingPath(canvas, wingPaint, cx - 58 * u, cy - 10 * u, u, true,
          raised: true);
      _drawWingPath(canvas, wingPaint, cx + 58 * u, cy - 10 * u, u, false,
          raised: true);
    } else if (mood == MascotMood.encouraging) {
      // One wing waving
      _drawWingPath(canvas, wingPaint, cx - 58 * u, cy + 10 * u, u, true);
      _drawWingPath(canvas, wingPaint, cx + 58 * u, cy - 5 * u, u, false,
          raised: true);
    } else {
      // Normal resting wings
      _drawWingPath(canvas, wingPaint, cx - 58 * u, cy + 10 * u, u, true);
      _drawWingPath(canvas, wingPaint, cx + 58 * u, cy + 10 * u, u, false);
    }
  }

  void _drawWingPath(
    Canvas canvas,
    Paint paint,
    double wx,
    double wy,
    double u,
    bool isLeft, {
    bool raised = false,
  }) {
    final path = Path();
    final dir = isLeft ? -1.0 : 1.0;

    if (raised) {
      path.moveTo(wx, wy + 20 * u);
      path.quadraticBezierTo(
        wx + dir * 30 * u,
        wy - 40 * u,
        wx + dir * 15 * u,
        wy - 30 * u,
      );
      path.quadraticBezierTo(wx + dir * 5 * u, wy - 10 * u, wx, wy + 20 * u);
    } else {
      path.moveTo(wx, wy - 10 * u);
      path.quadraticBezierTo(
        wx + dir * 28 * u,
        wy + 15 * u,
        wx + dir * 12 * u,
        wy + 35 * u,
      );
      path.quadraticBezierTo(wx + dir * 5 * u, wy + 20 * u, wx, wy - 10 * u);
    }

    canvas.drawPath(path, paint);
  }

  void _drawFeet(Canvas canvas, double cx, double cy, double u) {
    final feetPaint = Paint()
      ..color = _accentOrange
      ..style = PaintingStyle.fill;

    // Left foot
    final leftFoot = RRect.fromRectAndRadius(
      Rect.fromCenter(
        center: Offset(cx - 18 * u, cy + 72 * u),
        width: 28 * u,
        height: 12 * u,
      ),
      Radius.circular(6 * u),
    );
    canvas.drawRRect(leftFoot, feetPaint);

    // Right foot
    final rightFoot = RRect.fromRectAndRadius(
      Rect.fromCenter(
        center: Offset(cx + 18 * u, cy + 72 * u),
        width: 28 * u,
        height: 12 * u,
      ),
      Radius.circular(6 * u),
    );
    canvas.drawRRect(rightFoot, feetPaint);
  }

  void _drawEarTufts(Canvas canvas, double cx, double cy, double u) {
    final tuftPaint = Paint()
      ..color = _bodyColor
      ..style = PaintingStyle.fill;

    // Left tuft
    final leftTuft = Path()
      ..moveTo(cx - 35 * u, cy - 60 * u)
      ..lineTo(cx - 48 * u, cy - 88 * u)
      ..lineTo(cx - 22 * u, cy - 68 * u)
      ..close();
    canvas.drawPath(leftTuft, tuftPaint);

    // Right tuft
    final rightTuft = Path()
      ..moveTo(cx + 35 * u, cy - 60 * u)
      ..lineTo(cx + 48 * u, cy - 88 * u)
      ..lineTo(cx + 22 * u, cy - 68 * u)
      ..close();
    canvas.drawPath(rightTuft, tuftPaint);
  }

  void _drawFace(Canvas canvas, double cx, double cy, double u) {
    // Facial disc — lighter area around eyes
    final discPaint = Paint()
      ..color = isDark
          ? surfaceColor.withValues(alpha: 0.12)
          : Colors.white.withValues(alpha: 0.7)
      ..style = PaintingStyle.fill;

    // Left eye disc
    canvas.drawOval(
      Rect.fromCenter(
        center: Offset(cx - 17 * u, cy - 30 * u),
        width: 30 * u,
        height: 32 * u,
      ),
      discPaint,
    );

    // Right eye disc
    canvas.drawOval(
      Rect.fromCenter(
        center: Offset(cx + 17 * u, cy - 30 * u),
        width: 30 * u,
        height: 32 * u,
      ),
      discPaint,
    );
  }

  void _drawGlasses(Canvas canvas, double cx, double cy, double u) {
    final glassPaint = Paint()
      ..color = isDark ? Colors.white70 : const Color(0xFF3D3D3D)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2.5 * u
      ..strokeCap = StrokeCap.round;

    // Left lens
    canvas.drawCircle(Offset(cx - 17 * u, cy - 30 * u), 14 * u, glassPaint);

    // Right lens
    canvas.drawCircle(Offset(cx + 17 * u, cy - 30 * u), 14 * u, glassPaint);

    // Bridge
    canvas.drawLine(
      Offset(cx - 3 * u, cy - 30 * u),
      Offset(cx + 3 * u, cy - 30 * u),
      glassPaint,
    );

    // Lens shine
    final shinePaint = Paint()
      ..color = Colors.white.withValues(alpha: 0.4)
      ..style = PaintingStyle.fill;
    canvas.drawCircle(Offset(cx - 21 * u, cy - 34 * u), 3 * u, shinePaint);
    canvas.drawCircle(Offset(cx + 13 * u, cy - 34 * u), 3 * u, shinePaint);
  }

  void _drawEyes(Canvas canvas, double cx, double cy, double u) {
    final eyeWhitePaint = Paint()
      ..color = Colors.white
      ..style = PaintingStyle.fill;

    final pupilPaint = Paint()
      ..color = isDark ? const Color(0xFF1A1A2E) : const Color(0xFF2D2D44)
      ..style = PaintingStyle.fill;

    final sparkle = Paint()
      ..color = Colors.white
      ..style = PaintingStyle.fill;

    switch (mood) {
      case MascotMood.sleeping:
        // Closed eyes — small arcs
        final closedPaint = Paint()
          ..color = isDark ? Colors.white70 : const Color(0xFF2D2D44)
          ..style = PaintingStyle.stroke
          ..strokeWidth = 2.5 * u
          ..strokeCap = StrokeCap.round;

        canvas.drawArc(
          Rect.fromCenter(
            center: Offset(cx - 17 * u, cy - 30 * u),
            width: 16 * u,
            height: 8 * u,
          ),
          0,
          math.pi,
          false,
          closedPaint,
        );
        canvas.drawArc(
          Rect.fromCenter(
            center: Offset(cx + 17 * u, cy - 30 * u),
            width: 16 * u,
            height: 8 * u,
          ),
          0,
          math.pi,
          false,
          closedPaint,
        );

      case MascotMood.celebrating:
        // Star eyes
        _drawStarEye(canvas, cx - 17 * u, cy - 30 * u, 7 * u, primaryColor);
        _drawStarEye(canvas, cx + 17 * u, cy - 30 * u, 7 * u, primaryColor);

      case MascotMood.sad:
        // Droopy eyes
        canvas.drawCircle(
            Offset(cx - 17 * u, cy - 28 * u), 8 * u, eyeWhitePaint);
        canvas.drawCircle(
            Offset(cx + 17 * u, cy - 28 * u), 8 * u, eyeWhitePaint);
        canvas.drawCircle(
            Offset(cx - 17 * u, cy - 27 * u), 4.5 * u, pupilPaint);
        canvas.drawCircle(
            Offset(cx + 17 * u, cy - 27 * u), 4.5 * u, pupilPaint);

        // Droopy eyebrows
        final browPaint = Paint()
          ..color = _wingColor
          ..style = PaintingStyle.stroke
          ..strokeWidth = 2.5 * u
          ..strokeCap = StrokeCap.round;
        canvas.drawLine(
          Offset(cx - 24 * u, cy - 40 * u),
          Offset(cx - 10 * u, cy - 38 * u),
          browPaint,
        );
        canvas.drawLine(
          Offset(cx + 24 * u, cy - 40 * u),
          Offset(cx + 10 * u, cy - 38 * u),
          browPaint,
        );

      default:
        // Normal / happy / thinking / encouraging eyes
        canvas.drawCircle(
            Offset(cx - 17 * u, cy - 30 * u), 8 * u, eyeWhitePaint);
        canvas.drawCircle(
            Offset(cx + 17 * u, cy - 30 * u), 8 * u, eyeWhitePaint);

        final pupilOffset = mood == MascotMood.thinking ? 2 * u : 0.0;
        canvas.drawCircle(
          Offset(cx - 17 * u + pupilOffset, cy - 30 * u),
          4.5 * u,
          pupilPaint,
        );
        canvas.drawCircle(
          Offset(cx + 17 * u + pupilOffset, cy - 30 * u),
          4.5 * u,
          pupilPaint,
        );

        // Sparkle highlights
        canvas.drawCircle(
          Offset(cx - 19 * u + pupilOffset, cy - 32 * u),
          1.8 * u,
          sparkle,
        );
        canvas.drawCircle(
          Offset(cx + 15 * u + pupilOffset, cy - 32 * u),
          1.8 * u,
          sparkle,
        );
    }
  }

  void _drawStarEye(
      Canvas canvas, double x, double y, double radius, Color color) {
    final paint = Paint()
      ..color = color
      ..style = PaintingStyle.fill;

    final path = Path();
    for (int i = 0; i < 5; i++) {
      final angle = (i * 72 - 90) * math.pi / 180;
      final innerAngle = ((i * 72) + 36 - 90) * math.pi / 180;
      final outerX = x + radius * math.cos(angle);
      final outerY = y + radius * math.sin(angle);
      final innerX = x + radius * 0.4 * math.cos(innerAngle);
      final innerY = y + radius * 0.4 * math.sin(innerAngle);

      if (i == 0) {
        path.moveTo(outerX, outerY);
      } else {
        path.lineTo(outerX, outerY);
      }
      path.lineTo(innerX, innerY);
    }
    path.close();
    canvas.drawPath(path, paint);
  }

  void _drawBeak(Canvas canvas, double cx, double cy, double u) {
    final beakPaint = Paint()
      ..color = _accentOrange
      ..style = PaintingStyle.fill;

    final beak = Path()
      ..moveTo(cx - 5 * u, cy - 18 * u)
      ..lineTo(cx, cy - 12 * u)
      ..lineTo(cx + 5 * u, cy - 18 * u)
      ..close();

    canvas.drawPath(beak, beakPaint);
  }

  void _drawMouth(Canvas canvas, double cx, double cy, double u) {
    final mouthPaint = Paint()
      ..color = isDark ? Colors.white60 : const Color(0xFF2D2D44)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2.0 * u
      ..strokeCap = StrokeCap.round;

    switch (mood) {
      case MascotMood.happy || MascotMood.celebrating || MascotMood.encouraging:
        // Smile
        canvas.drawArc(
          Rect.fromCenter(
            center: Offset(cx, cy - 10 * u),
            width: 14 * u,
            height: 8 * u,
          ),
          0.2,
          math.pi - 0.4,
          false,
          mouthPaint,
        );

      case MascotMood.sad:
        // Frown
        canvas.drawArc(
          Rect.fromCenter(
            center: Offset(cx, cy - 6 * u),
            width: 12 * u,
            height: 6 * u,
          ),
          math.pi + 0.3,
          math.pi - 0.6,
          false,
          mouthPaint,
        );

      case MascotMood.thinking:
        // Small "o" mouth
        final oPaint = Paint()
          ..color = mouthPaint.color
          ..style = PaintingStyle.stroke
          ..strokeWidth = 1.8 * u;
        canvas.drawCircle(Offset(cx + 2 * u, cy - 10 * u), 3 * u, oPaint);

      case MascotMood.sleeping:
        // Flat line
        canvas.drawLine(
          Offset(cx - 5 * u, cy - 10 * u),
          Offset(cx + 5 * u, cy - 10 * u),
          mouthPaint,
        );
    }
  }

  void _drawAccessories(Canvas canvas, double cx, double cy, double u) {
    switch (mood) {
      case MascotMood.sleeping:
        _drawZzz(canvas, cx, cy, u);

      case MascotMood.celebrating:
        _drawSparkles(canvas, cx, cy, u);

      case MascotMood.thinking:
        _drawThoughtDots(canvas, cx, cy, u);

      default:
        break;
    }

    // Sigma symbol on belly (always present)
    _drawSigmaSymbol(canvas, cx, cy, u);
  }

  void _drawSigmaSymbol(Canvas canvas, double cx, double cy, double u) {
    final sigmaPaint = Paint()
      ..color = primaryColor.withValues(alpha: 0.6)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2.5 * u
      ..strokeCap = StrokeCap.round
      ..strokeJoin = StrokeJoin.round;

    // Draw Σ
    final sigma = Path()
      ..moveTo(cx + 8 * u, cy + 10 * u)
      ..lineTo(cx - 8 * u, cy + 10 * u)
      ..lineTo(cx + 2 * u, cy + 22 * u)
      ..lineTo(cx - 8 * u, cy + 34 * u)
      ..lineTo(cx + 8 * u, cy + 34 * u);

    canvas.drawPath(sigma, sigmaPaint);
  }

  void _drawZzz(Canvas canvas, double cx, double cy, double u) {
    final zPaint = Paint()
      ..color = primaryColor.withValues(alpha: 0.5)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2.0 * u
      ..strokeCap = StrokeCap.round;

    final textPainter = TextPainter(
      text: TextSpan(
        text: 'z',
        style: TextStyle(
          fontSize: 12 * u,
          fontWeight: FontWeight.bold,
          color: primaryColor.withValues(alpha: 0.5),
        ),
      ),
      textDirection: TextDirection.ltr,
    )..layout();

    textPainter.paint(canvas, Offset(cx + 35 * u, cy - 55 * u));

    final textPainter2 = TextPainter(
      text: TextSpan(
        text: 'z',
        style: TextStyle(
          fontSize: 16 * u,
          fontWeight: FontWeight.bold,
          color: primaryColor.withValues(alpha: 0.4),
        ),
      ),
      textDirection: TextDirection.ltr,
    )..layout();

    textPainter2.paint(canvas, Offset(cx + 45 * u, cy - 72 * u));

    final textPainter3 = TextPainter(
      text: TextSpan(
        text: 'Z',
        style: TextStyle(
          fontSize: 20 * u,
          fontWeight: FontWeight.bold,
          color: primaryColor.withValues(alpha: 0.3),
        ),
      ),
      textDirection: TextDirection.ltr,
    )..layout();

    textPainter3.paint(canvas, Offset(cx + 52 * u, cy - 92 * u));
  }

  void _drawSparkles(Canvas canvas, double cx, double cy, double u) {
    final sparklePaint = Paint()
      ..color = primaryColor
      ..style = PaintingStyle.fill;

    // Small stars around the owl
    _drawStarEye(canvas, cx - 50 * u, cy - 60 * u, 5 * u, primaryColor);
    _drawStarEye(canvas, cx + 50 * u, cy - 55 * u, 4 * u,
        primaryColor.withValues(alpha: 0.7));
    _drawStarEye(canvas, cx + 55 * u, cy - 20 * u, 3 * u,
        primaryColor.withValues(alpha: 0.5));
    _drawStarEye(canvas, cx - 55 * u, cy - 15 * u, 3.5 * u,
        primaryColor.withValues(alpha: 0.6));
  }

  void _drawThoughtDots(Canvas canvas, double cx, double cy, double u) {
    final dotPaint = Paint()
      ..color = primaryColor.withValues(alpha: 0.3)
      ..style = PaintingStyle.fill;

    canvas.drawCircle(Offset(cx + 42 * u, cy - 50 * u), 3 * u, dotPaint);
    canvas.drawCircle(Offset(cx + 50 * u, cy - 60 * u), 4 * u, dotPaint);
    canvas.drawCircle(Offset(cx + 55 * u, cy - 72 * u), 5 * u, dotPaint);
  }

  // ──────────────── Color Helpers ──────────────────

  Color get _bodyColor {
    if (isDark) {
      return Color.lerp(primaryColor, const Color(0xFF2D3748), 0.6)!;
    }
    return Color.lerp(primaryColor, const Color(0xFF8ECAE6), 0.3)!;
  }

  Color get _wingColor {
    if (isDark) {
      return Color.lerp(primaryColor, const Color(0xFF1A202C), 0.7)!;
    }
    return Color.lerp(primaryColor, const Color(0xFF5B8DB8), 0.4)!;
  }

  Color get _accentOrange => const Color(0xFFFF9F43);

  @override
  bool shouldRepaint(covariant MascotPainter oldDelegate) =>
      oldDelegate.mood != mood ||
      oldDelegate.breathScale != breathScale ||
      oldDelegate.primaryColor != primaryColor ||
      oldDelegate.isDark != isDark;
}
