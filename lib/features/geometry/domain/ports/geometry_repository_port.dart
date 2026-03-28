import '../../../../core/error/result.dart';
import '../entities/geometry_topic.dart';

/// Port: Defines the contract for geometry data access.
///
/// Primary hexagonal port with [Result] return types.
abstract interface class GeometryRepositoryPort {
  /// Fetches geometry topics with progress data.
  Future<Result<List<GeometryTopic>>> getTopics();
}
