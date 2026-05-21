import 'package:injectable/injectable.dart';

import '../../../chapters/domain/entities/formula.dart';
import '../entities/formula_comparison.dart';

@injectable
class FormulaCompareService {
  static final _commandPattern = RegExp(r'\\[a-zA-Z]+');
  static final _commonCommands = {
    'frac', 'sqrt', 'left', 'right', 'cdot', 'times',
    'pm', 'mp', 'div', 'infty',
    'sin', 'cos', 'tan', 'log', 'ln', 'exp',
    'sum', 'prod', 'int', 'lim', 'max', 'min',
    'text', 'mathrm', 'mathbf', 'mathit',
    'overline', 'underline', 'hat', 'bar', 'vec',
    'approx', 'equiv', 'neq', 'leq', 'geq',
    'subset', 'supset', 'notin',
    'forall', 'exists', 'nabla', 'partial',
    'rightarrow', 'leftarrow', 'Rightarrow', 'Leftarrow',
    'begin', 'end', 'matrix', 'pmatrix', 'bmatrix',
    'displaystyle', 'textstyle', 'scriptstyle',
    'quad', 'qquad', 'space',
  };

  Set<String> extractVariables(String latex) {
    final variables = <String>{};

    final commandMatches = _commandPattern.allMatches(latex);
    for (final match in commandMatches) {
      final cmd = match.group(0)!.substring(1);
      if (!_commonCommands.contains(cmd)) {
        variables.add(cmd);
      }
    }

    final cleaned = latex.replaceAll(_commandPattern, ' ');
    for (final char in cleaned.runes) {
      final letter = String.fromCharCode(char);
      final code = letter.codeUnitAt(0);
      if ((code >= 97 && code <= 122) || (code >= 65 && code <= 90)) {
        variables.add(letter);
      }
    }

    variables.removeAll(_commonCommands);
    return variables;
  }

  double computeDescriptionSimilarity(String a, String b) {
    if (a.isEmpty && b.isEmpty) return 1.0;
    if (a.isEmpty || b.isEmpty) return 0.0;

    final wordsA = a.toLowerCase().split(RegExp(r'\s+')).toSet();
    final wordsB = b.toLowerCase().split(RegExp(r'\s+')).toSet();

    if (wordsA.isEmpty && wordsB.isEmpty) return 1.0;
    if (wordsA.isEmpty || wordsB.isEmpty) return 0.0;

    final intersection = wordsA.intersection(wordsB);
    final union = wordsA.union(wordsB);

    return intersection.length / union.length;
  }

  FormulaComparison compare(Formula a, Formula b) {
    final varsA = extractVariables(a.latex);
    final varsB = extractVariables(b.latex);

    final shared = varsA.intersection(varsB);
    final uniqueA = varsA.difference(varsB);
    final uniqueB = varsB.difference(varsA);

    final allVars = varsA.union(varsB);
    final variableSimilarity = allVars.isEmpty
        ? 0.0
        : shared.length / allVars.length;

    final descSimilarity = computeDescriptionSimilarity(
      a.description,
      b.description,
    );

    final similarityScore = (variableSimilarity * 0.7) + (descSimilarity * 0.3);

    return FormulaComparison(
      sharedVariables: shared,
      uniqueToA: uniqueA,
      uniqueToB: uniqueB,
      similarityScore: similarityScore,
      descriptionOverlap: descSimilarity,
    );
  }
}
