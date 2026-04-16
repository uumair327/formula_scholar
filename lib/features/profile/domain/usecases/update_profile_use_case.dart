import 'package:injectable/injectable.dart';

import '../../../../core/core.dart';
import '../ports/profile_repository_port.dart';

@injectable
class UpdateProfileUseCase {
  final ProfileRepositoryPort _repository;

  const UpdateProfileUseCase({required ProfileRepositoryPort repository})
    : _repository = repository;

  Future<Result<void>> call({required String name, required String avatarUrl}) {
    AppLogger.trace(
      'UpdateProfileUseCase called',
      tag: AppLogTags.profileUseCase,
    );
    return _repository.updateProfile(name: name, avatarUrl: avatarUrl);
  }
}
