library;

import 'package:injectable/injectable.dart';

import '../../../../core/core.dart';
import '../ports/chapters_repository_port.dart';

@injectable
class IsChapterBookmarkedUseCase {
  const IsChapterBookmarkedUseCase(this._repository);

  final ChaptersRepositoryPort _repository;

  Future<Result<bool>> call({
    required String chapterId,
    required String subjectId,
    required String curriculumKey,
  }) {
    return _repository.isChapterBookmarked(
      chapterId,
      subjectId: subjectId,
      curriculumKey: curriculumKey,
    );
  }
}
