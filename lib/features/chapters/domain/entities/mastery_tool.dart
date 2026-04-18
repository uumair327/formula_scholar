import 'package:equatable/equatable.dart';

/// Backend-driven mastery tool configuration for a subject.
class MasteryTool extends Equatable {

  const MasteryTool({
    required this.id,
    required this.label,
    required this.iconName,
    required this.category,
    required this.isEnabled,
    this.supportSubtitle,
    required this.displayOrder,
    this.routeName,
  });
  final String id;
  final String label;
  final String iconName;
  final String category;
  final bool isEnabled;
  final String? supportSubtitle;
  final int displayOrder;
  final String? routeName;

  @override
  List<Object?> get props => [
    id,
    label,
    iconName,
    category,
    isEnabled,
    supportSubtitle,
    displayOrder,
    routeName,
  ];
}
