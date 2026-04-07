import 'package:injectable/injectable.dart';
import '../../../../core/core.dart';
import '../domain.dart';

@lazySingleton
class GetCountriesUseCase {
  final OnboardingRepositoryPort _repository;

  GetCountriesUseCase(this._repository);

  Future<Result<PaginatedResponse<Country>>> call({
    int limit = 20,
    String? startAfterId,
  }) {
    return _repository.getCountries(limit: limit, startAfterId: startAfterId);
  }
}
