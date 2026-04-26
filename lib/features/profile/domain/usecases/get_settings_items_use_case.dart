import 'package:injectable/injectable.dart';

import '../../../../core/core.dart';
import '../entities/settings_item.dart';
import '../ports/profile_repository_port.dart';

/// Fetches settings/menu items for the profile screen.
///
/// Single-responsibility use case following SOLID principles.
@injectable
class GetSettingsItemsUseCase {
  const GetSettingsItemsUseCase({required ProfileRepositoryPort repository})
    : _repository = repository;
  final ProfileRepositoryPort _repository;

  /// Executes the use case.
  Future<Result<List<SettingsItem>>> call() {
    AppLogger.trace(
      'GetSettingsItemsUseCase called',
      tag: AppLogTags.profileUseCase,
    );
    return _repository.getSettingsItems();
  }
}
