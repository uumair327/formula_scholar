import 'package:injectable/injectable.dart';

import '../../../core/core.dart';
import '../entities/selected_curriculum.dart';
import '../ports/curriculum_repository_port.dart';

@injectable
class SaveCurriculumUseCase {
  const SaveCurriculumUseCase(this._repository);
  final CurriculumRepositoryPort _repository;

  Future<void> call(SelectedCurriculum curriculum) {
    AppLogger.trace(
      'SaveCurriculumUseCase called for ${curriculum.boardId}/${curriculum.gradeId}',
      tag: AppLogTags.curriculumUseCase,
    );
    return _repository.saveCurriculum(curriculum);
  }
}
