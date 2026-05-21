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
    this.audiences = const [],
    this.isGeneralContent = false,
    this.canonicalFormulaId,
    this.widgetConfig,
  });
  final String id;
  final String title;
  final String latex;
  final String description;
  final bool isMastered;
  final bool isBookmarked;
  final List<String> audiences;
  final bool isGeneralContent;
  final String? canonicalFormulaId;
  final Map<String, dynamic>? widgetConfig;

  Formula copyWith({
    String? id,
    String? title,
    String? latex,
    String? description,
    bool? isMastered,
    bool? isBookmarked,
    List<String>? audiences,
    bool? isGeneralContent,
    String? canonicalFormulaId,
    Map<String, dynamic>? widgetConfig,
  }) {
    return Formula(
      id: id ?? this.id,
      title: title ?? this.title,
      latex: latex ?? this.latex,
      description: description ?? this.description,
      isMastered: isMastered ?? this.isMastered,
      isBookmarked: isBookmarked ?? this.isBookmarked,
      audiences: audiences ?? this.audiences,
      isGeneralContent: isGeneralContent ?? this.isGeneralContent,
      canonicalFormulaId: canonicalFormulaId ?? this.canonicalFormulaId,
      widgetConfig: widgetConfig ?? this.widgetConfig,
    );
  }

  @override
  List<Object?> get props => [
    id,
    title,
    latex,
    isMastered,
    isBookmarked,
    canonicalFormulaId,
    widgetConfig,
  ];
}
