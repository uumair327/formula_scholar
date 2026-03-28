import 'package:equatable/equatable.dart';

/// Represents a subject in the curriculum.
class Subject extends Equatable {
  final String id;
  final String name;
  final String description;
  final String category;
  final String imageUrl;
  final int unitCount;
  final int formulaCount;

  const Subject({
    required this.id,
    required this.name,
    required this.description,
    required this.category,
    required this.imageUrl,
    required this.unitCount,
    required this.formulaCount,
  });

  @override
  List<Object?> get props => [id, name, category];
}
