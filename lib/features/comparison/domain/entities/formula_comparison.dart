import 'package:equatable/equatable.dart';

class FormulaComparison extends Equatable {
  const FormulaComparison({
    required this.sharedVariables,
    required this.uniqueToA,
    required this.uniqueToB,
    required this.similarityScore,
    required this.descriptionOverlap,
  });

  final Set<String> sharedVariables;
  final Set<String> uniqueToA;
  final Set<String> uniqueToB;
  final double similarityScore;
  final double descriptionOverlap;

  bool get hasSharedVariables => sharedVariables.isNotEmpty;
  bool get isHighlySimilar => similarityScore > 0.6;

  @override
  List<Object?> get props => [
    sharedVariables,
    uniqueToA,
    uniqueToB,
    similarityScore,
    descriptionOverlap,
  ];
}
