import 'package:flutter_test/flutter_test.dart';
import 'package:formula_scholar/core/domain/entities/formula.dart';
import 'package:formula_scholar/features/comparison/comparison.dart';

void main() {
  group('ComparisonState', () {
    test('initial state has initial status and null formulas', () {
      const state = ComparisonState();
      expect(state.status, ComparisonStatus.initial);
      expect(state.formulaA, isNull);
      expect(state.formulaB, isNull);
      expect(state.comparison, isNull);
    });

    test('copyWith updates status', () {
      const state = ComparisonState();
      final updated = state.copyWith(status: ComparisonStatus.loaded);
      expect(updated.status, ComparisonStatus.loaded);
    });

    test('copyWith preserves unchanged fields', () {
      const formulaA = Formula(
        id: '1',
        title: 'A',
        latex: 'a',
        description: '',
      );
      const state = ComparisonState(
        status: ComparisonStatus.loaded,
        formulaA: formulaA,
      );
      final updated = state.copyWith(status: ComparisonStatus.initial);
      expect(updated.formulaA, formulaA);
    });

    test('equality works on all fields', () {
      const state1 = ComparisonState(
        status: ComparisonStatus.loaded,
        formulaA: null,
        formulaB: null,
        comparison: null,
      );
      const state2 = ComparisonState(
        status: ComparisonStatus.loaded,
        formulaA: null,
        formulaB: null,
        comparison: null,
      );
      expect(state1, state2);
    });
  });

  group('ComparisonCubit', () {
    late ComparisonCubit cubit;

    setUp(() {
      cubit = ComparisonCubit(compareService: const FormulaCompareService());
    });

    tearDown(() {
      cubit.close();
    });

    test('initial state is ComparisonStatus.initial', () {
      expect(cubit.state.status, ComparisonStatus.initial);
      expect(cubit.state.formulaA, isNull);
      expect(cubit.state.formulaB, isNull);
    });

    test(
      'setFormulas emits loaded state with both formulas and comparison',
      () {
        const formulaA = Formula(
          id: '1',
          title: 'Newton\'s Law',
          latex: 'F = ma',
          description: 'Force equals mass times acceleration',
        );
        const formulaB = Formula(
          id: '2',
          title: 'Momentum',
          latex: 'p = mv',
          description: 'Momentum equals mass times velocity',
        );

        cubit.setFormulas(formulaA, formulaB);

        expect(cubit.state.status, ComparisonStatus.loaded);
        expect(cubit.state.formulaA, formulaA);
        expect(cubit.state.formulaB, formulaB);
        expect(cubit.state.comparison, isNotNull);
        expect(cubit.state.comparison!.sharedVariables, contains('m'));
      },
    );

    test('swap exchanges formulaA and formulaB and recomputes comparison', () {
      const formulaA = Formula(
        id: '1',
        title: 'A',
        latex: 'F = ma',
        description: 'Force',
      );
      const formulaB = Formula(
        id: '2',
        title: 'B',
        latex: 'p = mv',
        description: 'Momentum',
      );

      cubit.setFormulas(formulaA, formulaB);
      cubit.swap();

      expect(cubit.state.formulaA, formulaB);
      expect(cubit.state.formulaB, formulaA);
      expect(cubit.state.comparison, isNotNull);
    });

    test('swap does nothing when formulas are not set', () {
      cubit.swap();
      expect(cubit.state.status, ComparisonStatus.initial);
    });

    test('clear resets to initial state', () {
      const formulaA = Formula(
        id: '1',
        title: 'A',
        latex: 'F = ma',
        description: 'Force',
      );
      const formulaB = Formula(
        id: '2',
        title: 'B',
        latex: 'p = mv',
        description: 'Momentum',
      );

      cubit.setFormulas(formulaA, formulaB);
      expect(cubit.state.status, ComparisonStatus.loaded);

      cubit.clear();
      expect(cubit.state.status, ComparisonStatus.initial);
      expect(cubit.state.formulaA, isNull);
      expect(cubit.state.formulaB, isNull);
      expect(cubit.state.comparison, isNull);
    });

    test('emits states in correct order', () async {
      const formulaA = Formula(
        id: '1',
        title: 'A',
        latex: 'F = ma',
        description: 'Force',
      );
      const formulaB = Formula(
        id: '2',
        title: 'B',
        latex: 'p = mv',
        description: 'Momentum',
      );

      final future = expectLater(
        cubit.stream,
        emitsInOrder(<Matcher>[
          predicate<ComparisonState>(
            (s) => s.status == ComparisonStatus.loaded,
          ),
          predicate<ComparisonState>((s) => s.formulaA == formulaB),
          predicate<ComparisonState>(
            (s) => s.status == ComparisonStatus.initial,
          ),
        ]),
      );

      cubit.setFormulas(formulaA, formulaB);
      cubit.swap();
      cubit.clear();

      await future;
    });
  });
}
