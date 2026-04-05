import '../../../../core/core.dart';
import '../entities/board.dart';
import '../entities/country.dart';
import '../entities/grade.dart';
import '../entities/state_region.dart';

/// Port: Primary port for onboarding repository operations.
abstract interface class OnboardingRepositoryPort {
  Future<Result<PaginatedResponse<Country>>> getCountries({int limit = 20, String? startAfterId});
  
  Future<Result<PaginatedResponse<StateRegion>>> getStates(String countryId, {int limit = 20, String? startAfterId});

  Future<Result<PaginatedResponse<Board>>> getBoards(String countryId, {String? stateId, int limit = 20, String? startAfterId});

  Future<Result<PaginatedResponse<Grade>>> getGrades(String boardId, {int limit = 20, String? startAfterId});
}
