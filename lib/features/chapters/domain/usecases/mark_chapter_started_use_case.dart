library;

import 'package:injectable/injectable.dart';

import '../ports/formulas_repository_port.dart';

@injectable
class MarkChapterStartedUseCase {
  const MarkChapterStartedUseCase(this._repository);

  final FormulasRepositoryPort _repository;

  Future<void> call({
    required String subjectId,
    required String chapterId,
    required String chapterName,
    required int totalFormulas,
  }) {
    return _repository.markChapterStarted(
      subjectId,
      chapterId,
      chapterName: chapterName,
      totalFormulas: totalFormulas,
    );
  }
}
