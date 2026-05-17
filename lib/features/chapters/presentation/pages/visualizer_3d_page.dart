import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:lucide_icons/lucide_icons.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/core.dart';
import '../../../../shared/shared.dart';
import '../cubit/formulas_cubit.dart';
import '../cubit/formulas_state.dart';
import '../../domain/entities/formula.dart';

/// Immersive 3D-themed premium math/science formula visualizer.
/// Incorporates full Clean Architecture design, rich aesthetics,
/// dark-mode premium styling, and interactive 3D perspective physics.
class Visualizer3DPage extends StatefulWidget {
  const Visualizer3DPage({super.key});

  @override
  State<Visualizer3DPage> createState() => _Visualizer3DPageState();
}

class _Visualizer3DPageState extends State<Visualizer3DPage>
    with SingleTickerProviderStateMixin {
  late final AnimationController _autoRotateController;
  double _angleX = 0.3;
  double _angleY = 0.5;

  // Interactive controls
  double _paramA = 1.0; // Radius / Mass / Graph scaling
  double _paramB = 1.5; // Height / Distance
  double _paramC = 0.8; // Speed / Angle / Refraction index

  int _selectedFormulaIndex = 0;
  List<Formula> _subjectFormulas = [];
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

    return Scaffold(
      backgroundColor: colorScheme.background,
      appBar: AppBar(
        title: Text(AppStrings.visualizer3d, style: AppTextStyles.titleMedium),
        centerTitle: true,
        actions: [
          IconButton(
            icon: Icon(
              _isAutoRotating ? LucideIcons.pause : LucideIcons.play,
              color: colorScheme.primary,
            ),
            onPressed: () {
              setState(() {
                _isAutoRotating = !_isAutoRotating;
              });
            },
          ),
        ],
      ),
      body: BlocBuilder<FormulasCubit, FormulasState>(
        builder: (context, state) {
          if (state.status == FormulasStatus.loading) {
            return const Center(child: CircularProgressIndicator());
          }

          _subjectFormulas = state.formulas;
          if (_subjectFormulas.isEmpty) {
            return Center(
              child: Padding(
                padding: const EdgeInsets.all(AppDimensions.paddingXL),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      LucideIcons.box,
                      size: 64,
                      color: colorScheme.outline.withOpacity(0.5),
                    ),
                    const SizedBox(height: AppDimensions.paddingLG),
                    Text(
                      'No geometric or physics formulas loaded to visualize for this subject.',
                      style: AppTextStyles.bodyMedium.copyWith(
                        color: colorScheme.onSurfaceVariant,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              ),
            );
          }

          final formula = _subjectFormulas[_selectedFormulaIndex];
          final type = _getVisualizerType(formula);

          return Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  colorScheme.surface,
                  colorScheme.background,
                ],
              ),
            ),
            child: Column(
              children: [
                // Top Formula Card Selector
                _buildFormulaSelector(context, colorScheme),

                // Beautiful interactive canvas
                Expanded(
                  child: GestureDetector(
                    onPanUpdate: (details) {
                      if (_isAutoRotating) {
                        setState(() => _isAutoRotating = false);
                      }
                      setState(() {
                        _angleY += details.delta.dx * 0.01;
                        _angleX -= details.delta.dy * 0.01;
                      });
                    },
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: AppDimensions.paddingMD,
                      ),
                      child: Container(
                        decoration: BoxDecoration(
                          color: Colors.black.withOpacity(0.4),
                          borderRadius: BorderRadius.circular(
                            AppDimensions.radiusXL,
                          ),
                          border: Border.all(
                            color: colorScheme.outline.withOpacity(0.1),
                          ),
                          boxShadow: const [
                            BoxShadow(
                              color: Colors.black26,
                              blurRadius: 15,
                              offset: Offset(0, 5),
                            )
                          ],
                        ),
                        clipBehavior: Clip.antiAlias,
                        child: Stack(
                          children: [
                            // Starfield or Grid lines background
                            Positioned.fill(
                              child: CustomPaint(
                                painter: _GridBackgroundPainter(colorScheme),
                              ),
                            ),
                            // Interactive 3D render canvas
                            Positioned.fill(
                              child: CustomPaint(
                                painter: _ThreeDCanvasPainter(
                                  type: type,
                                  angleX: _angleX,
                                  angleY: _angleY,
                                  paramA: _paramA,
                                  paramB: _paramB,
                                  paramC: _paramC,
                                  colorScheme: colorScheme,
                                ),
                              ),
                            ),
                            // Hologram status indicators
                            Positioned(
                              top: AppDimensions.paddingMD,
                              left: AppDimensions.paddingMD,
                              child: _buildHologramStat('ROTATION Y',
                                  '${(_angleY * 180 / math.pi).round() % 360}°'),
                            ),
                            Positioned(
                              top: AppDimensions.paddingMD,
                              right: AppDimensions.paddingMD,
                              child: _buildHologramStat(
                                  'VISUALIZER MODE', type.name.toUpperCase()),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),

                // Controls & Interaction panel
                _buildControlsPanel(context, formula, colorScheme),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildHologramStat(String label, String value) {
    final colorScheme = Theme.of(context).colorScheme;
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: AppDimensions.paddingSM,
        vertical: AppDimensions.paddingXS,
      ),
      decoration: BoxDecoration(
        color: colorScheme.surface.withOpacity(0.6),
        borderRadius: BorderRadius.circular(AppDimensions.radiusSM),
        border: Border.all(color: colorScheme.primary.withOpacity(0.2)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: AppTextStyles.bodySmall.copyWith(
              fontSize: 8,
              letterSpacing: 1.5,
              fontWeight: FontWeight.bold,
              color: colorScheme.primary.withOpacity(0.7),
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

  Widget _buildFormulaSelector(BuildContext context, ColorScheme colorScheme) {
    return Padding(
      padding: const EdgeInsets.all(AppDimensions.paddingMD),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'STUDY REFERENCE',
                style: AppTextStyles.bodySmall.copyWith(
                  fontWeight: FontWeight.w700,
                  color: colorScheme.primary,
                ),
              ),
              Text(
                '${_selectedFormulaIndex + 1} of ${_subjectFormulas.length}',
                style: AppTextStyles.bodySmall.copyWith(
                  color: colorScheme.onSurfaceVariant,
                ),
              ),
            ],
          ),
          const SizedBox(height: AppDimensions.paddingXS),
          AppCard(
            color: colorScheme.surfaceVariant.withOpacity(0.8),
            child: Row(
              children: [
                IconButton(
                  icon: const Icon(LucideIcons.chevronLeft),
                  onPressed: _selectedFormulaIndex > 0
                      ? () {
                          setState(() {
                            _selectedFormulaIndex--;
                            _resetParamsForFormula(
                                _subjectFormulas[_selectedFormulaIndex]);
                          });
                        }
                      : null,
                ),
                Expanded(
                  child: Column(
                    children: [
                      Text(
                        _subjectFormulas[_selectedFormulaIndex].title,
                        style: AppTextStyles.bodyMedium.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                        textAlign: TextAlign.center,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(height: AppDimensions.paddingXS),
                      Text(
                        _subjectFormulas[_selectedFormulaIndex].latex,
                        style: AppTextStyles.bodySmall.copyWith(
                          fontFamily: 'monospace',
                          color: colorScheme.primary,
                          fontWeight: FontWeight.bold,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ],
                  ),
                ),
                IconButton(
                  icon: const Icon(LucideIcons.chevronRight),
                  onPressed: _selectedFormulaIndex < _subjectFormulas.length - 1
                      ? () {
                          setState(() {
                            _selectedFormulaIndex++;
                            _resetParamsForFormula(
                                _subjectFormulas[_selectedFormulaIndex]);
                          });
                        }
                      : null,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildControlsPanel(
      BuildContext context, Formula formula, ColorScheme colorScheme) {
    final type = _getVisualizerType(formula);
    String labelA = 'Radius';
    String labelB = 'Height';
    String labelC = 'Rotation';

    if (type == _VisualizerType.gravitation) {
      labelA = 'Mass Factor';
      labelB = 'Orbit Distance';
      labelC = 'Orbital Speed';
    } else if (type == _VisualizerType.refraction) {
      labelA = 'Beam Angle';
      labelB = 'Prism Size';
      labelC = 'Refraction Index';
    } else if (type == _VisualizerType.quadratic) {
      labelA = 'Variable A';
      labelB = 'Variable B';
      labelC = 'Variable C';
    }

    return Padding(
      padding: const EdgeInsets.all(AppDimensions.paddingMD),
      child: AppCard(
        child: Column(
          children: [
            _buildSliderRow(labelA, _paramA, 0.2, 2.0, (val) {
              setState(() => _paramA = val);
            }, colorScheme),
            _buildSliderRow(labelB, _paramB, 0.5, 2.5, (val) {
              setState(() => _paramB = val);
            }, colorScheme),
            _buildSliderRow(labelC, _paramC, 0.1, 2.0, (val) {
              setState(() => _paramC = val);
            }, colorScheme),
          ],
        ),
      ),
    );
  }

  Widget _buildSliderRow(String label, double value, double min, double max,
      ValueChanged<double> onChanged, ColorScheme colorScheme) {
    return Row(
      children: [
        SizedBox(
          width: 90,
          child: Text(
            label,
            style: AppTextStyles.bodySmall.copyWith(
              fontWeight: FontWeight.bold,
              color: colorScheme.onSurfaceVariant,
            ),
          ),
        ),
        Expanded(
          child: SliderTheme(
            data: SliderThemeData(
              activeTrackColor: colorScheme.primary,
              inactiveTrackColor: colorScheme.outline.withOpacity(0.2),
              thumbColor: colorScheme.primary,
              overlayColor: colorScheme.primary.withOpacity(0.1),
            ),
            child: Slider(
              value: value,
              min: min,
              max: max,
              onChanged: onChanged,
            ),
          ),
        ),
        SizedBox(
          width: 40,
          child: Text(
            value.toStringAsFixed(2),
            style: AppTextStyles.bodySmall.copyWith(
              fontWeight: FontWeight.bold,
              fontFamily: 'monospace',
            ),
            textAlign: TextAlign.end,
          ),
        ),
      ],
    );
  }

  _VisualizerType _getVisualizerType(Formula formula) {
    final title = formula.title.toLowerCase();
    final latex = formula.latex.toLowerCase();

    if (title.contains('sphere') ||
        latex.contains('sphere') ||
        title.contains('hemisphere')) {
      return _VisualizerType.sphere;
    }
    if (title.contains('cone') || latex.contains('cone')) {
      return _VisualizerType.cone;
    }
    if (title.contains('cylinder') || latex.contains('cylinder')) {
      return _VisualizerType.cylinder;
    }
    if (title.contains('gravity') ||
        title.contains('gravitational') ||
        title.contains('kepler') ||
        latex.contains('g =') ||
        latex.contains('f = g')) {
      return _VisualizerType.gravitation;
    }
    if (title.contains('refract') ||
        title.contains('lens') ||
        title.contains('snell') ||
        latex.contains('\\sin')) {
      return _VisualizerType.refraction;
    }
    if (title.contains('quadratic') ||
        title.contains('parabola') ||
        title.contains('linear') ||
        latex.contains('x^2')) {
      return _VisualizerType.quadratic;
    }
    if (title.contains('dna') || title.contains('cell') || title.contains('heredity')) {
      return _VisualizerType.dna;
    }

    // Default to a stunning interactive polyhedron / pyramid!
    return _VisualizerType.polyhedron;
  }

  void _resetParamsForFormula(Formula formula) {
    final type = _getVisualizerType(formula);
    if (type == _VisualizerType.gravitation) {
      _paramA = 1.0;
      _paramB = 1.2;
      _paramC = 0.5;
    } else if (type == _VisualizerType.refraction) {
      _paramA = 0.6;
      _paramB = 1.2;
      _paramC = 1.5;
    } else {
      _paramA = 1.0;
      _paramB = 1.5;
      _paramC = 0.8;
    }
  }
}

enum _VisualizerType {
  sphere,
  cone,
  cylinder,
  gravitation,
  refraction,
  quadratic,
  dna,
  polyhedron
}

/// Starfield and cyber-grid lines background for 3D visualizer.
class _GridBackgroundPainter extends CustomPainter {
  const _GridBackgroundPainter(this.colorScheme);
  final ColorScheme colorScheme;

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = colorScheme.outline.withOpacity(0.04)
      ..strokeWidth = 1.0;

    final cellWidth = size.width / 16;
    final cellHeight = size.height / 16;

    for (int i = 0; i <= 16; i++) {
      final x = i * cellWidth;
      canvas.drawLine(Offset(x, 0), Offset(x, size.height), paint);
    }
    for (int i = 0; i <= 16; i++) {
      final y = i * cellHeight;
      canvas.drawLine(Offset(0, y), Offset(size.width, y), paint);
    }

    // Neon center crosshairs
    final centerPaint = Paint()
      ..color = colorScheme.primary.withOpacity(0.1)
      ..strokeWidth = 1.5;
    canvas.drawLine(Offset(size.width / 2, 0), Offset(size.width / 2, size.height), centerPaint);
    canvas.drawLine(Offset(0, size.height / 2), Offset(size.width, size.height / 2), centerPaint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

class _ThreeDCanvasPainter extends CustomPainter {
  _ThreeDCanvasPainter({
    required this.type,
    required this.angleX,
    required this.angleY,
    required this.paramA,
    required this.paramB,
    required this.paramC,
    required this.colorScheme,
  });

  final _VisualizerType type;
  final double angleX;
  final double angleY;
  final double paramA; // Radius / Mass scaling
  final double paramB; // Height / Distance
  final double paramC; // Special modifiers (Speed / Refraction index)
  final ColorScheme colorScheme;

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final radiusBase = size.width * 0.18;

    switch (type) {
      case _VisualizerType.sphere:
        _draw3DSphere(canvas, center, radiusBase);
      case _VisualizerType.cone:
        _draw3DCone(canvas, center, radiusBase);
      case _VisualizerType.cylinder:
        _draw3DCylinder(canvas, center, radiusBase);
      case _VisualizerType.gravitation:
        _draw3DGravitation(canvas, center, radiusBase);
      case _VisualizerType.refraction:
        _draw3DRefraction(canvas, center, radiusBase);
      case _VisualizerType.quadratic:
        _draw3DQuadratic(canvas, center, radiusBase);
      case _VisualizerType.dna:
        _draw3DDNA(canvas, center, radiusBase);
      case _VisualizerType.polyhedron:
        _draw3DPolyhedron(canvas, center, radiusBase);
    }
  }

  // ──────────────────────── 3D Math Projection Helper ────────────────────────

  _Point3D _project(_Point3D pt, double d) {
    // 1. Rotate Y
    final x1 = pt.x * math.cos(angleY) - pt.z * math.sin(angleY);
    final z1 = pt.x * math.sin(angleY) + pt.z * math.cos(angleY);

    // 2. Rotate X
    final y1 = pt.y * math.cos(angleX) - z1 * math.sin(angleX);
    final z2 = pt.y * math.sin(angleX) + z1 * math.cos(angleX);

    // 3. Perspective project
    const cameraDist = 400.0;
    final scale = cameraDist / (cameraDist + z2);

    return _Point3D(x1 * scale, y1 * scale, z2);
  }

  // ──────────────────────── Sphere Visualizer ────────────────────────

  void _draw3DSphere(Canvas canvas, Offset center, double radiusBase) {
    final radius = radiusBase * paramA;
    final strokePaint = Paint()
      ..color = colorScheme.primary.withOpacity(0.4)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.0;

    final glowPaint = Paint()
      ..color = colorScheme.primary.withOpacity(0.05)
      ..style = PaintingStyle.fill;

    // Outer silhouette sphere glow
    canvas.drawCircle(center, radius, glowPaint);

    // Draw longitudinal and latitudinal wireframe rings
    final ringCount = 8;
    for (int i = 0; i < ringCount; i++) {
      final double lat = (i / ringCount) * math.pi;
      final path = Path();
      bool first = true;

      for (int j = 0; j <= 36; j++) {
        final double lon = (j / 36) * 2 * math.pi;
        final x = radius * math.sin(lat) * math.cos(lon);
        final y = radius * math.cos(lat);
        final z = radius * math.sin(lat) * math.sin(lon);

        final proj = _project(_Point3D(x, y, z), radius);
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

  // ──────────────────────── Cylinder Visualizer ────────────────────────

  void _draw3DCylinder(Canvas canvas, Offset center, double radiusBase) {
    final radius = radiusBase * paramA;
    final height = radiusBase * 1.5 * paramB;
    final strokePaint = Paint()
      ..color = AppColors.orange500.withOpacity(0.5)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.5;

    // Draw top ring, bottom ring and joining sides
    final topRing = Path();
    final bottomRing = Path();
    bool first = true;

    final topPoints = <Offset>[];
    final bottomPoints = <Offset>[];

    for (int i = 0; i <= 36; i++) {
      final double angle = (i / 36) * 2 * math.pi;
      final x = radius * math.cos(angle);
      final z = radius * math.sin(angle);

      final ptTop = _project(_Point3D(x, -height / 2, z), radius);
      final ptBottom = _project(_Point3D(x, height / 2, z), radius);

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

    // Draw lines joining top and bottom
    for (int i = 0; i < 36; i += 6) {
      canvas.drawLine(topPoints[i], bottomPoints[i], strokePaint);
    }
  }

  // ──────────────────────── Cone Visualizer ────────────────────────

  void _draw3DCone(Canvas canvas, Offset center, double radiusBase) {
    final radius = radiusBase * paramA;
    final height = radiusBase * 1.5 * paramB;
    final strokePaint = Paint()
      ..color = colorScheme.secondary.withOpacity(0.5)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.5;

    final basePoints = <Offset>[];
    final baseRing = Path();
    bool first = true;

    for (int i = 0; i <= 36; i++) {
      final double angle = (i / 36) * 2 * math.pi;
      final x = radius * math.cos(angle);
      final z = radius * math.sin(angle);

      final ptBase = _project(_Point3D(x, height / 2, z), radius);
      basePoints.add(Offset(center.dx + ptBase.x, center.dy + ptBase.y));

      if (first) {
        baseRing.moveTo(center.dx + ptBase.x, center.dy + ptBase.y);
        first = false;
      } else {
        baseRing.lineTo(center.dx + ptBase.x, center.dy + ptBase.y);
      }
    }

    // Top tip vertex
    final ptTip = _project(_Point3D(0, -height / 2, 0), radius);
    final tipOffset = Offset(center.dx + ptTip.x, center.dy + ptTip.y);

    canvas.drawPath(baseRing, strokePaint);

    // Join tip to base vertices
    for (int i = 0; i < 36; i += 6) {
      canvas.drawLine(tipOffset, basePoints[i], strokePaint);
    }
  }

  // ──────────────────────── Gravitation Visualizer ────────────────────────

  void _draw3DGravitation(Canvas canvas, Offset center, double radiusBase) {
    final sunMass = radiusBase * 0.4 * paramA;
    final orbitRadius = radiusBase * 1.8 * paramB;

    // Draw central Sun
    final sunPaint = Paint()
      ..color = AppColors.orange500
      ..style = PaintingStyle.fill;
    final sunGlow = Paint()
      ..color = AppColors.orange500.withOpacity(0.2)
      ..style = PaintingStyle.fill;

    canvas.drawCircle(center, sunMass, sunPaint);
    canvas.drawCircle(center, sunMass * 1.6, sunGlow);

    // Draw 3D Orbit path
    final orbitPaint = Paint()
      ..color = colorScheme.outline.withOpacity(0.2)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.0;

    final orbitPath = Path();
    bool first = true;
    final orbitPoints = <Offset>[];

    for (int i = 0; i <= 72; i++) {
      final double angle = (i / 72) * 2 * math.pi;
      final x = orbitRadius * math.cos(angle);
      final z = orbitRadius * math.sin(angle);

      final pt = _project(_Point3D(x, 0, z), orbitRadius);
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

    // Dynamic orbiting planet
    final double time = DateTime.now().millisecondsSinceEpoch * 0.003 * paramC;
    final planetIndex = (time * 10).round() % orbitPoints.length;
    final planetPos = orbitPoints[planetIndex];

    final planetPaint = Paint()
      ..color = colorScheme.primary
      ..style = PaintingStyle.fill;
    canvas.drawCircle(planetPos, 12.0, planetPaint);

    // Draw gravitational vector pull line
    final vectorPaint = Paint()
      ..color = colorScheme.primary.withOpacity(0.4)
      ..strokeWidth = 2.0;
    canvas.drawLine(center, planetPos, vectorPaint);
  }

  // ──────────────────────── Refraction Visualizer ────────────────────────

  void _draw3DRefraction(Canvas canvas, Offset center, double radiusBase) {
    // Renders a beautiful 3D glass prism refracting a neon laser beam
    final prismSize = radiusBase * 1.4 * paramB;
    final strokePaint = Paint()
      ..color = colorScheme.primary.withOpacity(0.6)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2.0;

    // Draw a rotating 3D prism triangular base
    final pt1 = _project(_Point3D(0, -prismSize / 2, 0), prismSize);
    final pt2 = _project(_Point3D(-prismSize / 2, prismSize / 2, prismSize / 2), prismSize);
    final pt3 = _project(_Point3D(prismSize / 2, prismSize / 2, prismSize / 2), prismSize);
    final pt4 = _project(_Point3D(0, prismSize / 2, -prismSize / 2), prismSize);

    final o1 = Offset(center.dx + pt1.x, center.dy + pt1.y);
    final o2 = Offset(center.dx + pt2.x, center.dy + pt2.y);
    final o3 = Offset(center.dx + pt3.x, center.dy + pt3.y);
    final o4 = Offset(center.dx + pt4.x, center.dy + pt4.y);

    // Glass walls
    canvas.drawLine(o1, o2, strokePaint);
    canvas.drawLine(o1, o3, strokePaint);
    canvas.drawLine(o1, o4, strokePaint);
    canvas.drawLine(o2, o3, strokePaint);
    canvas.drawLine(o3, o4, strokePaint);
    canvas.drawLine(o4, o2, strokePaint);

    // Light source (fixed laser path entering prism)
    final inputStart = Offset(center.dx - radiusBase * 2, center.dy + radiusBase * 0.5);
    final inputEnd = Offset(center.dx - prismSize * 0.2, center.dy + prismSize * 0.1);
    
    // Snells Refraction index calculation
    final n = paramC; // Refraction index
    final double deviationAngle = (n - 1) * 0.8;
    final refractEnd = Offset(center.dx + prismSize * 0.2, center.dy + prismSize * 0.05);
    
    final dx = refractEnd.dx - inputEnd.dx;
    final dy = refractEnd.dy - inputEnd.dy;
    final exitStart = refractEnd;
    final exitEnd = Offset(
      exitStart.dx + dx * 2.0 * math.cos(deviationAngle),
      exitStart.dy + dy * 2.0 * math.sin(deviationAngle),
    );

    // Entering white laser beam
    final laserIn = Paint()..color = Colors.white..strokeWidth = 3.0;
    canvas.drawLine(inputStart, inputEnd, laserIn);

    // Internal refracted beam
    final laserRefract = Paint()..color = Colors.cyanAccent..strokeWidth = 2.0;
    canvas.drawLine(inputEnd, refractEnd, laserRefract);

    // Exiting rainbow spectrum beams
    for (int i = 0; i < 7; i++) {
      final double spectrumShift = i * 2.5;
      final spectrumPaint = Paint()
        ..color = Colors.primaries[i % Colors.primaries.length]
        ..strokeWidth = 2.0;
      canvas.drawLine(
        exitStart,
        Offset(exitEnd.dx, exitEnd.dy + spectrumShift - 7.5),
        spectrumPaint,
      );
    }
  }

  // ──────────────────────── Quadratic Equation Graph Visualizer ────────────────────────

  void _draw3DQuadratic(Canvas canvas, Offset center, double radiusBase) {
    // Paraboloid surface in 3D coordinate space
    final double aVal = paramA * 0.005;
    final double bVal = paramB * 0.1;
    final double cVal = paramC * 10;

    final paint = Paint()
      ..color = colorScheme.primary.withOpacity(0.3)
      ..strokeWidth = 1.0;

    final gridPoints = <List<_Point3D>>[];
    final steps = 10;
    final gridExtent = radiusBase * 1.5;

    for (int i = -steps; i <= steps; i++) {
      final double x = (i / steps) * gridExtent;
      final List<_Point3D> row = [];
      for (int j = -steps; j <= steps; j++) {
        final double z = (j / steps) * gridExtent;
        // y = a * x^2 + b * x * z + c
        final double y = aVal * (x * x) + bVal * (x * z) - cVal;
        row.add(_Point3D(x, y, z));
      }
      gridPoints.add(row);
    }

    // Render mesh wireframe lines
    for (int i = 0; i < gridPoints.length; i++) {
      for (int j = 0; j < gridPoints[i].length; j++) {
        final projCurrent = _project(gridPoints[i][j], radiusBase);
        final currentOffset = Offset(center.dx + projCurrent.x, center.dy + projCurrent.y);

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

  // ──────────────────────── DNA Helix Visualizer ────────────────────────

  void _draw3DDNA(Canvas canvas, Offset center, double radiusBase) {
    final helixRadius = radiusBase * 0.7 * paramA;
    final helixLength = radiusBase * 1.8 * paramB;
    final rPaint = Paint()..color = const Color(0xFF00FFFF)..strokeWidth = 3.0;
    final gPaint = Paint()..color = const Color(0xFFFF00FF)..strokeWidth = 3.0;
    final strandPaint = Paint()..color = colorScheme.primary.withOpacity(0.4)..strokeWidth = 1.5;

    final steps = 24;
    final double freq = 2.5 * paramC;

    for (int i = 0; i < steps; i++) {
      final double ratio = i / steps;
      final double angle = ratio * 2 * math.pi * freq;
      final double y = -helixLength / 2 + ratio * helixLength;

      // First strand point
      final x1 = helixRadius * math.cos(angle);
      final z1 = helixRadius * math.sin(angle);
      final pt1 = _project(_Point3D(x1, y, z1), radiusBase);
      final o1 = Offset(center.dx + pt1.x, center.dy + pt1.y);

      // Complementary strand point
      final x2 = helixRadius * math.cos(angle + math.pi);
      final z2 = helixRadius * math.sin(angle + math.pi);
      final pt2 = _project(_Point3D(x2, y, z2), radiusBase);
      final o2 = Offset(center.dx + pt2.x, center.dy + pt2.y);

      // Helix Backbone strands
      canvas.drawCircle(o1, 5.0, rPaint);
      canvas.drawCircle(o2, 5.0, gPaint);

      // Base pair bridge (joining bars)
      if (i > 0) {
        canvas.drawLine(o1, o2, strandPaint);
      }
    }
  }

  // ──────────────────────── Polyhedron (Pyramid) Visualizer ────────────────────────

  void _draw3DPolyhedron(Canvas canvas, Offset center, double radiusBase) {
    final size = radiusBase * 1.3 * paramA;
    final height = radiusBase * 1.5 * paramB;
    final strokePaint = Paint()
      ..color = colorScheme.primary.withOpacity(0.7)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.5;

    // Define 3D points of a square pyramid
    final vertices = <_Point3D>[
      _Point3D(0, -height / 2, 0), // Apex (Tip)
      _Point3D(-size / 2, height / 2, -size / 2),
      _Point3D(size / 2, height / 2, -size / 2),
      _Point3D(size / 2, height / 2, size / 2),
      _Point3D(-size / 2, height / 2, size / 2),
    ];

    final projected = vertices.map((v) => _project(v, radiusBase)).toList();
    final offsets = projected.map((p) => Offset(center.dx + p.x, center.dy + p.y)).toList();

    // Draw faces
    // Sides
    canvas.drawLine(offsets[0], offsets[1], strokePaint);
    canvas.drawLine(offsets[0], offsets[2], strokePaint);
    canvas.drawLine(offsets[0], offsets[3], strokePaint);
    canvas.drawLine(offsets[0], offsets[4], strokePaint);

    // Base
    canvas.drawLine(offsets[1], offsets[2], strokePaint);
    canvas.drawLine(offsets[2], offsets[3], strokePaint);
    canvas.drawLine(offsets[3], offsets[4], strokePaint);
    canvas.drawLine(offsets[4], offsets[1], strokePaint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}

class _Point3D {
  _Point3D(this.x, this.y, this.z);
  final double x;
  final double y;
  final double z;
}
