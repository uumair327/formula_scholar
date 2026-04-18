import 'package:equatable/equatable.dart';

/// A single formula within a chapter.
///
/// This entity is **chapter-agnostic** — the same structure represents
/// any formula across any subject or chapter. The backend determines
/// the content; the UI renders generically.
class Formula extends Equatable {

  const Formula({
    required this.id,
    required this.title,
    required this.latex,
    required this.description,
    this.isMastered = false,
    this.isBookmarked = false,
  });
  final String id;
  final String title;
  final String latex;
  final String description;
  final bool isMastered;
  final bool isBookmarked;

  @override
  List<Object?> get props => [id, title, latex, isMastered, isBookmarked];
}
