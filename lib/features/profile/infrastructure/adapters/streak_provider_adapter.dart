import 'package:injectable/injectable.dart';
import 'package:formula_scholar/core/core.dart';
import 'package:formula_scholar/shared/domain/ports/streak_provider_port.dart';
import 'package:formula_scholar/features/profile/domain/usecases/get_profile_stats_use_case.dart';
import 'package:formula_scholar/features/profile/domain/entities/profile_stat.dart';

@Injectable(as: StreakProviderPort)
class StreakProviderAdapter implements StreakProviderPort {
  const StreakProviderAdapter(this._getProfileStatsUseCase);

  final GetProfileStatsUseCase _getProfileStatsUseCase;

  @override
  Future<int> getCurrentStreak() async {
    final statsResult = await _getProfileStatsUseCase.call();
    if (statsResult is Success<List<ProfileStat>>) {
      final streakStat = statsResult.data
          .where((s) => s.id == 'streak')
          .firstOrNull;
      return int.tryParse(streakStat?.value ?? '0') ?? 0;
    }
    return 0;
  }
}
