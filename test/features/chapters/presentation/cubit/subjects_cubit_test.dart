import 'dart:async';

import 'package:flutter_test/flutter_test.dart';
import 'package:formula_scholar/core/core.dart';
import 'package:formula_scholar/features/chapters/presentation/cubit/subjects_cubit.dart';
import 'package:formula_scholar/features/chapters/presentation/cubit/subjects_state.dart';
import 'package:formula_scholar/features/dashboard/domain/domain.dart';

void main() {
  group('SubjectsCubit', () {
    late _FakeCurriculumRepository curriculumRepository;
    CurriculumCubit? curriculumCubit;
    late _FakeDashboardRepository dashboardRepository;
    late GetSubjectsUseCase getSubjectsUseCase;
    SubjectsCubit? subjectsCubit;

    setUp(() {
      curriculumRepository = _FakeCurriculumRepository();
      dashboardRepository = _FakeDashboardRepository();
      getSubjectsUseCase = GetSubjectsUseCase(repository: dashboardRepository);
      curriculumCubit = null;
      subjectsCubit = null;
    });

    tearDown(() async {
      await subjectsCubit?.close();
      await curriculumCubit?.close();
      await curriculumRepository.dispose();
    });

    test('initializes with default empty state', () {
      curriculumCubit = CurriculumCubit(
        loadCurriculum: LoadCurriculumUseCase(curriculumRepository),
        saveCurriculum: SaveCurriculumUseCase(curriculumRepository),
        watchCurriculum: WatchCurriculumUseCase(curriculumRepository),
      );
      subjectsCubit = SubjectsCubit(getSubjectsUseCase, curriculumCubit!);

      expect(subjectsCubit!.state.status, SubjectsStatus.initial);
      expect(subjectsCubit!.state.subjects, isEmpty);
      expect(subjectsCubit!.state.errorMessage, isEmpty);
    });

    test(
      'immediately loads subjects when curriculum is already available on init',
      () async {
        const initialCurriculum = SelectedCurriculum(
          boardId: 'cbse',
          boardName: 'CBSE',
          gradeId: 'class_10',
          gradeLabel: '10th',
          gradeNumber: 10,
        );
        curriculumRepository.loadedCurriculum = initialCurriculum;

        curriculumCubit = CurriculumCubit(
          loadCurriculum: LoadCurriculumUseCase(curriculumRepository),
          saveCurriculum: SaveCurriculumUseCase(curriculumRepository),
          watchCurriculum: WatchCurriculumUseCase(curriculumRepository),
        );

        final mockSubjects = [
          const Subject(
            id: 'physics',
            name: 'Physics',
            category: 'Science',
            description: 'Physics formulas',
            imageUrl: 'https://example.com/physics.png',
            unitCount: 5,
            formulaCount: 20,
          ),
        ];
        dashboardRepository.subjectsResult = Success(mockSubjects);

        subjectsCubit = SubjectsCubit(getSubjectsUseCase, curriculumCubit!);
        subjectsCubit!.stream.listen((s) {});

        await Future<void>.delayed(const Duration(milliseconds: 50));

        expect(subjectsCubit!.state.status, SubjectsStatus.loaded);
        expect(subjectsCubit!.state.subjects, mockSubjects);
        expect(subjectsCubit!.state.errorMessage, isEmpty);
      },
    );

    test(
      'loads subjects when curriculum state transitions from null/loading to loaded',
      () async {
        curriculumCubit = CurriculumCubit(
          loadCurriculum: LoadCurriculumUseCase(curriculumRepository),
          saveCurriculum: SaveCurriculumUseCase(curriculumRepository),
          watchCurriculum: WatchCurriculumUseCase(curriculumRepository),
        );

        subjectsCubit = SubjectsCubit(getSubjectsUseCase, curriculumCubit!);
        subjectsCubit!.stream.listen((s) {});
        expect(subjectsCubit!.state.status, SubjectsStatus.initial);

        final mockSubjects = [
          const Subject(
            id: 'chemistry',
            name: 'Chemistry',
            category: 'Science',
            description: 'Chemistry formulas',
            imageUrl: 'https://example.com/chemistry.png',
            unitCount: 4,
            formulaCount: 15,
          ),
        ];
        dashboardRepository.subjectsResult = Success(mockSubjects);

        const curriculum = SelectedCurriculum(
          boardId: 'icse',
          boardName: 'ICSE',
          gradeId: 'class_9',
          gradeLabel: '9th',
          gradeNumber: 9,
        );
        curriculumRepository.loadedCurriculum = curriculum;

        curriculumCubit!.applyCurriculum(curriculum);

        await Future<void>.delayed(const Duration(milliseconds: 50));

        expect(subjectsCubit!.state.status, SubjectsStatus.loaded);
        expect(subjectsCubit!.state.subjects, mockSubjects);
      },
    );

    test('emits error status when loading subjects fails', () async {
      const curriculum = SelectedCurriculum(
        boardId: 'cbse',
        boardName: 'CBSE',
        gradeId: 'class_10',
        gradeLabel: '10th',
        gradeNumber: 10,
      );
      curriculumRepository.loadedCurriculum = curriculum;

      curriculumCubit = CurriculumCubit(
        loadCurriculum: LoadCurriculumUseCase(curriculumRepository),
        saveCurriculum: SaveCurriculumUseCase(curriculumRepository),
        watchCurriculum: WatchCurriculumUseCase(curriculumRepository),
      );

      const failure = ServerFailure(
        message: 'Failed to fetch subjects from firestore',
      );
      dashboardRepository.subjectsResult = const Error(failure);

      subjectsCubit = SubjectsCubit(getSubjectsUseCase, curriculumCubit!);
      subjectsCubit!.stream.listen((s) {});

      await Future<void>.delayed(const Duration(milliseconds: 50));

      expect(subjectsCubit!.state.status, SubjectsStatus.error);
      expect(subjectsCubit!.state.errorMessage, failure.message);
    });

    test('resets to empty state when curriculum is cleared/null', () async {
      const curriculum = SelectedCurriculum(
        boardId: 'cbse',
        boardName: 'CBSE',
        gradeId: 'class_10',
        gradeLabel: '10th',
        gradeNumber: 10,
      );
      curriculumRepository.loadedCurriculum = curriculum;

      curriculumCubit = CurriculumCubit(
        loadCurriculum: LoadCurriculumUseCase(curriculumRepository),
        saveCurriculum: SaveCurriculumUseCase(curriculumRepository),
        watchCurriculum: WatchCurriculumUseCase(curriculumRepository),
      );

      dashboardRepository.subjectsResult = const Success([]);
      subjectsCubit = SubjectsCubit(getSubjectsUseCase, curriculumCubit!);
      subjectsCubit!.stream.listen((s) {});

      await Future<void>.delayed(const Duration(milliseconds: 50));
      expect(subjectsCubit!.state.status, SubjectsStatus.loaded);

      curriculumCubit!.clear();
      await Future<void>.delayed(const Duration(milliseconds: 50));

      expect(subjectsCubit!.state.subjects, isEmpty);
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
  Future<void> saveCurriculum(SelectedCurriculum? curriculum) async {
    loadedCurriculum = curriculum;
    _controller.add(curriculum);
  }

  @override
  Stream<SelectedCurriculum?> watchCurriculum() => _controller.stream;

  void emit(SelectedCurriculum? curriculum) {
    _controller.add(curriculum);
  }

  Future<void> dispose() => _controller.close();
}

class _FakeDashboardRepository implements DashboardRepositoryPort {
  Result<List<Subject>>? subjectsResult;

  @override
  Future<Result<List<Subject>>> getSubjects(
    String boardId,
    String gradeId,
  ) async {
    return subjectsResult ?? const Success([]);
  }

  @override
  Future<Result<List<AppAnnouncement>>> getActiveAnnouncements() async {
    return const Success([]);
  }

  @override
  Future<Result<List<CarouselItem>>> getBanners() async {
    return const Success([]);
  }

  @override
  Future<Result<List<RecentStudy>>> getRecentStudies() async {
    return const Success([]);
  }

  @override
  Future<Result<StudyProgress>> getStudyProgress() async {
    return const Success(
      StudyProgress(
        masteryPercentage: 0.0,
        completedChapters: 0,
        totalChapters: 0,
      ),
    );
  }

  @override
  Future<Result<List<WeakArea>>> getWeakAreas() async {
    return const Success([]);
  }
}
