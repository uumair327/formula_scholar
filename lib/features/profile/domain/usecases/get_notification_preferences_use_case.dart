import 'package:injectable/injectable.dart';

import '../../../../core/core.dart';
import '../entities/notification_preferences.dart';
import '../ports/profile_repository_port.dart';

/// Fetches the current user's notification preferences.
@injectable
class GetNotificationPreferencesUseCase {
  final ProfileRepositoryPort _repository;

  const GetNotificationPreferencesUseCase({
    required ProfileRepositoryPort repository,
  }) : _repository = repository;

  Future<Result<NotificationPreferences>> call() {
    AppLogger.trace(
      'GetNotificationPreferencesUseCase called',
      tag: AppLogTags.profileUseCase,
    );
    return _repository.getNotificationPreferences();
  }
}
