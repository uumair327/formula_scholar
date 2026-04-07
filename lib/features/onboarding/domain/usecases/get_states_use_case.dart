import 'package:injectable/injectable.dart';
import '../../../../core/core.dart';
import '../domain.dart';

@lazySingleton
class GetStatesUseCase {
  final OnboardingRepositoryPort _repository;

  GetStatesUseCase(this._repository);

  Future<Result<PaginatedResponse<StateRegion>>> call(
    String countryId, {
    int limit = 20,
    String? startAfterId,
  }) {
    return _repository.getStates(
      countryId,
      limit: limit,
      startAfterId: startAfterId,
    );
  }
}
