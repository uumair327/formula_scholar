import 'package:injectable/injectable.dart';
import '../../../../core/core.dart';
import '../entities/streak_history.dart';
import '../repositories/streak_repository.dart';

@injectable
class GetMonthHistoryUseCase {
  const GetMonthHistoryUseCase(this._repository);

  final StreakRepository _repository;

  Future<Result<StreakHistoryMonth>> call(int year, int month) {
    return _repository.getMonthHistory(year, month);
  }
}
