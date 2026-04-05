import 'package:equatable/equatable.dart';

/// A single item in the Formula Vault section.
///
/// Data-driven — the backend provides vault items and the UI
/// renders them without knowing specific subjects.
class FormulaVaultItem extends Equatable {
  final String id;
  final String label;
  final String title;

  const FormulaVaultItem({
    required this.id,
    required this.label,
    required this.title,
  });

  @override
  List<Object?> get props => [id, label, title];
}
