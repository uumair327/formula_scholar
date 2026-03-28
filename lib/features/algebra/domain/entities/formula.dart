import 'package:equatable/equatable.dart';

/// A mathematical formula item.
class Formula extends Equatable {
  final String id;
  final String expression;
  final String? highlightedPart;
  final String? tag;
  final String? badge;
  final String? description;
  final bool isBookmarked;

  const Formula({
    required this.id,
    required this.expression,
    this.highlightedPart,
    this.tag,
    this.badge,
    this.description,
    this.isBookmarked = false,
  });

  @override
  List<Object?> get props => [id, expression];
}

/// A section grouping formulas by category.
class FormulaSection extends Equatable {
  final String title;
  final List<Formula> formulas;

  const FormulaSection({
    required this.title,
    required this.formulas,
  });

  @override
  List<Object?> get props => [title, formulas];
}
