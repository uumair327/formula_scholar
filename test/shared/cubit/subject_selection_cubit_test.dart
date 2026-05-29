import 'dart:async';

import 'package:flutter_test/flutter_test.dart';
import 'package:hydrated_bloc/hydrated_bloc.dart';

import 'package:formula_scholar/core/core.dart';
import 'package:formula_scholar/features/dashboard/domain/domain.dart';

void main() {
  group('SubjectSelectionCubit', () {
    late _FakeStorage storage;
    late _FakeCurriculumRepository repository;
    late _FakeDashboardRepository dashboardRepository;
    late SubjectSelectionCubit cubit;

    setUp(() {
      storage = _FakeStorage();
      HydratedBloc.storage = storage;
      repository = _FakeCurriculumRepository();
      dashboardRepository = _FakeDashboardRepository();
      cubit = SubjectSelectionCubit(
        watchCurriculum: WatchCurriculumUseCase(repository),
        getSubjects: GetSubjectsUseCase(repository: dashboardRepository),
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
        iconName: 'sigma',
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
        iconName: 'zap',
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

    test('selects the first available subject when none is selected', () async {
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

      cubit.updateAvailableSubjects([
        const SelectedSubject(
          id: 'math',
          name: 'Mathematics',
          category: 'science',
          description: 'Core mathematics',
          iconName: 'sigma',
          subtitle: 'Numbers and equations',
          colorValue: 0xFFE67E22,
        ),
        const SelectedSubject(
          id: 'science',
          name: 'Science',
          category: 'science',
          description: 'Core science',
          iconName: 'flaskConical',
          colorValue: 0xFF7B68EE,
        ),
      ]);

      expect(cubit.state.availableSubjects, hasLength(2));
      expect(cubit.state.subject?.id, 'math');
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

class _FakeDashboardRepository implements DashboardRepositoryPort {
  @override
  Future<Result<List<CarouselItem>>> getBanners() async => const Success([]);

  @override
  Future<Result<StudyProgress>> getStudyProgress() async =>
      throw UnimplementedError();

  @override
  Future<Result<List<AppAnnouncement>>> getActiveAnnouncements() async =>
      const Success([]);

  @override
  Future<Result<List<RecentStudy>>> getRecentStudies() async =>
      const Success([]);

  @override
  Future<Result<List<Subject>>> getSubjects(
    String boardId,
    String gradeId,
  ) async => const Success([]);

  @override
  Future<Result<List<WeakArea>>> getWeakAreas() async => const Success([]);
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
