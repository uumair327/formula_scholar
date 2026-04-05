import 'package:injectable/injectable.dart';

import '../../../../core/core.dart';
import '../entities/profile_stat.dart';
import '../ports/profile_repository_port.dart';

/// Fetches profile statistics (formulas mastered, streak, points).
///
/// Single-responsibility use case following SOLID principles.
@injectable
class GetProfileStatsUseCase {
  final ProfileRepositoryPort _repository;

  const GetProfileStatsUseCase({required ProfileRepositoryPort repository})
    : _repository = repository;

  /// Executes the use case.
  Future<Result<List<ProfileStat>>> call() {
    AppLogger.trace(
      'GetProfileStatsUseCase called',
      tag: AppLogTags.profileCubit,
    );
    return _repository.getProfileStats();
  }
}
