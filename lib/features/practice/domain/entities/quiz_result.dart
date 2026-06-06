import 'package:equatable/equatable.dart';

import 'quiz_answer_record.dart';

/// Full record of a completed practice quiz attempt.
class QuizResult extends Equatable {
  const QuizResult({
    required this.id,
    required this.boardId,
    required this.gradeId,
    this.subjectId,
    required this.totalQuestions,
    required this.correctCount,
    required this.incorrectCount,
    required this.totalPoints,
    required this.maxPoints,
    this.timedMode = false,
    this.timeTakenSeconds,
    this.answers = const [],
    this.completedAt,
  });

  factory QuizResult.fromJson(Map<String, dynamic> json) => QuizResult(
    id: json['id'] as String? ?? '',
    boardId: json['boardId'] as String? ?? '',
    gradeId: json['gradeId'] as String? ?? '',
    subjectId: json['subjectId'] as String?,
    totalQuestions: json['totalQuestions'] as int? ?? 0,
    correctCount: json['correctCount'] as int? ?? 0,
    incorrectCount: json['incorrectCount'] as int? ?? 0,
    totalPoints: json['totalPoints'] as int? ?? 0,
    maxPoints: json['maxPoints'] as int? ?? 0,
    timedMode: json['timedMode'] as bool? ?? false,
    timeTakenSeconds: json['timeTakenSeconds'] as int?,
    answers:
        (json['answers'] as List<dynamic>?)
            ?.map((e) => QuizAnswerRecord.fromJson(e as Map<String, dynamic>))
            .toList() ??
        const [],
    completedAt: json['completedAt'] != null
        ? DateTime.tryParse(json['completedAt'] as String)
        : null,
  );

  final String id;
  final String boardId;
  final String gradeId;
  final String? subjectId;
  final int totalQuestions;
  final int correctCount;
  final int incorrectCount;
  final int totalPoints;
  final int maxPoints;
  final bool timedMode;
  final int? timeTakenSeconds;
  final List<QuizAnswerRecord> answers;
  final DateTime? completedAt;

  double get scorePercent =>
      totalQuestions > 0 ? (correctCount / totalQuestions) * 100 : 0;

  int get starRating {
    final pct = scorePercent;
    if (pct >= 95) return 5;
    if (pct >= 80) return 4;
    if (pct >= 60) return 3;
    if (pct >= 40) return 2;
    return 1;
  }

  Map<String, int> get categoryBreakdown {
    final map = <String, int>{};
    for (final a in answers) {
      map[a.category] = (map[a.category] ?? 0) + 1;
    }
    return map;
  }

  Map<String, int> get categoryCorrect {
    final map = <String, int>{};
    for (final a in answers) {
      if (a.isCorrect) {
        map[a.category] = (map[a.category] ?? 0) + 1;
      }
    }
    return map;
  }

  Map<String, int> get categoryIncorrect {
    final map = <String, int>{};
    for (final a in answers) {
      if (!a.isCorrect) {
        map[a.category] = (map[a.category] ?? 0) + 1;
      }
    }
    return map;
  }

  QuizResult copyWith({DateTime? completedAt}) => QuizResult(
    id: id,
    boardId: boardId,
    gradeId: gradeId,
    subjectId: subjectId,
    totalQuestions: totalQuestions,
    correctCount: correctCount,
    incorrectCount: incorrectCount,
    totalPoints: totalPoints,
    maxPoints: maxPoints,
    timedMode: timedMode,
    timeTakenSeconds: timeTakenSeconds,
    answers: answers,
    completedAt: completedAt ?? this.completedAt,
  );

  Map<String, dynamic> toJson() => {
    'id': id,
    'boardId': boardId,
    'gradeId': gradeId,
    'subjectId': subjectId,
    'totalQuestions': totalQuestions,
    'correctCount': correctCount,
    'incorrectCount': incorrectCount,
    'totalPoints': totalPoints,
    'maxPoints': maxPoints,
    'timedMode': timedMode,
    'timeTakenSeconds': timeTakenSeconds,
    'answers': answers.map((a) => a.toJson()).toList(),
    'completedAt': completedAt?.toIso8601String(),
  };

  @override
  List<Object?> get props => [
    id,
    boardId,
    gradeId,
    totalQuestions,
    correctCount,
    incorrectCount,
    totalPoints,
    completedAt,
  ];
}
