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

  /// Canonical class label used across the app to avoid variant naming
  /// like "10th Grade" vs "Class 10".
  String get displayLabel {
    if (classNumber > 0) {
      return 'Class $classNumber';
    }

    final normalized = label.trim();
    return normalized.isEmpty ? 'Class' : normalized;
  }

  @override
  List<Object?> get props => [id, classNumber, isPopular];
}
