import 'package:injectable/injectable.dart';
import '../../../../core/core.dart';
import '../domain.dart';

@lazySingleton
class GetBoardsUseCase {
  final OnboardingRepositoryPort _repository;

  GetBoardsUseCase(this._repository);

  Future<Result<PaginatedResponse<Board>>> execute(String countryId, {String? stateId, int limit = 20, String? startAfterId}) {
    return _repository.getBoards(countryId, stateId: stateId, limit: limit, startAfterId: startAfterId);
  }
}
