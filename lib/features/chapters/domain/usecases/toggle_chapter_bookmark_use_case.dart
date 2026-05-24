library;

import 'package:injectable/injectable.dart';

import '../../../../core/core.dart';
import '../entities/chapter.dart';
import '../ports/chapters_repository_port.dart';

@injectable
class ToggleChapterBookmarkUseCase {
  const ToggleChapterBookmarkUseCase(this._repository);

  final ChaptersRepositoryPort _repository;

  Future<Result<void>> call({
    required Chapter chapter,
    required String subjectName,
    required String subjectId,
    required String curriculumKey,
  }) {
    return _repository.toggleChapterBookmark(
      chapter,
      subjectName,
      subjectId: subjectId,
      curriculumKey: curriculumKey,
    );
  }
}
