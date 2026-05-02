import 'package:injectable/injectable.dart';

import '../../../../core/core.dart';
import '../entities/saved_note.dart';
import '../entities/saved_query.dart';
import '../ports/saved_repository_port.dart';

/// Fetches saved study notes for a curriculum.
@injectable
class GetSavedNotesUseCase {
  const GetSavedNotesUseCase({required SavedRepositoryPort repository})
    : _repository = repository;
  final SavedRepositoryPort _repository;

  Future<Result<List<SavedNote>>> call({
    required String curriculumKey,
    SavedQuery query = const SavedQuery(),
  }) {
    AppLogger.trace(
      'GetSavedNotesUseCase called',
      tag: AppLogTags.savedUseCase,
    );
    return _repository.getSavedNotes(
      curriculumKey: curriculumKey,
      query: query,
    );
  }
}
