import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';
import '../../domain/domain.dart';
import '../../../../core/domain/entities/formula.dart';

import 'comparison_state.dart';

@injectable
class ComparisonCubit extends Cubit<ComparisonState> {
  ComparisonCubit({required FormulaCompareService compareService})
    : _compareService = compareService,
      super(const ComparisonState());

  final FormulaCompareService _compareService;

  void setFormulas(Formula a, Formula b) {
    final comparison = _compareService.compare(a, b);
    emit(
      ComparisonState(
        status: ComparisonStatus.loaded,
        formulaA: a,
        formulaB: b,
        comparison: comparison,
      ),
    );
  }

  void swap() {
    final a = state.formulaA;
    final b = state.formulaB;
    if (a == null || b == null) return;
    final comparison = _compareService.compare(b, a);
    emit(state.copyWith(formulaA: b, formulaB: a, comparison: comparison));
  }

  void clear() {
    emit(const ComparisonState());
  }
}
