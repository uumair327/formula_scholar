import 'package:equatable/equatable.dart';

/// Academic grade/class entity.
class Grade extends Equatable {
  final String id;
  final String label;
  final int classNumber;
  final String? subtitle;
  final bool isPopular;

  const Grade({
    required this.id,
    required this.label,
    required this.classNumber,
    this.subtitle,
    this.isPopular = false,
  });

  @override
  List<Object?> get props => [id, classNumber, isPopular];
}
