import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:lucide_icons/lucide_icons.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/core.dart';

import '../../../visualizer_3d/visualizer_3d.dart';
import '../widgets/visualizer_widgets.dart';
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
      appBar: GlassAppBar(
        title: context.l10n.visualizer3d,
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
                ? context.l10n.autoRotatePause
                : context.l10n.autoRotateStart,
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
                VisualizerFormulaSelector(
                  subjectFormulas: _subjectFormulas,
                  selectedFormulaIndex: _selectedFormulaIndex,
                  onPrevious: _selectedFormulaIndex > 0
                      ? () {
                          setState(() {
                            _selectedFormulaIndex--;
                            _resetParamsForFormula(
                              _subjectFormulas[_selectedFormulaIndex],
                            );
                          });
                        }
                      : null,
                  onNext: _selectedFormulaIndex < _subjectFormulas.length - 1
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
                          color: AppColors.black.withValues(alpha: 0.4),
                          borderRadius: BorderRadius.circular(
                            AppDimensions.radiusXL,
                          ),
                          border: Border.all(
                            color: colorScheme.outline.withValues(alpha: 0.1),
                          ),
                          boxShadow: const [
                            BoxShadow(
                              color: AppColors.black26,
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
                                child: HologramStatIndicator(
                                  label: 'ROTATION Y',
                                  value: '${(_angleY * 180 / math.pi).round() % 360}°',
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
                                child: HologramStatIndicator(
                                  label: 'VISUALIZER MODE',
                                  value: type.name.toUpperCase(),
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
                VisualizerControlsPanel(
                  formula: formula,
                  visualizerType: type,
                  paramA: _paramA,
                  paramB: _paramB,
                  paramC: _paramC,
                  onParamAChanged: (val) => setState(() => _paramA = val),
                  onParamBChanged: (val) => setState(() => _paramB = val),
                  onParamCChanged: (val) => setState(() => _paramC = val),
                ),
              ],
            ),
          );
        },
      ),
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
