import 'package:injectable/injectable.dart';

import '../../../../core/core.dart';
import '../entities/notification_preferences.dart';
import '../ports/profile_repository_port.dart';

/// Persists the current user's notification preferences.
@injectable
class UpdateNotificationPreferencesUseCase {
  final ProfileRepositoryPort _repository;

  const UpdateNotificationPreferencesUseCase({
    required ProfileRepositoryPort repository,
  }) : _repository = repository;

  Future<Result<void>> call(NotificationPreferences preferences) {
    AppLogger.trace(
      'UpdateNotificationPreferencesUseCase called',
      tag: AppLogTags.profileUseCase,
    );
    return _repository.updateNotificationPreferences(preferences);
  }
}
