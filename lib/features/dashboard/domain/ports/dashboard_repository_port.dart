import '../../../../core/error/result.dart';
import '../entities/study_progress.dart';
import '../entities/subject.dart';
import '../entities/recent_study.dart';

/// Port: Defines the contract for dashboard data access.
///
/// This is the **primary port** in hexagonal terminology — the interface
/// that the application layer (use cases) depends on.
///
/// Implemented by [DashboardRepositoryImpl] in the infrastructure layer.
/// Returns [Result] to enforce typed error handling at the boundary.
abstract interface class DashboardRepositoryPort {
  /// Fetches the user's overall study progress.
  Future<Result<StudyProgress>> getStudyProgress();

  /// Fetches the list of available subjects.
  Future<Result<List<Subject>>> getSubjects(String boardId, String gradeId);

  /// Fetches recent study activity.
  Future<Result<List<RecentStudy>>> getRecentStudies();
}
