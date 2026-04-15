import 'package:injectable/injectable.dart';

import '../../../../core/core.dart';
import '../ports/saved_repository_port.dart';

/// Removes a chapter bookmark for a subject in a curriculum scope.
@injectable
class RemoveSavedChapterUseCase {
  final SavedRepositoryPort _repository;

  const RemoveSavedChapterUseCase(this._repository);

  Future<Result<void>> call({
    required String curriculumKey,
    required String subjectId,
    required String chapterId,
  }) {
    return _repository.removeSavedChapter(
      curriculumKey: curriculumKey,
      subjectId: subjectId,
      chapterId: chapterId,
    );
  }
}
