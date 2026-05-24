import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:lucide_icons/lucide_icons.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/core.dart';
import '../../../../shared/shared.dart';
import '../../../visualizer_3d/visualizer_3d.dart';
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
    _autoRotateController =
        AnimationController(vsync: this, duration: const Duration(seconds: 15))
          ..addListener(() {
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
      backgroundColor: colorScheme.surface,
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
            tooltip: _isAutoRotating
                ? 'Pause auto-rotation'
                : 'Start auto-rotation',
          ),
        ],
      ),
      body: BlocBuilder<FormulasCubit, FormulasState>(
        buildWhen: (p, n) => p.formulas != n.formulas || p.status != n.status,
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
                      color: colorScheme.outline.withValues(alpha: 0.5),
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
                colors: [colorScheme.surface, colorScheme.surface],
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
                          color: Colors.black.withValues(alpha: 0.4),
                          borderRadius: BorderRadius.circular(
                            AppDimensions.radiusXL,
                          ),
                          border: Border.all(
                            color: colorScheme.outline.withValues(alpha: 0.1),
                          ),
                          boxShadow: const [
                            BoxShadow(
                              color: Colors.black26,
                              blurRadius: 15,
                              offset: Offset(0, 5),
                            ),
                          ],
                        ),
                        clipBehavior: Clip.antiAlias,
                        child: RepaintBoundary(
                          child: Stack(
                            children: [
                              // Starfield or Grid lines background
                              Positioned.fill(
                                child: CustomPaint(
                                  painter: GridBackgroundPainter(colorScheme),
                                ),
                              ),
                              // Interactive 3D render canvas
                              Positioned.fill(
                                child: CustomPaint(
                                  painter: ThreeDCanvasPainter(
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
                                left:
                                    Directionality.of(context) ==
                                        TextDirection.ltr
                                    ? AppDimensions.paddingMD
                                    : null,
                                right:
                                    Directionality.of(context) ==
                                        TextDirection.rtl
                                    ? AppDimensions.paddingMD
                                    : null,
                                child: _buildHologramStat(
                                  'ROTATION Y',
                                  '${(_angleY * 180 / math.pi).round() % 360}°',
                                ),
                              ),
                              Positioned(
                                top: AppDimensions.paddingMD,
                                right:
                                    Directionality.of(context) ==
                                        TextDirection.ltr
                                    ? AppDimensions.paddingMD
                                    : null,
                                left:
                                    Directionality.of(context) ==
                                        TextDirection.rtl
                                    ? AppDimensions.paddingMD
                                    : null,
                                child: _buildHologramStat(
                                  'VISUALIZER MODE',
                                  type.name.toUpperCase(),
                                ),
                              ),
                            ],
                          ),
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
        color: colorScheme.surface.withValues(alpha: 0.6),
        borderRadius: BorderRadius.circular(AppDimensions.radiusSM),
        border: Border.all(color: colorScheme.primary.withValues(alpha: 0.2)),
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
            color: colorScheme.surfaceContainerHighest.withValues(alpha: 0.8),
            child: Row(
              children: [
                IconButton(
                  icon: Icon(
                    Directionality.of(context) == TextDirection.rtl
                        ? LucideIcons.chevronRight
                        : LucideIcons.chevronLeft,
                  ),
                  tooltip: AppStrings.previousFormula,
                  onPressed: _selectedFormulaIndex > 0
                      ? () {
                          setState(() {
                            _selectedFormulaIndex--;
                            _resetParamsForFormula(
                              _subjectFormulas[_selectedFormulaIndex],
                            );
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
                  icon: Icon(
                    Directionality.of(context) == TextDirection.rtl
                        ? LucideIcons.chevronLeft
                        : LucideIcons.chevronRight,
                  ),
                  tooltip: AppStrings.nextFormula,
                  onPressed: _selectedFormulaIndex < _subjectFormulas.length - 1
                      ? () {
                          setState(() {
                            _selectedFormulaIndex++;
                            _resetParamsForFormula(
                              _subjectFormulas[_selectedFormulaIndex],
                            );
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
    BuildContext context,
    Formula formula,
    ColorScheme colorScheme,
  ) {
    final type = _getVisualizerType(formula);
    String labelA = 'Radius';
    String labelB = 'Height';
    String labelC = 'Rotation';

    if (type == VisualizerType.frustum) {
      labelA = 'Bottom Radius';
      labelB = 'Top Radius';
      labelC = 'Height';
    } else if (type == VisualizerType.gravitation) {
      labelA = 'Mass Factor';
      labelB = 'Orbit Distance';
      labelC = 'Orbital Speed';
    } else if (type == VisualizerType.refraction) {
      labelA = 'Beam Angle';
      labelB = 'Prism Size';
      labelC = 'Refraction Index';
    } else if (type == VisualizerType.quadratic) {
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

  Widget _buildSliderRow(
    String label,
    double value,
    double min,
    double max,
    ValueChanged<double> onChanged,
    ColorScheme colorScheme,
  ) {
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
              inactiveTrackColor: colorScheme.outline.withValues(alpha: 0.2),
              thumbColor: colorScheme.primary,
              overlayColor: colorScheme.primary.withValues(alpha: 0.1),
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

  VisualizerType _getVisualizerType(Formula formula) {
    final title = formula.title.toLowerCase();
    final latex = formula.latex.toLowerCase();

    if (title.contains('frustum')) {
      return VisualizerType.frustum;
    }
    if (title.contains('sphere') ||
        latex.contains('sphere') ||
        title.contains('hemisphere')) {
      return VisualizerType.sphere;
    }
    if (title.contains('cone') || latex.contains('cone')) {
      return VisualizerType.cone;
    }
    if (title.contains('cylinder') || latex.contains('cylinder')) {
      return VisualizerType.cylinder;
    }
    if (title.contains('gravity') ||
        title.contains('gravitational') ||
        title.contains('kepler') ||
        latex.contains('g =') ||
        latex.contains('f = g')) {
      return VisualizerType.gravitation;
    }
    if (title.contains('refract') ||
        title.contains('lens') ||
        title.contains('snell') ||
        latex.contains('\\sin')) {
      return VisualizerType.refraction;
    }
    if (title.contains('quadratic') ||
        title.contains('parabola') ||
        title.contains('linear') ||
        latex.contains('x^2')) {
      return VisualizerType.quadratic;
    }
    if (title.contains('dna') ||
        title.contains('cell') ||
        title.contains('heredity')) {
      return VisualizerType.dna;
    }

    // Default to a stunning interactive polyhedron / pyramid!
    return VisualizerType.polyhedron;
  }

  void _resetParamsForFormula(Formula formula) {
    final type = _getVisualizerType(formula);
    if (type == VisualizerType.gravitation) {
      _paramA = 1.0;
      _paramB = 1.2;
      _paramC = 0.5;
    } else if (type == VisualizerType.refraction) {
      _paramA = 0.6;
      _paramB = 1.2;
      _paramC = 1.5;
    } else if (type == VisualizerType.frustum) {
      _paramA = 1.0;
      _paramB = 1.0;
      _paramC = 1.0;
    } else {
      _paramA = 1.0;
      _paramB = 1.5;
      _paramC = 0.8;
    }
  }
}
