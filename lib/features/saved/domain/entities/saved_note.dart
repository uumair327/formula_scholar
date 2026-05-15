import 'package:equatable/equatable.dart';

/// A saved study note fetched from backend content.
class SavedNote extends Equatable {
  const SavedNote({
    required this.id,
    required this.title,
    required this.subject,
    required this.content,
    required this.curriculumKey,
    required this.savedAt,
    this.subjectId,
    this.chapterId,
    this.formulaId,
    this.formulaTitle,
    this.formulaLatex,
  });
  final String id;
  final String title;
  final String subject;
  final String content;
  final String curriculumKey;
  final DateTime savedAt;
  final String? subjectId;
  final String? chapterId;
  final String? formulaId;
  final String? formulaTitle;
  final String? formulaLatex;

  SavedNote copyWith({
    String? id,
    String? title,
    String? subject,
    String? content,
    String? curriculumKey,
    DateTime? savedAt,
    String? subjectId,
    String? chapterId,
    String? formulaId,
    String? formulaTitle,
    String? formulaLatex,
  }) {
    return SavedNote(
      id: id ?? this.id,
      title: title ?? this.title,
      subject: subject ?? this.subject,
      content: content ?? this.content,
      curriculumKey: curriculumKey ?? this.curriculumKey,
      savedAt: savedAt ?? this.savedAt,
      subjectId: subjectId ?? this.subjectId,
      chapterId: chapterId ?? this.chapterId,
      formulaId: formulaId ?? this.formulaId,
      formulaTitle: formulaTitle ?? this.formulaTitle,
      formulaLatex: formulaLatex ?? this.formulaLatex,
    );
  }

  @override
  List<Object?> get props => [
    id,
    title,
    subject,
    content,
    curriculumKey,
    savedAt,
    formulaId,
  ];
}
