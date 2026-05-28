import 'package:injectable/injectable.dart';

import '../../../core/core.dart';

@LazySingleton(as: CurriculumRepositoryPort)
class CurriculumRepositoryImpl implements CurriculumRepositoryPort {
  const CurriculumRepositoryImpl(this._dataSource);
  final CurriculumDataSourcePort _dataSource;

  @override
  Future<SelectedCurriculum?> loadCurriculum() async {
    try {
      final curriculum = await _dataSource.loadCurriculum();
      AppLogger.info(
        'Curriculum loaded from repository: ${curriculum?.boardId ?? 'none'}',
        tag: AppLogTags.curriculumRepo,
      );
      return curriculum;
    } on Exception catch (error, stackTrace) {
      AppLogger.error(
        'Failed to load curriculum in repository',
        tag: AppLogTags.curriculumRepo,
        error: error,
        stackTrace: stackTrace,
      );
      throw const ServerException(message: 'Failed to load curriculum');
    }
  }

  @override
  Future<void> saveCurriculum(SelectedCurriculum curriculum) async {
    try {
      await _dataSource.saveCurriculum(curriculum);
      AppLogger.info(
        'Curriculum saved in repository: ${curriculum.boardId}/${curriculum.gradeId}',
        tag: AppLogTags.curriculumRepo,
      );
    } on Exception catch (error, stackTrace) {
      AppLogger.error(
        'Failed to save curriculum in repository',
        tag: AppLogTags.curriculumRepo,
        error: error,
        stackTrace: stackTrace,
      );
      throw const ServerException(message: 'Failed to save curriculum');
    }
  }

  @override
  Stream<SelectedCurriculum?> watchCurriculum() {
    return _dataSource.watchCurriculum().map((curriculum) {
      AppLogger.trace(
        'Curriculum stream event: ${curriculum?.boardId ?? 'none'}',
        tag: AppLogTags.curriculumRepo,
      );
      return curriculum;
    });
  }
}
