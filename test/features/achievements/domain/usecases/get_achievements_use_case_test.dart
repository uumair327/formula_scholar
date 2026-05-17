import 'package:flutter_test/flutter_test.dart';

import 'package:formula_scholar/core/error/failures.dart';
import 'package:formula_scholar/core/error/result.dart';
import 'package:formula_scholar/features/achievements/domain/domain.dart';

void main() {
  group('GetAchievementsUseCase', () {
    test('delegates to repository and returns achievements', () async {
      final repository = _FakeAchievementRepository();
      final useCase = GetAchievementsUseCase(repository: repository);

      final result = await useCase();

      expect(result, isA<Success<List<Achievement>>>());
      final data = (result as Success<List<Achievement>>).data;
      expect(data.length, 2);
      expect(data[0].id, 'first_mastered');
      expect(data[1].id, 'ten_mastered');
    });

    test('returns Error when repository fails', () async {
      final repository = _FakeAchievementRepository()
        ..fail = true;
      final useCase = GetAchievementsUseCase(repository: repository);

      final result = await useCase();

      expect(result, isA<Error<List<Achievement>>>());
    });
  });
}

class _FakeAchievementRepository implements AchievementRepositoryPort {
  bool fail = false;

  @override
  Future<Result<List<Achievement>>> getAchievements() async {
    if (fail) {
      return const Error<List<Achievement>>(
        UnexpectedFailure(message: 'failed'),
      );
    }
    return const Success<List<Achievement>>([
      Achievement(
        id: 'first_mastered',
        title: 'First Step',
        description: 'Master your first formula',
        tier: AchievementTier.bronze,
        target: 1,
      ),
      Achievement(
        id: 'ten_mastered',
        title: 'Getting Started',
        description: 'Master 10 formulas',
        tier: AchievementTier.silver,
        target: 10,
      ),
    ]);
  }

  @override
  Future<Result<void>> reportProgress(String achievementId, int increment) async {
    return const Success<void>(null);
  }
}
