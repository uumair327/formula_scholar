import 'package:injectable/injectable.dart';

import '../../../../core/core.dart';
import '../ports/saved_repository_port.dart';

@injectable
class DeleteNoteUseCase {
  const DeleteNoteUseCase({required SavedRepositoryPort repository})
    : _repository = repository;
  final SavedRepositoryPort _repository;

  Future<Result<void>> call(String noteId) {
    AppLogger.trace(
      'DeleteNoteUseCase called: $noteId',
      tag: AppLogTags.savedUseCase,
    );
    return _repository.deleteNote(noteId);
  }
}
