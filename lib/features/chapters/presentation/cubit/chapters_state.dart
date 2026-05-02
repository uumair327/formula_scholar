import 'package:equatable/equatable.dart';

import '../../domain/domain.dart';

const Object _unset = Object();

enum ChaptersStatus { initial, loading, loaded, error }

/// State for the generic Chapters feature.
///
/// Tracks sort-by-field and sort direction following golden rule:
/// Sorting authority is server-side (Firestore query).
class ChaptersState extends Equatable {
  const ChaptersState({
    this.status = ChaptersStatus.initial,
    this.subjectId,
    this.curriculumKey,
    this.searchQuery = '',
    this.sortBy = 'name',
    this.sortDesc = false,
    this.chapters = const [],
    this.masteryTools = const [],
    this.errorMessage,
  });
  final ChaptersStatus status;
  final String? subjectId;
  final String? curriculumKey;
  final String searchQuery;
  final String sortBy;
  final bool sortDesc;
  final List<Chapter> chapters;
  final List<MasteryTool> masteryTools;
  final String? errorMessage;

  /// The first chapter with [ChapterStatus.inProgress] (featured card).
  Chapter? get featuredChapter => chapters
      .where((c) => c.isInProgress)
      .fold<Chapter?>(
        null,
        (best, c) =>
            best == null || c.progressPercent > best.progressPercent ? c : best,
      );

  /// All chapters except the featured one.
  List<Chapter> get remainingChapters {
    final featured = featuredChapter;
    if (featured == null) return chapters;
    return chapters.where((c) => c.id != featured.id).toList();
  }

  ChaptersState copyWith({
    ChaptersStatus? status,
    String? subjectId,
    String? curriculumKey,
    String? searchQuery,
    String? sortBy,
    bool? sortDesc,
    List<Chapter>? chapters,
    List<MasteryTool>? masteryTools,
    Object? errorMessage = _unset,
  }) {
    return ChaptersState(
      status: status ?? this.status,
      subjectId: subjectId ?? this.subjectId,
      curriculumKey: curriculumKey ?? this.curriculumKey,
      searchQuery: searchQuery ?? this.searchQuery,
      sortBy: sortBy ?? this.sortBy,
      sortDesc: sortDesc ?? this.sortDesc,
      chapters: chapters ?? this.chapters,
      masteryTools: masteryTools ?? this.masteryTools,
      errorMessage: identical(errorMessage, _unset)
          ? this.errorMessage
          : errorMessage as String?,
    );
  }

  @override
  List<Object?> get props => [
    status,
    subjectId,
    curriculumKey,
    searchQuery,
    sortBy,
    sortDesc,
    chapters,
    masteryTools,
    errorMessage,
  ];
}
