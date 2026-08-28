import 'dart:math' as math;
import 'package:flutter/material.dart';
import '../../../../core/core.dart';
import 'graph_painter.dart';

class NativeGraphWidget extends StatefulWidget {
  const NativeGraphWidget({
    super.key,
    required this.config,
    required this.parameters,
  });

  final Map<String, dynamic> config;
  final Map<String, double> parameters;

  @override
  State<NativeGraphWidget> createState() => _NativeGraphWidgetState();
}

class _InteractiveGraphState {
  double panX = 0;
  double panY = 0;
  double scale = 1.0;
}

class _NativeGraphWidgetState extends State<NativeGraphWidget> {
  final _InteractiveGraphState _viewState = _InteractiveGraphState();

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    final expressions = widget.config['expressions'] as List<dynamic>? ?? [];
    final viewport = widget.config['viewport'] as Map<String, dynamic>? ?? {};

    final double xMinDefault = _asDouble(
      viewport['xMin'] ?? -10.0,
      fallback: -10.0,
    );
    final double xMaxDefault = _asDouble(
      viewport['xMax'] ?? 10.0,
      fallback: 10.0,
    );
    final double yMinDefault = _asDouble(
      viewport['yMin'] ?? -10.0,
      fallback: -10.0,
    );
    final double yMaxDefault = _asDouble(
      viewport['yMax'] ?? 10.0,
      fallback: 10.0,
    );

    final textDirection = Directionality.of(context);

    return GestureDetector(
      onPanUpdate: (details) {
        setState(() {
          // Adjust pan based on screen movement
          _viewState.panX += details.delta.dx;
          _viewState.panY += details.delta.dy;
        });
      },
      child: Container(
        color: AppColors.black.withValues(alpha: 0.2),
        child: ClipRect(
          child: RepaintBoundary(
            child: CustomPaint(
              painter: GraphPainter(
                expressions: expressions,
                parameters: widget.parameters,
                xMinDefault: xMinDefault,
                xMaxDefault: xMaxDefault,
                yMinDefault: yMinDefault,
                yMaxDefault: yMaxDefault,
                panX: _viewState.panX,
                panY: _viewState.panY,
                colorScheme: colorScheme,
                textDirection: textDirection,
              ),
            ),
          ),
        ),
      ),
    );
  }

  double _asDouble(Object? value, {required double fallback}) {
    if (value is double) return value;
    if (value is int) return value.toDouble();
    if (value is num) return value.toDouble();
    return fallback;
  }
}

