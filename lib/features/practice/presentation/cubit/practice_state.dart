import 'package:equatable/equatable.dart';

import '../../domain/domain.dart';

const Object _unset = Object();

enum PracticeStatus { initial, loading, loaded, error }

/// State for the Practice quiz feature.
class PracticeState extends Equatable {
  final PracticeStatus status;
  final List<QuizQuestion> questions;
  final int currentIndex;
  final String? selectedOptionId;
  final bool showResult;
  final int totalPoints;
  final String? errorMessage;

  const PracticeState({
    this.status = PracticeStatus.initial,
    this.questions = const [],
    this.currentIndex = 0,
    this.selectedOptionId,
    this.showResult = false,
    this.totalPoints = 0,
    this.errorMessage,
  });

  /// The current question being displayed.
  QuizQuestion? get currentQuestion =>
      currentIndex < questions.length ? questions[currentIndex] : null;

  /// Total number of questions.
  int get totalQuestions => questions.length;

  /// Progress as 0.0 – 1.0.
  double get progress =>
      totalQuestions > 0 ? (currentIndex + 1) / totalQuestions : 0;

  /// Whether the selected option is the correct one.
  bool get isCorrect =>
      selectedOptionId != null &&
      currentQuestion != null &&
      selectedOptionId == currentQuestion!.correctOptionId;

  PracticeState copyWith({
    PracticeStatus? status,
    List<QuizQuestion>? questions,
    int? currentIndex,
    String? selectedOptionId,
    bool? showResult,
    int? totalPoints,
    Object? errorMessage = _unset,
  }) {
    return PracticeState(
      status: status ?? this.status,
      questions: questions ?? this.questions,
      currentIndex: currentIndex ?? this.currentIndex,
      selectedOptionId: selectedOptionId,
      showResult: showResult ?? this.showResult,
      totalPoints: totalPoints ?? this.totalPoints,
      errorMessage: identical(errorMessage, _unset)
          ? this.errorMessage
          : errorMessage as String?,
    );
  }

  @override
  List<Object?> get props => [
    status,
    questions,
    currentIndex,
    selectedOptionId,
    showResult,
    totalPoints,
    errorMessage,
  ];
}
