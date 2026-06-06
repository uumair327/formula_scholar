import 'package:equatable/equatable.dart';

class SearchResult extends Equatable {
  const SearchResult({
    required this.id,
    required this.title,
    required this.latex,
    required this.description,
    required this.subjectId,
    required this.subjectName,
    required this.chapterId,
    required this.chapterName,
  });

  final String id;
  final String title;
  final String latex;
  final String description;
  final String subjectId;
  final String subjectName;
  final String chapterId;
  final String chapterName;

  @override
  List<Object?> get props => [id, title, latex, subjectId, chapterId];
}
