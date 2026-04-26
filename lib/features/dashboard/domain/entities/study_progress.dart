import 'package:equatable/equatable.dart';

/// Tracks study progress for the student.
class StudyProgress extends Equatable {
  const StudyProgress({
    required this.masteryPercentage,
    required this.completedChapters,
    required this.totalChapters,
  });
  final double masteryPercentage;
  final int completedChapters;
  final int totalChapters;

  @override
  List<Object?> get props => [
    masteryPercentage,
    completedChapters,
    totalChapters,
  ];
}
