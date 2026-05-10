import 'package:injectable/injectable.dart';

import '../../../../core/core.dart';
import '../models/announcement.dart';
import '../ports/dashboard_repository_port.dart';

@injectable
class GetAnnouncementsUseCase {
  const GetAnnouncementsUseCase({required DashboardRepositoryPort repository})
    : _repository = repository;
  final DashboardRepositoryPort _repository;

  Future<Result<List<AppAnnouncement>>> call() async {
    AppLogger.trace(
      'GetAnnouncementsUseCase called',
      tag: AppLogTags.dashboardUseCase,
    );
    final result = await _repository.getActiveAnnouncements();
    return switch (result) {
      Success(:final data) => _filterTimeWindow(data),
      Error(:final failure) => Error(failure),
    };
  }

  Success<List<AppAnnouncement>> _filterTimeWindow(List<AppAnnouncement> items) {
    final now = DateTime.now();
    final filtered = items.where((a) {
      if (a.publishAt != null) {
        final publishDate = DateTime.tryParse(a.publishAt!);
        if (publishDate != null && publishDate.isAfter(now)) return false;
      }
      if (a.expiresAt != null) {
        final expiryDate = DateTime.tryParse(a.expiresAt!);
        if (expiryDate != null && expiryDate.isBefore(now)) return false;
      }
      return true;
    }).toList();
    return Success(filtered);
  }
}
