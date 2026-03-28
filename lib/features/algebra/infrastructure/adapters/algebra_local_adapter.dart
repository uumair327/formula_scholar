import 'package:injectable/injectable.dart';

import '../../../../core/core.dart';
import '../../domain/domain.dart';

/// Local adapter: returns hardcoded formula data for development.
///
/// Driven adapter implementing [AlgebraDataSourcePort].
@LazySingleton(as: AlgebraDataSourcePort)
class AlgebraLocalAdapter implements AlgebraDataSourcePort {
  @override
  Future<List<FormulaSection>> getFormulaSections() async {
    AppLogger.trace(
      'getFormulaSections() fetching local data',
      tag: AppLogTags.algebraDataSource,
    );
    return const [
      FormulaSection(
        title: AppStrings.polynomialIdentities,
        formulas: [
          Formula(
            id: 'poly_1',
            expression: '(a + b)² = a² + 2ab + b²',
            highlightedPart: 'a² + 2ab + b²',
            tag: AppStrings.squareOfSum,
            badge: AppStrings.essential,
            description: AppStrings.usedInQuadraticEquations,
            isBookmarked: true,
          ),
          Formula(
            id: 'poly_2',
            expression: '(a - b)² = a² - 2ab + b²',
            highlightedPart: 'a² - 2ab + b²',
            tag: AppStrings.squareOfDifference,
          ),
          Formula(
            id: 'poly_3',
            expression: 'a² - b² = (a + b)(a - b)',
            highlightedPart: '(a + b)(a - b)',
            tag: AppStrings.differenceOfSquares,
            isBookmarked: true,
          ),
        ],
      ),
      FormulaSection(
        title: AppStrings.linearEquations,
        formulas: [
          Formula(
            id: 'linear_1',
            expression: 'ax + by + c = 0',
            badge: AppStrings.standardForm,
            description: AppStrings.linearEquationDesc,
          ),
        ],
      ),
      FormulaSection(
        title: AppStrings.cubicIdentities,
        formulas: [
          Formula(
            id: 'cubic_1',
            expression: '(a + b)³ = a³ + b³ + 3ab(a + b)',
            tag: AppStrings.cubeOfSum,
            isBookmarked: true,
          ),
          Formula(
            id: 'cubic_2',
            expression:
                'a³ + b³ + c³ - 3abc = (a + b + c)(a² + b² + c² - ab - bc - ca)',
          ),
        ],
      ),
    ];
  }
}
