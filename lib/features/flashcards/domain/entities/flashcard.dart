import 'package:equatable/equatable.dart';

enum FlashcardDifficulty { easy, medium, hard }

class Flashcard extends Equatable {
  const Flashcard({
    required this.id,
    required this.title,
    required this.latex,
    required this.description,
    required this.subjectId,
    required this.subjectName,
    required this.chapterId,
    required this.chapterName,
    this.difficulty = FlashcardDifficulty.medium,
    this.isMastered = false,
  });

  final String id;
  final String title;
  final String latex;
  final String description;
  final String subjectId;
  final String subjectName;
  final String chapterId;
  final String chapterName;
  final FlashcardDifficulty difficulty;
  final bool isMastered;

  Flashcard copyWith({bool? isMastered, FlashcardDifficulty? difficulty}) {
    return Flashcard(
      id: id,
      title: title,
      latex: latex,
      description: description,
      subjectId: subjectId,
      subjectName: subjectName,
      chapterId: chapterId,
      chapterName: chapterName,
      difficulty: difficulty ?? this.difficulty,
      isMastered: isMastered ?? this.isMastered,
    );
  }

  @override
  List<Object?> get props => [id, title, latex, isMastered];
}
