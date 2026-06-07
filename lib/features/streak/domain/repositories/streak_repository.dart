import '../../../../core/core.dart';
import '../entities/streak_history.dart';

abstract class StreakRepository {
  Future<Result<StreakHistoryMonth>> getMonthHistory(int year, int month);
  Future<Result<int>> getAvailableFreezes();
  Future<Result<DateTime?>> getJoinDate();
}
