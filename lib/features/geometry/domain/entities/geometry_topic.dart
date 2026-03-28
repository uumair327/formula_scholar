import 'package:equatable/equatable.dart';

/// A geometry topic (Triangles, Circles, etc.).
class GeometryTopic extends Equatable {
  final String id;
  final String name;
  final String subtitle;
  final int completedFormulas;
  final int totalFormulas;
  final double progressPercent;

  const GeometryTopic({
    required this.id,
    required this.name,
    required this.subtitle,
    required this.completedFormulas,
    required this.totalFormulas,
    required this.progressPercent,
  });

  @override
  List<Object?> get props => [id, name];
}
