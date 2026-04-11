import 'dart:async';

import 'package:flutter_test/flutter_test.dart';
import 'package:hydrated_bloc/hydrated_bloc.dart';

import 'package:formula_scholar/shared/cubit/subject_selection_cubit.dart';
import 'package:formula_scholar/shared/domain/domain.dart';

void main() {
  group('SubjectSelectionCubit', () {
    late _FakeStorage storage;
    late _FakeCurriculumRepository repository;
    late SubjectSelectionCubit cubit;

    setUp(() {
      storage = _FakeStorage();
      HydratedBloc.storage = storage;
      repository = _FakeCurriculumRepository();
      cubit = SubjectSelectionCubit(
        watchCurriculum: WatchCurriculumUseCase(repository),
      );
    });

    tearDown(() async {
      await cubit.close();
      await repository.dispose();
    });

    test('clears selected subject when curriculum changes', () async {
      repository.emit(
        const SelectedCurriculum(
          boardId: 'cbse',
          boardName: 'CBSE',
          gradeId: 'class_9',
          gradeLabel: '9th',
          gradeNumber: 9,
        ),
      );
      await Future<void>.delayed(Duration.zero);

      cubit.selectSubject(
        id: 'math',
        name: 'Mathematics',
        category: 'math',
        description: 'Core mathematics',
      );

      repository.emit(
        const SelectedCurriculum(
          boardId: 'icse',
          boardName: 'ICSE',
          gradeId: 'class_10',
          gradeLabel: '10th',
          gradeNumber: 10,
        ),
      );
      await Future<void>.delayed(Duration.zero);

      expect(cubit.state.hasSelection, isFalse);
      expect(cubit.state.availableSubjects, isEmpty);
      expect(cubit.state.curriculumKey, 'icse::class_10');
    });

    test('keeps selected subject when curriculum key still matches', () async {
      repository.emit(
        const SelectedCurriculum(
          boardId: 'cbse',
          boardName: 'CBSE',
          gradeId: 'class_9',
          gradeLabel: '9th',
          gradeNumber: 9,
        ),
      );
      await Future<void>.delayed(Duration.zero);

      cubit.selectSubject(
        id: 'phy',
        name: 'Physics',
        category: 'science',
        description: 'Motion and force',
      );

      repository.emit(
        const SelectedCurriculum(
          boardId: 'cbse',
          boardName: 'CBSE',
          gradeId: 'class_9',
          gradeLabel: '9th',
          gradeNumber: 9,
        ),
      );
      await Future<void>.delayed(Duration.zero);

      expect(cubit.state.subject?.id, 'phy');
      expect(cubit.state.curriculumKey, 'cbse::class_9');
    });
  });
}

class _FakeCurriculumRepository implements CurriculumRepositoryPort {
  final StreamController<SelectedCurriculum?> _controller =
      StreamController<SelectedCurriculum?>.broadcast();

  @override
  Future<SelectedCurriculum?> loadCurriculum() async => null;

  @override
  Future<void> saveCurriculum(SelectedCurriculum curriculum) async {}

  @override
  Stream<SelectedCurriculum?> watchCurriculum() => _controller.stream;

  void emit(SelectedCurriculum? curriculum) {
    _controller.add(curriculum);
  }

  Future<void> dispose() => _controller.close();
}

class _FakeStorage implements Storage {
  final Map<String, dynamic> _storage = <String, dynamic>{};

  @override
  Future<void> clear() async => _storage.clear();

  @override
  Future<void> close() async {}

  @override
  Future<void> delete(String key) async => _storage.remove(key);

  @override
  dynamic read(String key) => _storage[key];

  @override
  Future<void> write(String key, dynamic value) async {
    _storage[key] = value;
  }
}
