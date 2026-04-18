import 'package:equatable/equatable.dart';

/// A bookmarked formula entity.
class BookmarkedFormula extends Equatable {

  const BookmarkedFormula({
    required this.id,
    required this.title,
    required this.subject,
    required this.formula,
    required this.savedAt,
    required this.curriculumKey,
  });
  final String id;
  final String title;
  final String subject;
  final String formula;
  final DateTime savedAt;
  final String curriculumKey;

  @override
  List<Object?> get props => [id, title, subject, formula, savedAt, curriculumKey];
}

