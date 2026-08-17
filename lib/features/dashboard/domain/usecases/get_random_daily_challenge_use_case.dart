import 'package:injectable/injectable.dart';
import '../entities/daily_challenge.dart';

abstract final class DailyChallengesConfig {
  static const challenges = [
    DailyChallenge(
      formulaTitle: 'Quadratic Formula',
      formulaLatex: r'x = \frac{-b \pm \sqrt{b^2 - 4ac}}{2a}',
      question: 'What is the expression under the square root called?',
      options: ['Discriminant', 'Determinant', 'Coefficient', 'Radicand'],
      correctIndex: 0,
    ),
    DailyChallenge(
      formulaTitle: 'Pythagorean Theorem',
      formulaLatex: r'a^2 + b^2 = c^2',
      question: 'In the Pythagorean theorem, what does c represent?',
      options: [
        'The hypotenuse',
        'The adjacent side',
        'The opposite side',
        'The area',
      ],
      correctIndex: 0,
    ),
    DailyChallenge(
      formulaTitle: 'Newton\'s Second Law',
      formulaLatex: r'F = ma',
      question: 'What does F represent in Newton\'s Second Law?',
      options: [
        'Net force',
        'Friction force',
        'Normal force',
        'Gravitational force',
      ],
      correctIndex: 0,
    ),
    DailyChallenge(
      formulaTitle: 'Area of a Circle',
      formulaLatex: r'A = \pi r^2',
      question: 'What happens to the area if the radius is doubled?',
      options: [
        'Area quadruples',
        'Area doubles',
        'Area triples',
        'Area stays the same',
      ],
      correctIndex: 0,
    ),
    DailyChallenge(
      formulaTitle: 'Energy of a Photon',
      formulaLatex: r'E = h\nu',
      question: 'What does h represent in this formula?',
      options: [
        'Planck\'s constant',
        'Height',
        'Henry\'s constant',
        'Harmonic number',
      ],
      correctIndex: 0,
    ),
    DailyChallenge(
      formulaTitle: 'Molarity',
      formulaLatex: r'M = \frac{n}{V}',
      question: 'What unit is molarity expressed in?',
      options: ['mol/L', 'g/mol', 'L/mol', 'mol/g'],
      correctIndex: 0,
    ),
    DailyChallenge(
      formulaTitle: 'Difference of Squares',
      formulaLatex: r'a^2 - b^2 = (a-b)(a+b)',
      question: 'What is the factorization of x² - 9?',
      options: ['(x-3)(x+3)', '(x-9)(x+9)', '(x-3)²', '(x+3)²'],
      correctIndex: 0,
    ),
    DailyChallenge(
      formulaTitle: 'Slope Formula',
      formulaLatex: r'm = \frac{y_2 - y_1}{x_2 - x_1}',
      question: 'A line with positive slope goes...',
      options: [
        'Upward from left to right',
        'Downward from left to right',
        'Horizontal',
        'Vertical',
      ],
      correctIndex: 0,
    ),
  ];
}

@injectable
class GetRandomDailyChallengeUseCase {
  DailyChallenge call() {
    final challenges = List.of(DailyChallengesConfig.challenges);
    // We use time based seeded random to keep the same challenge per day per user (optional),
    // but the original logic just picked one using random.
    // For now we preserve original logic but in a use case.
    challenges.shuffle();
    return challenges.first;
  }
}
