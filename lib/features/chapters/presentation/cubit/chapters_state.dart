import 'package:equatable/equatable.dart';

import '../../domain/domain.dart';

enum ChaptersStatus { initial, loading, loaded, error }

/// State for the generic Chapters feature.
class ChaptersState extends Equatable {
  final ChaptersStatus status;
  final String? subjectId;
  final List<Chapter> chapters;
  final String? errorMessage;

  const ChaptersState({
    this.status = ChaptersStatus.initial,
    this.subjectId,
    this.chapters = const [],
    this.errorMessage,
  });

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
    List<Chapter>? chapters,
    String? errorMessage,
  }) {
    return ChaptersState(
      status: status ?? this.status,
      subjectId: subjectId ?? this.subjectId,
      chapters: chapters ?? this.chapters,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }

  @override
  List<Object?> get props => [status, subjectId, chapters, errorMessage];
}
