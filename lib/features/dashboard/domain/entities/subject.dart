import 'package:equatable/equatable.dart';

/// Represents a subject in the curriculum.
///
/// Contains all data needed to render a subject card in the UI,
/// including visual metadata (icon, colors, badge). This follows
/// the Open/Closed Principle — new subjects from the backend
/// render correctly without modifying the UI code.
class Subject extends Equatable {

  const Subject({
    required this.id,
    required this.name,
    required this.description,
    required this.category,
    required this.imageUrl,
    required this.unitCount,
    required this.formulaCount,
    this.iconName = 'book-open',
    this.colorValue = 0xFF00639A,
    this.badgeText,
    this.subtitle,
    this.masteryPercentage,
    this.lastViewed,
    this.isFeatured = false,
  });
  final String id;
  final String name;
  final String description;
  final String category;
  final String imageUrl;
  final int unitCount;
  final int formulaCount;

  // ── Visual metadata (driven by backend/adapter) ──
  /// Icon identifier (e.g. 'calculator', 'rocket', 'flask').
  /// Maps to Lucide icon names in the presentation layer.
  final String iconName;

  /// Primary color hex (e.g. '0xFF00639A').
  /// The card tints itself based on this color.
  final int colorValue;

  /// Optional badge text (e.g. 'CBSE 9 CURATED', 'GRADE 9').
  final String? badgeText;

  /// Optional subtitle displayed below the heading.
  final String? subtitle;

  /// Mastery percentage (0–100). Null if not yet tracked.
  final double? masteryPercentage;

  /// Last viewed timestamp string (e.g. '2 days ago').
  final String? lastViewed;

  /// Whether this subject is the "featured" / primary card.
  final bool isFeatured;

  @override
  List<Object?> get props => [id, name, category];
}
