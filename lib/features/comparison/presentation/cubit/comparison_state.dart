import 'package:equatable/equatable.dart';

import '../../../../features/chapters/domain/entities/formula.dart';

enum ComparisonStatus { initial, loaded }

class ComparisonState extends Equatable {
  const ComparisonState({
    this.status = ComparisonStatus.initial,
    this.formulaA,
    this.formulaB,
  });

  final ComparisonStatus status;
  final Formula? formulaA;
  final Formula? formulaB;

  ComparisonState copyWith({
    ComparisonStatus? status,
    Formula? formulaA,
    Formula? formulaB,
  }) {
    return ComparisonState(
      status: status ?? this.status,
      formulaA: formulaA ?? this.formulaA,
      formulaB: formulaB ?? this.formulaB,
    );
  }

  @override
  List<Object?> get props => [status, formulaA, formulaB];
}
