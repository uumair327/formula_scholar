import 'package:flutter_test/flutter_test.dart';
import 'package:formula_scholar/features/chapters/domain/entities/formula.dart';
import 'package:formula_scholar/features/comparison/comparison.dart';

void main() {
  group('FormulaCompareService', () {
    late FormulaCompareService service;

    setUp(() {
      service = FormulaCompareService();
    });

    group('extractVariables', () {
      test('extracts single-letter variables from simple LaTeX', () {
        final vars = service.extractVariables('E = mc^2');
        expect(vars, contains('E'));
        expect(vars, contains('m'));
        expect(vars, contains('c'));
      });

      test('extracts variables from fraction expressions', () {
        final vars = service.extractVariables('F = \\frac{ma}{2}');
        expect(vars, contains('F'));
        expect(vars, contains('m'));
        expect(vars, contains('a'));
      });

      test('ignores common LaTeX commands', () {
        final vars = service.extractVariables('\\sqrt{x^2 + y^2}');
        expect(vars, contains('x'));
        expect(vars, contains('y'));
        expect(vars, isNot(contains('sqrt')));
      });

      test('extracts Greek letter variables', () {
        final vars = service.extractVariables('\\theta = \\frac{\\pi}{2}');
        expect(vars, contains('theta'));
        expect(vars, contains('pi'));
      });

      test('extracts variables from constant expressions', () {
        final vars = service.extractVariables('E = 2.998 \\times 10^8');
        expect(vars, contains('E'));
      });

      test('handles complex physics formulas', () {
        final vars = service.extractVariables('v = u + at');
        expect(vars, contains('v'));
        expect(vars, contains('u'));
        expect(vars, contains('a'));
        expect(vars, contains('t'));
      });
    });

    group('computeDescriptionSimilarity', () {
      test('returns 1.0 for identical descriptions', () {
        final score = service.computeDescriptionSimilarity(
          'Force equals mass times acceleration',
          'Force equals mass times acceleration',
        );
        expect(score, 1.0);
      });

      test('returns 0.0 for completely different descriptions', () {
        final score = service.computeDescriptionSimilarity(
          'Force equals mass times acceleration',
          'The speed of light in vacuum',
        );
        expect(score, 0.0);
      });

      test('returns partial score for overlapping descriptions', () {
        final score = service.computeDescriptionSimilarity(
          'Force equals mass times acceleration',
          'Mass times acceleration gives force',
        );
        expect(score, greaterThan(0.0));
        expect(score, lessThan(1.0));
      });

      test('handles empty descriptions', () {
        final score = service.computeDescriptionSimilarity('', '');
        expect(score, 1.0);
      });

      test('handles one empty description', () {
        final score = service.computeDescriptionSimilarity('hello', '');
        expect(score, 0.0);
      });
    });

    group('compare', () {
      test('identifies shared variables between similar formulas', () {
        final a = const Formula(
          id: '1',
          title: 'Newton\'s Second Law',
          latex: 'F = ma',
          description: 'Force equals mass times acceleration',
        );
        final b = const Formula(
          id: '2',
          title: 'Momentum',
          latex: 'p = mv',
          description: 'Momentum equals mass times velocity',
        );

        final result = service.compare(a, b);

        expect(result.sharedVariables, contains('m'));
        expect(result.uniqueToA, contains('F'));
        expect(result.uniqueToA, contains('a'));
        expect(result.uniqueToB, contains('p'));
        expect(result.uniqueToB, contains('v'));
      });

      test('computes similarity score between 0 and 1', () {
        final a = const Formula(
          id: '1',
          title: 'A',
          latex: 'E = mc^2',
          description: 'Energy mass equivalence',
        );
        final b = const Formula(
          id: '2',
          title: 'B',
          latex: 'F = ma',
          description: 'Force mass acceleration',
        );

        final result = service.compare(a, b);

        expect(result.similarityScore, greaterThanOrEqualTo(0.0));
        expect(result.similarityScore, lessThanOrEqualTo(1.0));
      });

      test('high similarity for nearly identical formulas', () {
        final a = const Formula(
          id: '1',
          title: 'Kinetic Energy',
          latex: 'KE = \\frac{1}{2}mv^2',
          description: 'Kinetic energy of a moving object',
        );
        final b = const Formula(
          id: '2',
          title: 'Kinetic Energy Alt',
          latex: 'E_k = \\frac{1}{2}mv^2',
          description: 'Kinetic energy of a moving object',
        );

        final result = service.compare(a, b);

        expect(result.isHighlySimilar, isTrue);
      });

      test('low similarity for unrelated formulas', () {
        final a = const Formula(
          id: '1',
          title: 'Ohm\'s Law',
          latex: 'V = IR',
          description: 'Voltage equals current times resistance',
        );
        final b = const Formula(
          id: '2',
          title: 'Gravity',
          latex: 'F = G\\frac{m_1m_2}{r^2}',
          description: 'Gravitational force between two masses',
        );

        final result = service.compare(a, b);

        expect(result.similarityScore, lessThan(0.3));
      });
    });
  });
}
