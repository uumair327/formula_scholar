import 'package:equatable/equatable.dart';

import '../../domain/domain.dart';

enum DashboardStatus { initial, loading, loaded, error }

/// State for the Dashboard feature.
class DashboardState extends Equatable {
  final DashboardStatus status;
  final StudyProgress? progress;
  final List<Subject> subjects;
  final List<RecentStudy> recentStudies;
  final String? errorMessage;

  const DashboardState({
    this.status = DashboardStatus.initial,
    this.progress,
    this.subjects = const [],
    this.recentStudies = const [],
    this.errorMessage,
  });

  DashboardState copyWith({
    DashboardStatus? status,
    StudyProgress? progress,
    List<Subject>? subjects,
    List<RecentStudy>? recentStudies,
    String? errorMessage,
  }) {
    return DashboardState(
      status: status ?? this.status,
      progress: progress ?? this.progress,
      subjects: subjects ?? this.subjects,
      recentStudies: recentStudies ?? this.recentStudies,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }

  @override
  List<Object?> get props => [
        status,
        progress,
        subjects,
        recentStudies,
        errorMessage,
      ];
}
