import 'package:injectable/injectable.dart';
import '../../../../core/core.dart';
import '../domain.dart';

@lazySingleton
class GetGradesUseCase {
  final OnboardingRepositoryPort _repository;

  GetGradesUseCase(this._repository);

  Future<Result<PaginatedResponse<Grade>>> execute(String boardId, {int limit = 20, String? startAfterId}) {
    return _repository.getGrades(boardId, limit: limit, startAfterId: startAfterId);
  }
}
