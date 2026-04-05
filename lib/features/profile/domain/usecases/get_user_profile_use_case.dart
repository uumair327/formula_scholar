import 'package:injectable/injectable.dart';

import '../../../../core/core.dart';
import '../entities/user_profile.dart';
import '../ports/profile_repository_port.dart';

/// Fetches the user's profile information.
///
/// Single-responsibility use case following SOLID principles.
@injectable
class GetUserProfileUseCase {
  final ProfileRepositoryPort _repository;

  const GetUserProfileUseCase({required ProfileRepositoryPort repository})
    : _repository = repository;

  /// Executes the use case.
  Future<Result<UserProfile>> call() {
    AppLogger.trace(
      'GetUserProfileUseCase called',
      tag: AppLogTags.profileCubit,
    );
    return _repository.getUserProfile();
  }
}
