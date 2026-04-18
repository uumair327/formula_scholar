import 'package:equatable/equatable.dart';

/// A chapter bookmarked by the user for quick revisit.
class BookmarkedChapter extends Equatable {

  const BookmarkedChapter({
    required this.id,
    required this.chapterId,
    required this.chapterName,
    required this.chapterSubtitle,
    required this.subjectId,
    required this.subjectName,
    required this.curriculumKey,
    required this.savedAt,
  });
  final String id;
  final String chapterId;
  final String chapterName;
  final String chapterSubtitle;
  final String subjectId;
  final String subjectName;
  final String curriculumKey;
  final DateTime savedAt;

  @override
  List<Object?> get props => [
    id,
    chapterId,
    chapterName,
    chapterSubtitle,
    subjectId,
    subjectName,
    curriculumKey,
    savedAt,
  ];
}
