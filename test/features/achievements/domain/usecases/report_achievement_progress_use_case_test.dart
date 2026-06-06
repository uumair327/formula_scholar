import 'package:flutter_test/flutter_test.dart';

import 'package:formula_scholar/core/error/failures.dart';
import 'package:formula_scholar/core/error/result.dart';
import 'package:formula_scholar/features/achievements/domain/domain.dart';

void main() {
  group('ReportAchievementProgressUseCase', () {
    test('delegates reportProgress to repository', () async {
      final repository = _FakeAchievementRepository();
      final useCase = ReportAchievementProgressUseCase(repository: repository);

      final result = await useCase('first_mastered', 1);

      expect(result, isA<Success<void>>());
      expect(repository.lastId, 'first_mastered');
      expect(repository.lastIncrement, 1);
    });

    test('returns Error when repository fails', () async {
      final repository = _FakeAchievementRepository()..fail = true;
      final useCase = ReportAchievementProgressUseCase(repository: repository);

      final result = await useCase('ten_mastered', 5);

      expect(result, isA<Error<void>>());
    });
  });
}

class _FakeAchievementRepository implements AchievementRepositoryPort {
  bool fail = false;
  String? lastId;
  int? lastIncrement;

  @override
  Future<Result<List<Achievement>>> getAchievements() async {
    return const Success<List<Achievement>>(<Achievement>[]);
  }

  @override
  Future<Result<void>> reportProgress(
    String achievementId,
    int increment,
  ) async {
    lastId = achievementId;
    lastIncrement = increment;
    if (fail) {
      return const Error<void>(UnexpectedFailure(message: 'failed'));
    }
    return const Success<void>(null);
  }
}
