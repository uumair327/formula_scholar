import 'dart:math' as math;
import 'package:flutter/material.dart';
import '../../../../core/core.dart';
import '../../domain/domain.dart';

class Point3D {
  Point3D(this.x, this.y, this.z);
  final double x;
  final double y;
  final double z;
}

class ThreeDCanvasPainter extends CustomPainter {
  ThreeDCanvasPainter({
    required this.type,
    required this.angleX,
    required this.angleY,
    required this.paramA,
    required this.paramB,
    required this.paramC,
    required this.colorScheme,
  });

  final VisualizerType type;
  final double angleX;
  final double angleY;
  final double paramA;
  final double paramB;
  final double paramC;
  final ColorScheme colorScheme;

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    // Use min of width/height to ensure uniform scaling that doesn't blow out vertical bounds on web
    final radiusBase = math.min(size.width, size.height) * 0.35;

    switch (type) {
      case VisualizerType.sphere:
        _drawSphere(canvas, center, radiusBase);
      case VisualizerType.cone:
        _drawCone(canvas, center, radiusBase);
      case VisualizerType.cylinder:
        _drawCylinder(canvas, center, radiusBase);
      case VisualizerType.gravitation:
        _drawGravitation(canvas, center, radiusBase);
      case VisualizerType.refraction:
        _drawRefraction(canvas, center, radiusBase);
      case VisualizerType.quadratic:
        _drawQuadratic(canvas, center, radiusBase);
      case VisualizerType.dna:
        _drawDna(canvas, center, radiusBase);
      case VisualizerType.polyhedron:
        _drawPolyhedron(canvas, center, radiusBase);
      case VisualizerType.frustum:
        _drawFrustum(canvas, center, radiusBase);
    }
  }

  Point3D _project(Point3D pt, double d) {
    final x1 = pt.x * math.cos(angleY) - pt.z * math.sin(angleY);
    final z1 = pt.x * math.sin(angleY) + pt.z * math.cos(angleY);
    final y1 = pt.y * math.cos(angleX) - z1 * math.sin(angleX);
    final z2 = pt.y * math.sin(angleX) + z1 * math.cos(angleX);
    const cameraDist = 400.0;
    final scale = cameraDist / (cameraDist + z2);
    return Point3D(x1 * scale, y1 * scale, z2);
  }

  void _drawSphere(Canvas canvas, Offset center, double radiusBase) {
    final radius = radiusBase * paramA;
    final strokePaint = Paint()
      ..color = colorScheme.primary.withValues(alpha: 0.4)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.0;
    final glowPaint = Paint()
      ..color = colorScheme.primary.withValues(alpha: 0.05)
      ..style = PaintingStyle.fill;
    canvas.drawCircle(center, radius, glowPaint);

    const ringCount = 8;
    for (int i = 0; i < ringCount; i++) {
      final lat = (i / ringCount) * math.pi;
      final path = Path();
      var first = true;
      for (int j = 0; j <= 36; j++) {
        final lon = (j / 36) * 2 * math.pi;
        final x = radius * math.sin(lat) * math.cos(lon);
        final y = radius * math.cos(lat);
        final z = radius * math.sin(lat) * math.sin(lon);
        final proj = _project(Point3D(x, y, z), radius);
        if (first) {
          path.moveTo(center.dx + proj.x, center.dy + proj.y);
          first = false;
        } else {
          path.lineTo(center.dx + proj.x, center.dy + proj.y);
        }
      }
      canvas.drawPath(path, strokePaint);
    }
  }

  void _drawCylinder(Canvas canvas, Offset center, double radiusBase) {
    final radius = radiusBase * paramA;
    final height = radiusBase * 1.5 * paramB;
    final strokePaint = Paint()
      ..color = AppColors.orange500.withValues(alpha: 0.5)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.5;
    final topRing = Path();
    final bottomRing = Path();
    var first = true;
    final topPoints = <Offset>[];
    final bottomPoints = <Offset>[];

    for (int i = 0; i <= 36; i++) {
      final angle = (i / 36) * 2 * math.pi;
      final x = radius * math.cos(angle);
      final z = radius * math.sin(angle);
      final ptTop = _project(Point3D(x, -height / 2, z), radius);
      final ptBottom = _project(Point3D(x, height / 2, z), radius);
      topPoints.add(Offset(center.dx + ptTop.x, center.dy + ptTop.y));
      bottomPoints.add(Offset(center.dx + ptBottom.x, center.dy + ptBottom.y));
      if (first) {
        topRing.moveTo(center.dx + ptTop.x, center.dy + ptTop.y);
        bottomRing.moveTo(center.dx + ptBottom.x, center.dy + ptBottom.y);
        first = false;
      } else {
        topRing.lineTo(center.dx + ptTop.x, center.dy + ptTop.y);
        bottomRing.lineTo(center.dx + ptBottom.x, center.dy + ptBottom.y);
      }
    }
    canvas.drawPath(topRing, strokePaint);
    canvas.drawPath(bottomRing, strokePaint);
    for (int i = 0; i < 36; i += 6) {
      canvas.drawLine(topPoints[i], bottomPoints[i], strokePaint);
    }
  }

  void _drawCone(Canvas canvas, Offset center, double radiusBase) {
    final radius = radiusBase * paramA;
    final height = radiusBase * 1.5 * paramB;
    final strokePaint = Paint()
      ..color = colorScheme.secondary.withValues(alpha: 0.5)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.5;
    final basePoints = <Offset>[];
    final baseRing = Path();
    var first = true;

    for (int i = 0; i <= 36; i++) {
      final angle = (i / 36) * 2 * math.pi;
      final x = radius * math.cos(angle);
      final z = radius * math.sin(angle);
      final ptBase = _project(Point3D(x, height / 2, z), radius);
      basePoints.add(Offset(center.dx + ptBase.x, center.dy + ptBase.y));
      if (first) {
        baseRing.moveTo(center.dx + ptBase.x, center.dy + ptBase.y);
        first = false;
      } else {
        baseRing.lineTo(center.dx + ptBase.x, center.dy + ptBase.y);
      }
    }
    final ptTip = _project(Point3D(0, -height / 2, 0), radius);
    final tipOffset = Offset(center.dx + ptTip.x, center.dy + ptTip.y);
    canvas.drawPath(baseRing, strokePaint);
    for (int i = 0; i < 36; i += 6) {
      canvas.drawLine(tipOffset, basePoints[i], strokePaint);
    }
  }

  void _drawGravitation(Canvas canvas, Offset center, double radiusBase) {
    final sunMass = radiusBase * 0.4 * paramA;
    final orbitRadius = radiusBase * 1.8 * paramB;
    final sunPaint = Paint()
      ..color = AppColors.orange500
      ..style = PaintingStyle.fill;
    final sunGlow = Paint()
      ..color = AppColors.orange500.withValues(alpha: 0.2)
      ..style = PaintingStyle.fill;
    canvas.drawCircle(center, sunMass, sunPaint);
    canvas.drawCircle(center, sunMass * 1.6, sunGlow);

    final orbitPaint = Paint()
      ..color = colorScheme.outline.withValues(alpha: 0.2)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.0;
    final orbitPath = Path();
    var first = true;
    final orbitPoints = <Offset>[];

    for (int i = 0; i <= 72; i++) {
      final angle = (i / 72) * 2 * math.pi;
      final x = orbitRadius * math.cos(angle);
      final z = orbitRadius * math.sin(angle);
      final pt = _project(Point3D(x, 0, z), orbitRadius);
      final offset = Offset(center.dx + pt.x, center.dy + pt.y);
      orbitPoints.add(offset);
      if (first) {
        orbitPath.moveTo(offset.dx, offset.dy);
        first = false;
      } else {
        orbitPath.lineTo(offset.dx, offset.dy);
      }
    }
    canvas.drawPath(orbitPath, orbitPaint);

    final time = DateTime.now().millisecondsSinceEpoch * 0.003 * paramC;
    final planetIndex = (time * 10).round() % orbitPoints.length;
    final planetPos = orbitPoints[planetIndex];
    final planetPaint = Paint()
      ..color = colorScheme.primary
      ..style = PaintingStyle.fill;
    canvas.drawCircle(planetPos, 12.0, planetPaint);

    final vectorPaint = Paint()
      ..color = colorScheme.primary.withValues(alpha: 0.4)
      ..strokeWidth = 2.0;
    canvas.drawLine(center, planetPos, vectorPaint);
  }

  void _drawRefraction(Canvas canvas, Offset center, double radiusBase) {
    final prismSize = radiusBase * 1.4 * paramB;
    final strokePaint = Paint()
      ..color = colorScheme.primary.withValues(alpha: 0.6)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2.0;

    final pt1 = _project(Point3D(0, -prismSize / 2, 0), prismSize);
    final pt2 = _project(
      Point3D(-prismSize / 2, prismSize / 2, prismSize / 2),
      prismSize,
    );
    final pt3 = _project(
      Point3D(prismSize / 2, prismSize / 2, prismSize / 2),
      prismSize,
    );
    final pt4 = _project(Point3D(0, prismSize / 2, -prismSize / 2), prismSize);

    final o1 = Offset(center.dx + pt1.x, center.dy + pt1.y);
    final o2 = Offset(center.dx + pt2.x, center.dy + pt2.y);
    final o3 = Offset(center.dx + pt3.x, center.dy + pt3.y);
    final o4 = Offset(center.dx + pt4.x, center.dy + pt4.y);

    canvas.drawLine(o1, o2, strokePaint);
    canvas.drawLine(o1, o3, strokePaint);
    canvas.drawLine(o1, o4, strokePaint);
    canvas.drawLine(o2, o3, strokePaint);
    canvas.drawLine(o3, o4, strokePaint);
    canvas.drawLine(o4, o2, strokePaint);

    final inputStart = Offset(
      center.dx - radiusBase * 2,
      center.dy + radiusBase * 0.5,
    );
    final inputEnd = Offset(
      center.dx - prismSize * 0.2,
      center.dy + prismSize * 0.1,
    );
    final n = paramC;
    final deviationAngle = (n - 1) * 0.8;
    final refractEnd = Offset(
      center.dx + prismSize * 0.2,
      center.dy + prismSize * 0.05,
    );
    final dx = refractEnd.dx - inputEnd.dx;
    final dy = refractEnd.dy - inputEnd.dy;
    final exitStart = refractEnd;
    final exitEnd = Offset(
      exitStart.dx + dx * 2.0 * math.cos(deviationAngle),
      exitStart.dy + dy * 2.0 * math.sin(deviationAngle),
    );

    final laserIn = Paint()
      ..color = AppColors.white
      ..strokeWidth = 3.0;
    canvas.drawLine(inputStart, inputEnd, laserIn);
    final laserRefract = Paint()
      ..color = Colors.cyanAccent
      ..strokeWidth = 2.0;
    canvas.drawLine(inputEnd, refractEnd, laserRefract);

    for (int i = 0; i < 7; i++) {
      final spectrumPaint = Paint()
        ..color = Colors.primaries[i % Colors.primaries.length]
        ..strokeWidth = 2.0;
      canvas.drawLine(
        exitStart,
        Offset(exitEnd.dx, exitEnd.dy + i * 2.5 - 7.5),
        spectrumPaint,
      );
    }
  }

  void _drawQuadratic(Canvas canvas, Offset center, double radiusBase) {
    final aVal = paramA * 0.005;
    final bVal = paramB * 0.1;
    final cVal = paramC * 10;
    final paint = Paint()
      ..color = colorScheme.primary.withValues(alpha: 0.3)
      ..strokeWidth = 1.0;
    final gridPoints = <List<Point3D>>[];
    const steps = 10;
    final gridExtent = radiusBase * 1.5;

    for (int i = -steps; i <= steps; i++) {
      final x = (i / steps) * gridExtent;
      final row = <Point3D>[];
      for (int j = -steps; j <= steps; j++) {
        final z = (j / steps) * gridExtent;
        final y = aVal * (x * x) + bVal * (x * z) - cVal;
        row.add(Point3D(x, y, z));
      }
      gridPoints.add(row);
    }

    for (int i = 0; i < gridPoints.length; i++) {
      for (int j = 0; j < gridPoints[i].length; j++) {
        final projCurrent = _project(gridPoints[i][j], radiusBase);
        final currentOffset = Offset(
          center.dx + projCurrent.x,
          center.dy + projCurrent.y,
        );
        if (i < gridPoints.length - 1) {
          final projNextX = _project(gridPoints[i + 1][j], radiusBase);
          canvas.drawLine(
            currentOffset,
            Offset(center.dx + projNextX.x, center.dy + projNextX.y),
            paint,
          );
        }
        if (j < gridPoints[i].length - 1) {
          final projNextZ = _project(gridPoints[i][j + 1], radiusBase);
          canvas.drawLine(
            currentOffset,
            Offset(center.dx + projNextZ.x, center.dy + projNextZ.y),
            paint,
          );
        }
      }
    }
  }

  void _drawDna(Canvas canvas, Offset center, double radiusBase) {
    final helixRadius = radiusBase * 0.7 * paramA;
    final helixLength = radiusBase * 1.8 * paramB;
    final rPaint = Paint()
      ..color = colorScheme.secondary
      ..strokeWidth = 3.0;
    final gPaint = Paint()
      ..color = colorScheme.tertiary
      ..strokeWidth = 3.0;
    final strandPaint = Paint()
      ..color = colorScheme.primary.withValues(alpha: 0.4)
      ..strokeWidth = 1.5;

    const steps = 24;
    final freq = 2.5 * paramC;

    for (int i = 0; i < steps; i++) {
      final ratio = i / steps;
      final angle = ratio * 2 * math.pi * freq;
      final y = -helixLength / 2 + ratio * helixLength;

      final x1 = helixRadius * math.cos(angle);
      final z1 = helixRadius * math.sin(angle);
      final pt1 = _project(Point3D(x1, y, z1), radiusBase);
      final o1 = Offset(center.dx + pt1.x, center.dy + pt1.y);

      final x2 = helixRadius * math.cos(angle + math.pi);
      final z2 = helixRadius * math.sin(angle + math.pi);
      final pt2 = _project(Point3D(x2, y, z2), radiusBase);
      final o2 = Offset(center.dx + pt2.x, center.dy + pt2.y);

      canvas.drawCircle(o1, 5.0, rPaint);
      canvas.drawCircle(o2, 5.0, gPaint);

      if (i > 0) {
        canvas.drawLine(o1, o2, strandPaint);
      }
    }
  }

  void _drawPolyhedron(Canvas canvas, Offset center, double radiusBase) {
    final size = radiusBase * 1.3 * paramA;
    final height = radiusBase * 1.5 * paramB;
    final strokePaint = Paint()
      ..color = colorScheme.primary.withValues(alpha: 0.7)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.5;

    final vertices = <Point3D>[
      Point3D(0, -height / 2, 0),
      Point3D(-size / 2, height / 2, -size / 2),
      Point3D(size / 2, height / 2, -size / 2),
      Point3D(size / 2, height / 2, size / 2),
      Point3D(-size / 2, height / 2, size / 2),
    ];

    final projected = vertices.map((v) => _project(v, radiusBase)).toList();
    final offsets = projected
        .map((p) => Offset(center.dx + p.x, center.dy + p.y))
        .toList();

    for (int i = 1; i <= 4; i++) {
      canvas.drawLine(offsets[0], offsets[i], strokePaint);
    }
    canvas.drawLine(offsets[1], offsets[2], strokePaint);
    canvas.drawLine(offsets[2], offsets[3], strokePaint);
    canvas.drawLine(offsets[3], offsets[4], strokePaint);
    canvas.drawLine(offsets[4], offsets[1], strokePaint);
  }

  void _drawFrustum(Canvas canvas, Offset center, double radiusBase) {
    final r1 = radiusBase * paramA;
    final r2 = radiusBase * paramB * 0.6;
    final height = radiusBase * 1.5 * paramC;
    final strokePaint = Paint()
      ..color = colorScheme.secondary.withValues(alpha: 0.5)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.5;
    final topRing = Path();
    final bottomRing = Path();
    var first = true;
    final topPoints = <Offset>[];
    final bottomPoints = <Offset>[];

    for (int i = 0; i <= 36; i++) {
      final angle = (i / 36) * 2 * math.pi;
      final xTop = r2 * math.cos(angle);
      final zTop = r2 * math.sin(angle);
      final xBottom = r1 * math.cos(angle);
      final zBottom = r1 * math.sin(angle);
      final ptTop = _project(Point3D(xTop, -height / 2, zTop), r2);
      final ptBottom = _project(Point3D(xBottom, height / 2, zBottom), r1);
      topPoints.add(Offset(center.dx + ptTop.x, center.dy + ptTop.y));
      bottomPoints.add(Offset(center.dx + ptBottom.x, center.dy + ptBottom.y));
      if (first) {
        topRing.moveTo(center.dx + ptTop.x, center.dy + ptTop.y);
        bottomRing.moveTo(center.dx + ptBottom.x, center.dy + ptBottom.y);
        first = false;
      } else {
        topRing.lineTo(center.dx + ptTop.x, center.dy + ptTop.y);
        bottomRing.lineTo(center.dx + ptBottom.x, center.dy + ptBottom.y);
      }
    }
    canvas.drawPath(topRing, strokePaint);
    canvas.drawPath(bottomRing, strokePaint);
    for (int i = 0; i < 36; i += 6) {
      canvas.drawLine(topPoints[i], bottomPoints[i], strokePaint);
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}
