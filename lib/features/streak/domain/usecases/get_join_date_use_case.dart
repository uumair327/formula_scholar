import 'package:injectable/injectable.dart';
import '../../../../core/core.dart';
import '../repositories/streak_repository.dart';

@injectable
class GetJoinDateUseCase {
  const GetJoinDateUseCase(this._repository);

  final StreakRepository _repository;

  Future<Result<DateTime?>> call() {
    return _repository.getJoinDate();
  }
}
