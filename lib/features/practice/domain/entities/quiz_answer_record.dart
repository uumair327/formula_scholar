import 'package:equatable/equatable.dart';

/// Tracks a single answer submitted during a practice quiz.
class QuizAnswerRecord extends Equatable {
  const QuizAnswerRecord({
    required this.questionId,
    required this.category,
    required this.topic,
    required this.selectedOptionId,
    required this.correctOptionId,
    required this.isCorrect,
    this.timestamp,
  });

  factory QuizAnswerRecord.fromJson(Map<String, dynamic> json) =>
      QuizAnswerRecord(
        questionId: json['questionId'] as String? ?? '',
        category: json['category'] as String? ?? '',
        topic: json['topic'] as String? ?? '',
        selectedOptionId: json['selectedOptionId'] as String? ?? '',
        correctOptionId: json['correctOptionId'] as String? ?? '',
        isCorrect: json['isCorrect'] as bool? ?? false,
        timestamp: json['timestamp'] != null
            ? DateTime.tryParse(json['timestamp'] as String)
            : null,
      );

  final String questionId;
  final String category;
  final String topic;
  final String selectedOptionId;
  final String correctOptionId;
  final bool isCorrect;
  final DateTime? timestamp;

  Map<String, dynamic> toJson() => {
    'questionId': questionId,
    'category': category,
    'topic': topic,
    'selectedOptionId': selectedOptionId,
    'correctOptionId': correctOptionId,
    'isCorrect': isCorrect,
    'timestamp':
        timestamp?.toIso8601String() ?? DateTime.now().toIso8601String(),
  };

  @override
  List<Object?> get props => [
    questionId,
    category,
    topic,
    selectedOptionId,
    correctOptionId,
    isCorrect,
  ];
}
