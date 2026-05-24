import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lucide_icons/lucide_icons.dart';

import '../../../../core/core.dart';
import '../cubit/visualizer_cubit.dart';
import '../cubit/visualizer_state.dart';
import '../widgets/formula_card_selector.dart';
import '../widgets/grid_background_painter.dart';
import '../widgets/parameter_controls.dart';
import '../widgets/three_d_canvas_painter.dart';

class VisualizerPage extends StatefulWidget {
  const VisualizerPage({super.key});

  @override
  State<VisualizerPage> createState() => _VisualizerPageState();
}

class _VisualizerPageState extends State<VisualizerPage>
    with SingleTickerProviderStateMixin {
  late final AnimationController _autoRotateController;

  @override
  void initState() {
    super.initState();
    _autoRotateController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 15),
    )..addListener(() {
        context.read<VisualizerCubit>().tickAutoRotate();
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

    return BlocBuilder<VisualizerCubit, VisualizerState>(
      buildWhen: (p, n) =>
          p.hasFormulas != n.hasFormulas ||
          p.currentIndex != n.currentIndex ||
          p.formulas != n.formulas,
      builder: (context, state) {
        if (!state.hasFormulas) {
          return Scaffold(
            appBar: AppBar(
              title: Text(
                AppStrings.visualizer3d,
                style: AppTextStyles.titleMedium,
              ),
            ),
            body: Center(
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
                      'No formulas to visualize.',
                      style: AppTextStyles.bodyMedium.copyWith(
                        color: colorScheme.onSurfaceVariant,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              ),
            ),
          );
        }

        return Scaffold(
          backgroundColor: colorScheme.surface,
          appBar: AppBar(
            title: Text(
              AppStrings.visualizer3d,
              style: AppTextStyles.titleMedium,
            ),
            centerTitle: true,
            actions: [
              IconButton(
                icon: Icon(
                  state.isAutoRotating
                      ? LucideIcons.pause
                      : LucideIcons.play,
                  color: colorScheme.primary,
                ),
                onPressed: () =>
                    context.read<VisualizerCubit>().toggleAutoRotate(),
              ),
            ],
          ),
          body: Column(
            children: [
              Padding(
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
                          '${state.currentIndex + 1} of ${state.formulas.length}',
                          style: AppTextStyles.bodySmall.copyWith(
                            color: colorScheme.onSurfaceVariant,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: AppDimensions.paddingXS),
                    FormulaCardSelector(
                      formula: state.currentFormula,
                      index: state.currentIndex,
                      total: state.formulas.length,
                      onPrevious: () =>
                          context.read<VisualizerCubit>().previousFormula(),
                      onNext: () =>
                          context.read<VisualizerCubit>().nextFormula(),
                    ),
                  ],
                ),
              ),
              const Expanded(child: _Canvas3D()),
              const Padding(
                padding: EdgeInsets.all(AppDimensions.paddingMD),
                child: _ParameterControlsSection(),
              ),
            ],
          ),
        );
      },
    );
  }
}

class _Canvas3D extends StatelessWidget {
  const _Canvas3D();

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return BlocBuilder<VisualizerCubit, VisualizerState>(
      buildWhen: (p, n) =>
          p.visualizerType != n.visualizerType ||
          p.angleX != n.angleX ||
          p.angleY != n.angleY ||
          p.paramA != n.paramA ||
          p.paramB != n.paramB ||
          p.paramC != n.paramC,
      builder: (context, state) {
        return GestureDetector(
          onPanUpdate: (details) {
            context.read<VisualizerCubit>().updateRotation(
              details.delta.dx,
              details.delta.dy,
            );
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
              child: Stack(
                children: [
                  Positioned.fill(
                    child: CustomPaint(
                      painter: GridBackgroundPainter(colorScheme),
                    ),
                  ),
                  Positioned.fill(
                    child: CustomPaint(
                      painter: ThreeDCanvasPainter(
                        type: state.visualizerType,
                        angleX: state.angleX,
                        angleY: state.angleY,
                        paramA: state.paramA,
                        paramB: state.paramB,
                        paramC: state.paramC,
                        colorScheme: colorScheme,
                      ),
                    ),
                  ),
                  Positioned(
                    top: AppDimensions.paddingMD,
                    left: AppDimensions.paddingMD,
                    child: _HologramStat(
                      label: 'ROTATION Y',
                      value:
                          '${(state.angleY * 180 / math.pi).round() % 360}°',
                    ),
                  ),
                  Positioned(
                    top: AppDimensions.paddingMD,
                    right: AppDimensions.paddingMD,
                    child: _HologramStat(
                      label: 'VISUALIZER MODE',
                      value: state.visualizerType.name.toUpperCase(),
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}

class _ParameterControlsSection extends StatelessWidget {
  const _ParameterControlsSection();

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<VisualizerCubit, VisualizerState>(
      buildWhen: (p, n) =>
          p.visualizerType != n.visualizerType ||
          p.paramA != n.paramA ||
          p.paramB != n.paramB ||
          p.paramC != n.paramC,
      builder: (context, state) {
        return ParameterControls(
          type: state.visualizerType,
          paramA: state.paramA,
          paramB: state.paramB,
          paramC: state.paramC,
          onChangedA: (v) =>
              context.read<VisualizerCubit>().setParamA(v),
          onChangedB: (v) =>
              context.read<VisualizerCubit>().setParamB(v),
          onChangedC: (v) =>
              context.read<VisualizerCubit>().setParamC(v),
        );
      },
    );
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
}
