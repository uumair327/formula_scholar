import 'package:injectable/injectable.dart';

import '../../../core/core.dart';

@injectable
class WatchCurriculumUseCase {
  const WatchCurriculumUseCase(this._repository);
  final CurriculumRepositoryPort _repository;

  Stream<SelectedCurriculum?> call() {
    AppLogger.trace(
      'WatchCurriculumUseCase subscribed',
      tag: AppLogTags.curriculumUseCase,
    );
    return _repository.watchCurriculum();
  }
}
