import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';

import '../../../chapters/domain/entities/formula.dart';
import 'comparison_state.dart';

@injectable
class ComparisonCubit extends Cubit<ComparisonState> {
  ComparisonCubit() : super(const ComparisonState());

  void setFormulas(Formula a, Formula b) {
    emit(ComparisonState(
      status: ComparisonStatus.loaded,
      formulaA: a,
      formulaB: b,
    ));
  }

  void swap() {
    final a = state.formulaA;
    final b = state.formulaB;
    if (a == null || b == null) return;
    emit(state.copyWith(formulaA: b, formulaB: a));
  }
}
