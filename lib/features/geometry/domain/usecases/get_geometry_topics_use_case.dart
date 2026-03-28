import 'package:injectable/injectable.dart';

import '../../../../core/core.dart';
import '../entities/geometry_topic.dart';
import '../ports/geometry_repository_port.dart';

/// Fetches geometry topics.
///
/// Single-responsibility use case following SOLID principles.
@injectable
class GetGeometryTopicsUseCase {
  final GeometryRepositoryPort _repository;

  const GetGeometryTopicsUseCase({
    required GeometryRepositoryPort repository,
  }) : _repository = repository;

  /// Executes the use case.
  Future<Result<List<GeometryTopic>>> call() {
    AppLogger.trace(
      'GetGeometryTopicsUseCase called',
      tag: AppLogTags.geometryCubit,
    );
    return _repository.getTopics();
  }
}
