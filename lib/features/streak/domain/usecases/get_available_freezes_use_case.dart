import 'package:injectable/injectable.dart';
import '../../../../core/core.dart';
import '../repositories/streak_repository.dart';

@injectable
class GetAvailableFreezesUseCase {
  const GetAvailableFreezesUseCase(this._repository);

  final StreakRepository _repository;

  Future<Result<int>> call() {
    return _repository.getAvailableFreezes();
  }
}
