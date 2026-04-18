import 'package:injectable/injectable.dart';
import '../../../../core/core.dart';
import '../domain.dart';

@lazySingleton
class GetBoardsUseCase {

  GetBoardsUseCase(this._repository);
  final OnboardingRepositoryPort _repository;

  Future<Result<PaginatedResponse<Board>>> call(
    String countryId, {
    String? stateId,
    int limit = 20,
    String? startAfterId,
  }) {
    return _repository.getBoards(
      countryId,
      stateId: stateId,
      limit: limit,
      startAfterId: startAfterId,
    );
  }
}
