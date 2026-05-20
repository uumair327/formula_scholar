import 'package:equatable/equatable.dart';

import '../../../../features/chapters/domain/entities/formula.dart';
import '../../domain/domain.dart';

enum ComparisonStatus { initial, loaded }

class ComparisonState extends Equatable {
  const ComparisonState({
    this.status = ComparisonStatus.initial,
    this.formulaA,
    this.formulaB,
    this.comparison,
  });

  final ComparisonStatus status;
  final Formula? formulaA;
  final Formula? formulaB;
  final FormulaComparison? comparison;

  ComparisonState copyWith({
    ComparisonStatus? status,
    Formula? formulaA,
    Formula? formulaB,
    FormulaComparison? comparison,
  }) {
    return ComparisonState(
      status: status ?? this.status,
      formulaA: formulaA ?? this.formulaA,
      formulaB: formulaB ?? this.formulaB,
      comparison: comparison ?? this.comparison,
    );
  }

  @override
  List<Object?> get props => [status, formulaA, formulaB, comparison];
}
