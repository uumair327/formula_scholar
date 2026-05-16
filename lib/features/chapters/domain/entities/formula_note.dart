import 'package:equatable/equatable.dart';

/// A user-authored note attached to a specific formula.
class FormulaNote extends Equatable {
  const FormulaNote({
    required this.formulaId,
    required this.content,
    required this.updatedAt,
  });

  final String formulaId;
  final String content;
  final DateTime updatedAt;

  bool get isEmpty => content.trim().isEmpty;

  FormulaNote copyWith({
    String? formulaId,
    String? content,
    DateTime? updatedAt,
  }) {
    return FormulaNote(
      formulaId: formulaId ?? this.formulaId,
      content: content ?? this.content,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  @override
  List<Object?> get props => [formulaId, content, updatedAt];
}
