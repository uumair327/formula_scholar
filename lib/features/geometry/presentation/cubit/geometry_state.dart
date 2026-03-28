import 'package:equatable/equatable.dart';

import '../../domain/domain.dart';

enum GeometryStatus { initial, loading, loaded, error }

/// State for the Geometry feature.
class GeometryState extends Equatable {
  final GeometryStatus status;
  final List<GeometryTopic> topics;
  final String? errorMessage;

  const GeometryState({
    this.status = GeometryStatus.initial,
    this.topics = const [],
    this.errorMessage,
  });

  GeometryState copyWith({
    GeometryStatus? status,
    List<GeometryTopic>? topics,
    String? errorMessage,
  }) {
    return GeometryState(
      status: status ?? this.status,
      topics: topics ?? this.topics,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }

  @override
  List<Object?> get props => [status, topics, errorMessage];
}
