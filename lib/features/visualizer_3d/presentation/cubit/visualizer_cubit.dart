import 'dart:math' as math;
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../domain/domain.dart';
import '../../../../core/core.dart';
import '../../../../core/domain/entities/formula.dart';

import 'visualizer_state.dart';

class VisualizerCubit extends Cubit<VisualizerState> {
  VisualizerCubit({required List<Formula> formulas, String? initialType})
    : super(
        VisualizerState(
          formulas: formulas,
          visualizerType: _parseInitialType(formulas, initialType),
        ),
      );

  String get logTag => AppLogTags.visualizerCubit;

  void selectFormula(int index) {
    if (index < 0 || index >= state.formulas.length) return;
    final newType = _typeForFormula(state.formulas[index]);
    emit(
      state.copyWith(
        currentIndex: index,
        visualizerType: newType,
        paramA: _defaultParamA(newType),
        paramB: _defaultParamB(newType),
        paramC: _defaultParamC(newType),
      ),
    );
  }

  void previousFormula() => selectFormula(state.currentIndex - 1);
  void nextFormula() => selectFormula(state.currentIndex + 1);

  void setParamA(double value) => emit(state.copyWith(paramA: value));
  void setParamB(double value) => emit(state.copyWith(paramB: value));
  void setParamC(double value) => emit(state.copyWith(paramC: value));

  void toggleAutoRotate() =>
      emit(state.copyWith(isAutoRotating: !state.isAutoRotating));

  void updateRotation(double deltaX, double deltaY) {
    emit(
      state.copyWith(
        angleX: (state.angleX - deltaY * 0.01).clamp(-math.pi, math.pi),
        angleY: state.angleY + deltaX * 0.01,
        isAutoRotating: false,
      ),
    );
  }

  void tickAutoRotate() {
    if (state.isAutoRotating) {
      emit(state.copyWith(angleY: state.angleY + 0.01));
    }
  }

  static VisualizerType _parseInitialType(
    List<Formula> formulas,
    String? initialType,
  ) {
    if (formulas.isEmpty) return VisualizerType.polyhedron;
    if (initialType != null) {
      for (final t in VisualizerType.values) {
        if (t.name == initialType) return t;
      }
    }
    return _typeForFormula(formulas.first);
  }

  static VisualizerType _typeForFormula(Formula formula) {
    final title = formula.title.toLowerCase();
    final latex = formula.latex.toLowerCase();

    if (title.contains('frustum')) return VisualizerType.frustum;
    if (title.contains('sphere') || title.contains('hemisphere')) {
      return VisualizerType.sphere;
    }
    if (title.contains('cone')) return VisualizerType.cone;
    if (title.contains('cylinder')) return VisualizerType.cylinder;
    if (title.contains('gravity') ||
        title.contains('gravitational') ||
        title.contains('kepler')) {
      return VisualizerType.gravitation;
    }
    if (title.contains('refract') ||
        title.contains('lens') ||
        title.contains('snell')) {
      return VisualizerType.refraction;
    }
    if (title.contains('quadratic') ||
        title.contains('parabola') ||
        latex.contains('x^2')) {
      return VisualizerType.quadratic;
    }
    if (title.contains('dna') ||
        title.contains('cell') ||
        title.contains('heredity')) {
      return VisualizerType.dna;
    }
    return VisualizerType.polyhedron;
  }

  static double _defaultParamA(VisualizerType type) {
    switch (type) {
      case VisualizerType.gravitation:
        return 1.0;
      case VisualizerType.refraction:
        return 0.6;
      default:
        return 1.0;
    }
  }

  static double _defaultParamB(VisualizerType type) {
    switch (type) {
      case VisualizerType.gravitation:
        return 1.2;
      case VisualizerType.refraction:
        return 1.2;
      default:
        return 1.5;
    }
  }

  static double _defaultParamC(VisualizerType type) {
    switch (type) {
      case VisualizerType.gravitation:
        return 0.5;
      case VisualizerType.refraction:
        return 1.5;
      default:
        return 0.8;
    }
  }
}
