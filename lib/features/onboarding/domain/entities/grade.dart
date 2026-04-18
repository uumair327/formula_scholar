import 'package:equatable/equatable.dart';

/// Academic grade/class entity.
class Grade extends Equatable {

  const Grade({
    required this.id,
    required this.label,
    required this.classNumber,
    this.subtitle,
    this.isPopular = false,
  });
  final String id;
  final String label;
  final int classNumber;
  final String? subtitle;
  final bool isPopular;

  @override
  List<Object?> get props => [id, classNumber, isPopular];
}
