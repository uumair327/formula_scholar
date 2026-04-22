import 'package:equatable/equatable.dart';

/// Status of a chapter within a subject.
enum ChapterStatus {
  /// Currently being studied (progress > 0).
  inProgress,

  /// Not yet started (progress == 0).
  notStarted,

  /// Locked – requires prerequisite completion.
  locked,
}

/// A generic chapter/topic within any subject.
///
/// This entity is **subject-agnostic** – the same structure represents
/// a geometry topic, an algebra section, a physics chapter, etc.
/// The backend determines the content; the UI renders generically.
class Chapter extends Equatable {

  const Chapter({
    required this.id,
    required this.name,
    required this.subtitle,
    required this.completedFormulas,
    required this.totalFormulas,
    required this.progressPercent,
    this.status = ChapterStatus.notStarted,
    this.isSaved = false,
    this.audiences = const [],
    this.isGeneralContent = false,
  });
  final String id;
  final String name;
  final String subtitle;
  final int completedFormulas;
  final int totalFormulas;
  final double progressPercent;
  final ChapterStatus status;
  final bool isSaved;
  final List<String> audiences;
  final bool isGeneralContent;

  bool get isInProgress => status == ChapterStatus.inProgress;
  bool get isLocked => status == ChapterStatus.locked;

  @override
  List<Object?> get props => [id, name, status, isSaved];
}
