import 'package:equatable/equatable.dart';
import '../../../../features/chapters/domain/entities/formula.dart';
import '../../domain/domain.dart';

class VisualizerState extends Equatable {
  const VisualizerState({
    required this.formulas,
    this.currentIndex = 0,
    this.visualizerType = VisualizerType.polyhedron,
    this.paramA = 1.0,
    this.paramB = 1.5,
    this.paramC = 0.8,
    this.isAutoRotating = true,
    this.angleX = 0.3,
    this.angleY = 0.5,
  });

  final List<Formula> formulas;
  final int currentIndex;
  final VisualizerType visualizerType;
  final double paramA;
  final double paramB;
  final double paramC;
  final bool isAutoRotating;
  final double angleX;
  final double angleY;

  Formula get currentFormula => formulas[currentIndex];
  bool get hasFormulas => formulas.isNotEmpty;
  bool get isFirst => currentIndex == 0;
  bool get isLast => currentIndex >= formulas.length - 1;

  VisualizerState copyWith({
    List<Formula>? formulas,
    int? currentIndex,
    VisualizerType? visualizerType,
    double? paramA,
    double? paramB,
    double? paramC,
    bool? isAutoRotating,
    double? angleX,
    double? angleY,
  }) {
    return VisualizerState(
      formulas: formulas ?? this.formulas,
      currentIndex: currentIndex ?? this.currentIndex,
      visualizerType: visualizerType ?? this.visualizerType,
      paramA: paramA ?? this.paramA,
      paramB: paramB ?? this.paramB,
      paramC: paramC ?? this.paramC,
      isAutoRotating: isAutoRotating ?? this.isAutoRotating,
      angleX: angleX ?? this.angleX,
      angleY: angleY ?? this.angleY,
    );
  }

  @override
  List<Object?> get props => [
    formulas,
    currentIndex,
    visualizerType,
    paramA,
    paramB,
    paramC,
    isAutoRotating,
    angleX,
    angleY,
  ];
}
