import 'package:equatable/equatable.dart';

/// A single settings menu item.
///
/// Uses [iconName] (a String) instead of `IconData` to keep the domain
/// layer free of Flutter framework dependencies (Clean Architecture).
class SettingsItem extends Equatable {
  final String id;
  final String label;
  final String iconName;
  final String? subtitle;
  final bool isToggle;
  final bool isDestructive;

  const SettingsItem({
    required this.id,
    required this.label,
    required this.iconName,
    this.subtitle,
    this.isToggle = false,
    this.isDestructive = false,
  });

  @override
  List<Object?> get props => [id, label];
}
