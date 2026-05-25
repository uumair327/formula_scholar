import 'dart:math';

import 'package:equatable/equatable.dart';

import '../../../../shared/shared.dart';
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
    this.answerRecords = const [],
    this.quizStartTime,
    this.selectedTimedMode = false,
    this.selectedTimedDurationSeconds,
    this.availableSubjects = const [],
    this.isLoadingSubjects = false,
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
  final TimerStatus timerStatus;
  final bool timedMode;
  final int totalSeconds;
  final int remainingSeconds;
  final List<QuizAnswerRecord> answerRecords;
  final DateTime? quizStartTime;
  final bool selectedTimedMode;
  final int? selectedTimedDurationSeconds;
  final List<SelectedSubject> availableSubjects;
  final bool isLoadingSubjects;

  QuizQuestion? get currentQuestion =>
      currentIndex < questions.length ? questions[currentIndex] : null;

  int get totalQuestions => questions.length;

  double get progress =>
      totalQuestions > 0 ? (currentIndex + 1) / totalQuestions : 0;

  bool get isCorrect =>
      selectedOptionId != null &&
      currentQuestion != null &&
      selectedOptionId == currentQuestion!.correctOptionId;

  bool get isLastQuestion =>
      totalQuestions > 0 && currentIndex >= totalQuestions - 1;

  int get correctCount => answerRecords.where((r) => r.isCorrect).length;

  int get incorrectCount => answerRecords.where((r) => !r.isCorrect).length;

  int get maxPoints => questions.fold(0, (sum, q) => sum + q.points);

  int get timeTakenSeconds {
    if (quizStartTime == null) return 0;
    return DateTime.now().difference(quizStartTime!).inSeconds;
  }

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

  String get formattedRemaining {
    final mins = (remainingSeconds ~/ 60).toString().padLeft(2, '0');
    final secs = (remainingSeconds % 60).toString().padLeft(2, '0');
    return '$mins:$secs';
  }

  double get timerProgress =>
      totalSeconds > 0 ? remainingSeconds / totalSeconds : 1.0;

  bool get isTimerWarning =>
      timedMode &&
      timerStatus == TimerStatus.running &&
      totalSeconds > 0 &&
      remainingSeconds / totalSeconds < 0.25;

  /// Question IDs that were answered incorrectly (for retry).
  List<String> get incorrectQuestionIds => answerRecords
      .where((r) => !r.isCorrect)
      .map((r) => r.questionId)
      .toList();

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
    List<QuizAnswerRecord>? answerRecords,
    Object? quizStartTime = _unset,
    bool? selectedTimedMode,
    Object? selectedTimedDurationSeconds = _unset,
    List<SelectedSubject>? availableSubjects,
    bool? isLoadingSubjects,
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
      answerRecords: answerRecords ?? this.answerRecords,
      quizStartTime: identical(quizStartTime, _unset)
          ? this.quizStartTime
          : quizStartTime as DateTime?,
      selectedTimedMode: selectedTimedMode ?? this.selectedTimedMode,
      selectedTimedDurationSeconds:
          identical(selectedTimedDurationSeconds, _unset)
          ? this.selectedTimedDurationSeconds
          : selectedTimedDurationSeconds as int?,
      availableSubjects: availableSubjects ?? this.availableSubjects,
      isLoadingSubjects: isLoadingSubjects ?? this.isLoadingSubjects,
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
    answerRecords,
    quizStartTime,
    selectedTimedMode,
    selectedTimedDurationSeconds,
    availableSubjects,
    isLoadingSubjects,
  ];
}

/// Calculates a reasonable time limit based on question count.
int defaultTimeLimit(int questionCount) {
  return max(300, questionCount * 60);
}
