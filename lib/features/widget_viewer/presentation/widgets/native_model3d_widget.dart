import 'dart:math' as math;
import 'package:flutter/material.dart';
import '../../../../core/core.dart';
import '../../../visualizer_3d/domain/domain.dart';
import '../../../visualizer_3d/presentation/widgets/three_d_canvas_painter.dart';
import '../../../visualizer_3d/presentation/widgets/grid_background_painter.dart';

class NativeModel3DWidget extends StatefulWidget {
  const NativeModel3DWidget({
    super.key,
    required this.config,
    required this.parameters,
  });

  final Map<String, dynamic> config;
  final Map<String, double> parameters;

  @override
  State<NativeModel3DWidget> createState() => _NativeModel3DWidgetState();
}

class _NativeModel3DWidgetState extends State<NativeModel3DWidget>
    with SingleTickerProviderStateMixin {
  double _angleX = 0.5;
  double _angleY = 0.5;
  late final AnimationController _autoRotateController;
  bool _isAutoRotating = true;

  @override
  void initState() {
    super.initState();
    _autoRotateController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 15),
    )..addListener(() {
        if (_isAutoRotating) {
          setState(() {
            _angleY += 0.01;
          });
        }
      });
    _autoRotateController.repeat();
  }

  @override
  void dispose() {
    _autoRotateController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    // Determine shape/visualizer type from config
    final shapeStr = widget.config['shape'] ??
        (widget.config['source'] is Map ? widget.config['source']['shape'] : null) ??
        'sphere';

    final visualizerType = _parseShapeType(shapeStr.toString());

    // Extract parameters for painter
    final a = widget.parameters['a'] ?? widget.parameters['paramA'] ?? 1.0;
    final b = widget.parameters['b'] ?? widget.parameters['paramB'] ?? 1.0;
    final c = widget.parameters['c'] ?? widget.parameters['paramC'] ?? 1.0;

    return GestureDetector(
      onPanUpdate: (details) {
        setState(() {
          _angleX = (_angleX - details.delta.dy * 0.01).clamp(-math.pi / 2, math.pi / 2);
          _angleY += details.delta.dx * 0.01;
          _isAutoRotating = false; // Disable auto-rotate on user drag
        });
      },
      child: Container(
        color: Colors.black.withValues(alpha: 0.3),
        child: Stack(
          children: [
            // Holographic grid background
            Positioned.fill(
              child: CustomPaint(
                painter: GridBackgroundPainter(colorScheme),
              ),
            ),

            // 3D Canvas Projection Painter
            Positioned.fill(
              child: CustomPaint(
                painter: ThreeDCanvasPainter(
                  type: visualizerType,
                  angleX: _angleX,
                  angleY: _angleY,
                  paramA: a,
                  paramB: b,
                  paramC: c,
                  colorScheme: colorScheme,
                ),
              ),
            ),

            // Holographic data overlay
            Positioned(
              top: AppDimensions.paddingMD,
              left: AppDimensions.paddingMD,
              child: _HologramStat(
                label: 'SHAPE MODE',
                value: visualizerType.name.toUpperCase(),
              ),
            ),
            Positioned(
              top: AppDimensions.paddingMD,
              right: AppDimensions.paddingMD,
              child: IconButton(
                icon: Icon(
                  _isAutoRotating ? Icons.pause_circle : Icons.play_circle,
                  color: colorScheme.primary,
                ),
                onPressed: () {
                  setState(() {
                    _isAutoRotating = !_isAutoRotating;
                  });
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  VisualizerType _parseShapeType(String shape) {
    final lower = shape.toLowerCase();
    if (lower.contains('sphere')) return VisualizerType.sphere;
    if (lower.contains('cone')) return VisualizerType.cone;
    if (lower.contains('cylinder')) return VisualizerType.cylinder;
    if (lower.contains('gravitation')) return VisualizerType.gravitation;
    if (lower.contains('refraction')) return VisualizerType.refraction;
    if (lower.contains('quadratic')) return VisualizerType.quadratic;
    if (lower.contains('dna')) return VisualizerType.dna;
    return VisualizerType.polyhedron;
  }
}

class _HologramStat extends StatelessWidget {
  const _HologramStat({required this.label, required this.value});

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: AppDimensions.paddingSM,
        vertical: AppDimensions.paddingXS,
      ),
      decoration: BoxDecoration(
        color: colorScheme.surface.withValues(alpha: 0.6),
        borderRadius: BorderRadius.circular(AppDimensions.radiusSM),
        border: Border.all(
          color: colorScheme.primary.withValues(alpha: 0.2),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: TextStyle(
              fontSize: 8,
              letterSpacing: 1.5,
              fontWeight: FontWeight.bold,
              color: colorScheme.primary.withValues(alpha: 0.7),
            ),
          ),
          Text(
            value,
            style: AppTextStyles.bodySmall.copyWith(
              fontSize: 10,
              fontWeight: FontWeight.w700,
              color: colorScheme.onSurface,
            ),
          ),
        ],
      ),
    );
  }
}
