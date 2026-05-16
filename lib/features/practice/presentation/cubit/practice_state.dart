import 'dart:math';

import 'package:equatable/equatable.dart';

import '../../domain/domain.dart';

const Object _unset = Object();

enum PracticeStatus { initial, loading, loaded, completed, error }

enum TimerStatus { idle, running, paused, expired }

/// State for the Practice quiz feature.
class PracticeState extends Equatable {
  const PracticeState({
    this.status = PracticeStatus.initial,
    this.questions = const [],
    this.currentIndex = 0,
    this.selectedOptionId,
    this.showResult = false,
    this.totalPoints = 0,
    this.errorMessage,
    this.boardId,
    this.gradeId,
    this.subjectId,
    this.timerStatus = TimerStatus.idle,
    this.timedMode = false,
    this.totalSeconds = 0,
    this.remainingSeconds = 0,
  });
  final PracticeStatus status;
  final List<QuizQuestion> questions;
  final int currentIndex;
  final String? selectedOptionId;
  final bool showResult;
  final int totalPoints;
  final String? errorMessage;
  final String? boardId;
  final String? gradeId;
  final String? subjectId;

  // Timer fields
  final TimerStatus timerStatus;
  final bool timedMode;
  final int totalSeconds;
  final int remainingSeconds;

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

  /// Whether the user is on the last question.
  bool get isLastQuestion =>
      totalQuestions > 0 && currentIndex >= totalQuestions - 1;

  /// Remaining time formatted as MM:SS.
  String get formattedRemaining {
    final mins = (remainingSeconds ~/ 60).toString().padLeft(2, '0');
    final secs = (remainingSeconds % 60).toString().padLeft(2, '0');
    return '$mins:$secs';
  }

  /// Timer progress as 0.0 – 1.0.
  double get timerProgress =>
      totalSeconds > 0 ? remainingSeconds / totalSeconds : 1.0;

  /// Whether the timer is in a warning state (less than 25% remaining).
  bool get isTimerWarning =>
      timedMode && timerStatus == TimerStatus.running &&
      totalSeconds > 0 && remainingSeconds / totalSeconds < 0.25;

  PracticeState copyWith({
    PracticeStatus? status,
    List<QuizQuestion>? questions,
    int? currentIndex,
    Object? selectedOptionId = _unset,
    bool? showResult,
    int? totalPoints,
    Object? errorMessage = _unset,
    String? boardId,
    String? gradeId,
    String? subjectId,
    TimerStatus? timerStatus,
    bool? timedMode,
    int? totalSeconds,
    int? remainingSeconds,
  }) {
    return PracticeState(
      status: status ?? this.status,
      questions: questions ?? this.questions,
      currentIndex: currentIndex ?? this.currentIndex,
      selectedOptionId: identical(selectedOptionId, _unset)
          ? this.selectedOptionId
          : selectedOptionId as String?,
      showResult: showResult ?? this.showResult,
      totalPoints: totalPoints ?? this.totalPoints,
      errorMessage: identical(errorMessage, _unset)
          ? this.errorMessage
          : errorMessage as String?,
      boardId: boardId ?? this.boardId,
      gradeId: gradeId ?? this.gradeId,
      subjectId: subjectId ?? this.subjectId,
      timerStatus: timerStatus ?? this.timerStatus,
      timedMode: timedMode ?? this.timedMode,
      totalSeconds: totalSeconds ?? this.totalSeconds,
      remainingSeconds: remainingSeconds ?? this.remainingSeconds,
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
    boardId,
    gradeId,
    subjectId,
    timerStatus,
    timedMode,
    totalSeconds,
    remainingSeconds,
  ];
}

/// Calculates a reasonable time limit based on question count.
int defaultTimeLimit(int questionCount) {
  // Allow 60 seconds per question, minimum 5 minutes.
  return max(300, questionCount * 60);
}
