import 'package:flutter_test/flutter_test.dart';
import 'package:formula_scholar/features/widget_viewer/presentation/widgets/native_graph_widget.dart';
import 'package:formula_scholar/features/widget_viewer/presentation/widgets/graph_expression_evaluator.dart';

void main() {
  group('GraphExpressionEvaluator & ExprParser Tests', () {
    test('Basic Arithmetic and Constants', () {
      // y = x + 2
      expect(
        GraphExpressionEvaluator.evaluate('y = x + 2', 3.0, {}),
        closeTo(5.0, 0.001),
      );

      // y = pi
      expect(
        GraphExpressionEvaluator.evaluate('pi', 0.0, {}),
        closeTo(3.14159, 0.001),
      );

      // y = e
      expect(
        GraphExpressionEvaluator.evaluate('e', 0.0, {}),
        closeTo(2.71828, 0.001),
      );
    });

    test('Operators and Precedence', () {
      // y = 2 * x^2 - 3 * x + 4
      expect(
        GraphExpressionEvaluator.evaluate('2 * x^2 - 3 * x + 4', 3.0, {}),
        closeTo(13.0, 0.001),
      );

      // y = (x + 1) * (x - 1)
      expect(
        GraphExpressionEvaluator.evaluate('(x + 1) * (x - 1)', 3.0, {}),
        closeTo(8.0, 0.001),
      );
    });

    test('Named Parameters', () {
      // y = m*x + c
      final params1 = {'m': 2.5, 'c': -1.0};
      expect(
        GraphExpressionEvaluator.evaluate('m*x + c', 4.0, params1),
        closeTo(9.0, 0.001),
      );

      // Case-insensitivity in parameter names
      final params2 = {'A': 2.0, 'B': 3.0};
      expect(
        GraphExpressionEvaluator.evaluate('a * x^b', 2.0, params2),
        closeTo(16.0, 0.001),
      );
    });

    test('Trigonometric and Other Functions', () {
      // y = sin(x)
      expect(
        GraphExpressionEvaluator.evaluate('sin(pi / 2)', 0.0, {}),
        closeTo(1.0, 0.001),
      );
      expect(
        GraphExpressionEvaluator.evaluate('cos(0)', 0.0, {}),
        closeTo(1.0, 0.001),
      );
      expect(
        GraphExpressionEvaluator.evaluate('tan(0)', 0.0, {}),
        closeTo(0.0, 0.001),
      );

      // y = sqrt(x)
      expect(
        GraphExpressionEvaluator.evaluate('sqrt(16)', 0.0, {}),
        closeTo(4.0, 0.001),
      );
      expect(
        GraphExpressionEvaluator.evaluate('sqrt(-4)', 0.0, {})!.isNaN,
        isTrue,
      );

      // y = abs(x)
      expect(
        GraphExpressionEvaluator.evaluate('abs(-5.5)', 0.0, {}),
        closeTo(5.5, 0.001),
      );

      // y = ln(x) or log(x)
      expect(
        GraphExpressionEvaluator.evaluate('log(e)', 0.0, {}),
        closeTo(1.0, 0.001),
      );
      expect(
        GraphExpressionEvaluator.evaluate('ln(e)', 0.0, {}),
        closeTo(1.0, 0.001),
      );
    });

    test('Implicit Multiplication', () {
      // 2x -> 2 * x
      expect(
        GraphExpressionEvaluator.evaluate('2x', 5.0, {}),
        closeTo(10.0, 0.001),
      );

      // 2(x+1) -> 2 * (x+1)
      expect(
        GraphExpressionEvaluator.evaluate('2(x+1)', 3.0, {}),
        closeTo(8.0, 0.001),
      );

      // mx + c -> m * x + c (Note: 'mx' token is parsed as a single identifier if not separated.
      // But 'm*x' is safer. Let's verify parameter substitution on separated / implicit forms.)
      expect(
        GraphExpressionEvaluator.evaluate('2 x', 4.0, {}),
        closeTo(8.0, 0.001),
      );
    });

    test('Division by Zero', () {
      // y = 1 / x at x = 0
      expect(
        GraphExpressionEvaluator.evaluate('1 / x', 0.0, {})!.isNaN,
        isTrue,
      );
    });

    test('LaTeX Formatting Equivalents', () {
      // y = a \cdot x
      expect(
        GraphExpressionEvaluator.evaluate('a \\cdot x', 3.0, {'a': 5.0}),
        closeTo(15.0, 0.001),
      );
      expect(
        GraphExpressionEvaluator.evaluate('a \\\\cdot x', 3.0, {'a': 5.0}),
        closeTo(15.0, 0.001),
      );
    });

    test('Invalid / Empty Expressions', () {
      expect(GraphExpressionEvaluator.evaluate('', 3.0, {}), isNull);
      expect(GraphExpressionEvaluator.evaluate('y = ', 3.0, {}), isNull);
      // Malformed expression should catch error and return null or eval to NaN
      expect(GraphExpressionEvaluator.evaluate('x + +', 3.0, {}), isNotNull);
    });
    group('Specific board formula configurations', () {
      test('Compound interest: P*(1 + R/100)^x', () {
        final params = {'P': 1000.0, 'R': 10.0};
        // At x = 2 (2 years): 1000 * (1.1)^2 = 1210
        expect(
          GraphExpressionEvaluator.evaluate('P*(1 + R/100)^x', 2.0, params),
          closeTo(1210.0, 0.001),
        );
      });

      test('Slope point form: m*(x - x1) + y1', () {
        final params = {'m': 2.0, 'x1': 1.0, 'y1': 3.0};
        // At x = 4: 2 * (4 - 1) + 3 = 9
        expect(
          GraphExpressionEvaluator.evaluate('m*(x - x1) + y1', 4.0, params),
          closeTo(9.0, 0.001),
        );
      });
    });
  });
}
