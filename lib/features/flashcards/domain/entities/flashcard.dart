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
    this.easeFactor = 2.5,
    this.interval = 0,
    this.reviewCount = 0,
    this.lapses = 0,
    this.nextReviewAt,
  });

  factory Flashcard.fromJson(Map<String, dynamic> json) => Flashcard(
    id: json['id'] as String? ?? '',
    title: json['title'] as String? ?? '',
    latex: json['latex'] as String? ?? '',
    description: json['description'] as String? ?? '',
    subjectId: json['subjectId'] as String? ?? '',
    subjectName: json['subjectName'] as String? ?? '',
    chapterId: json['chapterId'] as String? ?? '',
    chapterName: json['chapterName'] as String? ?? '',
    difficulty: FlashcardDifficulty.values.firstWhere(
      (d) => d.name == json['difficulty'],
      orElse: () => FlashcardDifficulty.medium,
    ),
    isMastered: json['isMastered'] as bool? ?? false,
    easeFactor: (json['easeFactor'] as num?)?.toDouble() ?? 2.5,
    interval: json['interval'] as int? ?? 0,
    reviewCount: json['reviewCount'] as int? ?? 0,
    lapses: json['lapses'] as int? ?? 0,
    nextReviewAt: json['nextReviewAt'] != null
        ? DateTime.tryParse(json['nextReviewAt'] as String)
        : null,
  );

  Map<String, dynamic> toJson() => {
    'id': id,
    'title': title,
    'latex': latex,
    'description': description,
    'subjectId': subjectId,
    'subjectName': subjectName,
    'chapterId': chapterId,
    'chapterName': chapterName,
    'difficulty': difficulty.name,
    'isMastered': isMastered,
    'easeFactor': easeFactor,
    'interval': interval,
    'reviewCount': reviewCount,
    'lapses': lapses,
    'nextReviewAt': nextReviewAt?.toIso8601String(),
  };

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

  // Spaced Repetition (SM-2) fields
  final double easeFactor;
  final int interval;
  final int reviewCount;
  final int lapses;
  final DateTime? nextReviewAt;

  Flashcard copyWith({
    bool? isMastered,
    FlashcardDifficulty? difficulty,
    double? easeFactor,
    int? interval,
    int? reviewCount,
    int? lapses,
    DateTime? nextReviewAt,
  }) {
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
      easeFactor: easeFactor ?? this.easeFactor,
      interval: interval ?? this.interval,
      reviewCount: reviewCount ?? this.reviewCount,
      lapses: lapses ?? this.lapses,
      nextReviewAt: nextReviewAt ?? this.nextReviewAt,
    );
  }

  @override
  List<Object?> get props => [
    id,
    title,
    latex,
    isMastered,
    easeFactor,
    interval,
    reviewCount,
    lapses,
    nextReviewAt,
  ];
}
