import '../entities/study_progress.dart';
import '../entities/subject.dart';
import '../entities/recent_study.dart';

/// Port: Defines the contract that any backend adapter must implement.
///
/// This is the **driven port** (secondary port) in hexagonal terminology.
/// The domain layer owns this interface; infrastructure adapters implement it.
///
/// Implementations (adapters):
/// - [DashboardLocalAdapter] — hardcoded/static data for development
/// - (future) `DashboardFirebaseAdapter` — Firebase Firestore
/// - (future) `DashboardSupabaseAdapter` — Supabase
/// - (future) `DashboardRemoteAdapter` — REST API
///
/// To swap backends, create a new implementation and update the
/// DI registration — **zero changes** to domain, use cases, or presentation.
abstract interface class DashboardDataSourcePort {
  /// Fetches the user's overall study progress.
  Future<StudyProgress> getStudyProgress();

  /// Fetches the list of available subjects heavily filtered by curriculum.
  Future<List<Subject>> getSubjects(String boardId, String gradeId);

  /// Fetches recent study activity.
  Future<List<RecentStudy>> getRecentStudies();
}
