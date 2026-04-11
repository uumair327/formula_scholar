import '../../../../core/domain/entities/paginated_response.dart';
import '../entities/board.dart';
import '../entities/country.dart';
import '../entities/grade.dart';
import '../entities/state_region.dart';

/// Port: Driven port for onboarding data.
///
/// Any backend adapter (local, API, Firebase) must implement this.
abstract interface class OnboardingDataSourcePort {
  /// Fetches available countries.
  Future<PaginatedResponse<Country>> getCountries({
    int limit = 20,
    String? startAfterId,
  });

  /// Fetches available states/regions for the given [countryId].
  Future<PaginatedResponse<StateRegion>> getStates(
    String countryId, {
    int limit = 20,
    String? startAfterId,
  });

  /// Fetches available academic boards filtered by country and optionally state.
  Future<PaginatedResponse<Board>> getBoards(
    String countryId, {
    String? stateId,
    int limit = 20,
    String? startAfterId,
  });

  /// Fetches available grades/classes for the given [boardId].
  Future<PaginatedResponse<Grade>> getGrades(
    String boardId, {
    int limit = 20,
    String? startAfterId,
  });
}
