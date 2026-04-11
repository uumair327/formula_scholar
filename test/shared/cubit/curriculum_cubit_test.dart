import 'dart:async';

import 'package:flutter_test/flutter_test.dart';

import 'package:formula_scholar/shared/cubit/curriculum_cubit.dart';
import 'package:formula_scholar/shared/cubit/curriculum_state.dart';
import 'package:formula_scholar/shared/domain/domain.dart';

void main() {
  group('CurriculumCubit', () {
    late _FakeCurriculumRepository repository;
    late CurriculumCubit cubit;

    setUp(() {
      repository = _FakeCurriculumRepository();
      cubit = CurriculumCubit(
        loadCurriculum: LoadCurriculumUseCase(repository),
        saveCurriculum: SaveCurriculumUseCase(repository),
        watchCurriculum: WatchCurriculumUseCase(repository),
      );
    });

    tearDown(() async {
      await cubit.close();
      await repository.dispose();
    });

    test('refresh loads the persisted curriculum into state', () async {
      repository.loadedCurriculum = const SelectedCurriculum(
        boardId: 'icse',
        boardName: 'ICSE',
        gradeId: 'class_10',
        gradeLabel: '10th',
        gradeNumber: 10,
      );

      await cubit.refresh();

      expect(cubit.state.hasSelection, isTrue);
      expect(cubit.state.boardId, 'icse');
      expect(cubit.state.gradeId, 'class_10');
      expect(cubit.state.isLoading, isFalse);
      expect(cubit.state.isInitialized, isTrue);
    });

    test('null stream events clear selection without ghost defaults', () async {
      cubit.applyCurriculum(
        const SelectedCurriculum(
          boardId: 'cbse',
          boardName: 'CBSE',
          gradeId: 'class_9',
          gradeLabel: '9th',
          gradeNumber: 9,
        ),
      );

      repository.emit(null);
      await Future<void>.delayed(Duration.zero);

      expect(
        cubit.state,
        const CurriculumState(isLoading: false, isInitialized: true),
      );
      expect(cubit.state.hasSelection, isFalse);
      expect(cubit.state.boardId, isNull);
      expect(cubit.state.gradeId, isNull);
    });
  });
}

class _FakeCurriculumRepository implements CurriculumRepositoryPort {
  SelectedCurriculum? loadedCurriculum;
  final StreamController<SelectedCurriculum?> _controller =
      StreamController<SelectedCurriculum?>.broadcast();

  @override
  Future<SelectedCurriculum?> loadCurriculum() async => loadedCurriculum;

  @override
  Future<void> saveCurriculum(SelectedCurriculum curriculum) async {
    loadedCurriculum = curriculum;
  }

  @override
  Stream<SelectedCurriculum?> watchCurriculum() => _controller.stream;

  void emit(SelectedCurriculum? curriculum) {
    _controller.add(curriculum);
  }

  Future<void> dispose() => _controller.close();
}
