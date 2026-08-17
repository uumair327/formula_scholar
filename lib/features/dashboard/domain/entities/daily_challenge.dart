import 'package:equatable/equatable.dart';

class DailyChallenge extends Equatable {
  const DailyChallenge({
    required this.formulaTitle,
    required this.formulaLatex,
    required this.question,
    required this.options,
    required this.correctIndex,
  });

  final String formulaTitle;
  final String formulaLatex;
  final String question;
  final List<String> options;
  final int correctIndex;

  @override
  List<Object?> get props => [
        formulaTitle,
        formulaLatex,
        question,
        options,
        correctIndex,
      ];
}
