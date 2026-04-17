import 'package:equatable/equatable.dart';

/// A saved study note fetched from backend content.
class SavedNote extends Equatable {
  final String id;
  final String title;
  final String subject;
  final String content;
  final String curriculumKey;
  final DateTime savedAt;

  const SavedNote({
    required this.id,
    required this.title,
    required this.subject,
    required this.content,
    required this.curriculumKey,
    required this.savedAt,
  });

  @override
  List<Object?> get props => [
    id,
    title,
    subject,
    content,
    curriculumKey,
    savedAt,
  ];
}
