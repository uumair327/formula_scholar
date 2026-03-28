import '../entities/geometry_topic.dart';

/// Port: Defines the contract that any backend adapter must implement
/// for geometry content.
///
/// Driven port (secondary) in hexagonal terminology.
abstract interface class GeometryDataSourcePort {
  /// Fetches geometry topics with progress data.
  Future<List<GeometryTopic>> getTopics();
}
