import 'package:equatable/equatable.dart';

/// Represents a subject/category where the user performed poorly in quizzes.
///
/// Higher [weaknessScore] means more improvement needed.
class WeakArea extends Equatable {
  const WeakArea({
    required this.category,
    this.subjectName = '',
    this.totalAttempts = 0,
    this.correctAttempts = 0,
    this.iconName = 'book-open',
    this.colorValue = 0xFF00639A,
  });

  /// Maps to [Subject.category] and [QuizQuestion.category].
  final String category;

  /// Display name of the subject (populated from the dashboard subject data).
  final String subjectName;

  /// Total questions answered in this category.
  final int totalAttempts;

  /// Correct answers in this category.
  final int correctAttempts;

  /// Visual metadata for rendering.
  final String iconName;
  final int colorValue;

  /// How many questions were answered incorrectly.
  int get incorrectAttempts => totalAttempts - correctAttempts;

  /// Weakness score 0–100 (higher = weaker).
  /// 0 means all correct, 100 means all wrong.
  double get weaknessScore =>
      totalAttempts > 0
          ? ((totalAttempts - correctAttempts) / totalAttempts) * 100
          : 0.0;

  @override
  List<Object?> get props =>
      [category, subjectName, totalAttempts, correctAttempts];
}
