import 'package:equatable/equatable.dart';

/// Represents a single quiz option (A, B, C, D).
class QuizOption extends Equatable {
  final String id;
  final String text;

  const QuizOption({required this.id, required this.text});

  @override
  List<Object?> get props => [id, text];
}

/// Represents a single quiz question with multiple-choice options.
class QuizQuestion extends Equatable {
  final String id;
  final String category;
  final String topic;
  final String questionText;
  final String imageUrl;
  final List<QuizOption> options;
  final String correctOptionId;
  final int points;

  const QuizQuestion({
    required this.id,
    required this.category,
    required this.topic,
    required this.questionText,
    required this.imageUrl,
    required this.options,
    required this.correctOptionId,
    this.points = 10,
  });

  @override
  List<Object?> get props => [
    id,
    category,
    topic,
    questionText,
    options,
    correctOptionId,
    points,
  ];
}
