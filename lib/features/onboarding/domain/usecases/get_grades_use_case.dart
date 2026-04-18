import 'package:injectable/injectable.dart';
import '../../../../core/core.dart';
import '../domain.dart';

@lazySingleton
class GetGradesUseCase {

  GetGradesUseCase(this._repository);
  final OnboardingRepositoryPort _repository;

  Future<Result<PaginatedResponse<Grade>>> call(
    String boardId, {
    int limit = 20,
    String? startAfterId,
  }) {
    return _repository.getGrades(
      boardId,
      limit: limit,
      startAfterId: startAfterId,
    );
  }
}
