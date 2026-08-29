import 'package:flutter_test/flutter_test.dart';
import 'package:formula_scholar/core/core.dart';
import 'package:formula_scholar/features/search/domain/domain.dart';
import 'package:formula_scholar/features/search/presentation/cubit/search_cubit.dart';
import 'package:formula_scholar/features/search/presentation/cubit/search_state.dart';

class _FakeSearchFormulasUseCase extends SearchFormulasUseCase {
  _FakeSearchFormulasUseCase()
    : super(
        repository: _FakeSearchRepository(),
      );

  Result<List<SearchResult>> response = const Success([]);
  String? lastQuery;
  String? lastCurriculumKey;

  @override
  Future<Result<List<SearchResult>>> call(
    String query, {
    String? curriculumKey,
  }) async {
    lastQuery = query;
    lastCurriculumKey = curriculumKey;
    return response;
  }
}

class _FakeSearchRepository implements SearchRepositoryPort {
  @override
  Future<Result<List<SearchResult>>> searchFormulas(
    String query, {
    String? curriculumKey,
  }) async {
    return const Success([]);
  }
}

void main() {
  late _FakeSearchFormulasUseCase fakeUseCase;
  late SearchCubit cubit;

  setUp(() {
    fakeUseCase = _FakeSearchFormulasUseCase();
    cubit = SearchCubit(searchFormulas: fakeUseCase);
  });

  tearDown(() {
    cubit.close();
  });

  const testResults = [
    SearchResult(
      id: 'f1',
      title: 'Surface Area of Sphere',
      latex: r'4\pi r^2',
      description: 'Formula for sphere surface area',
      subjectId: 'math',
      subjectName: 'Mathematics',
      chapterId: 'mensuration',
      chapterName: 'Mensuration',
    ),
  ];

  test('initial state is correct', () {
    expect(cubit.state, const SearchState());
    expect(cubit.state.status, SearchStatus.initial);
    expect(cubit.state.results, isEmpty);
  });

  test('empty or whitespace query clears search state', () async {
    cubit.search('   ');
    expect(cubit.state.status, SearchStatus.initial);
    expect(cubit.state.results, isEmpty);
  });

  test('search emits loading then loaded when use case succeeds', () async {
    fakeUseCase.response = const Success(testResults);

    cubit.search('sphere');
    expect(cubit.state.status, SearchStatus.loading);
    expect(cubit.state.query, 'sphere');

    await Future<void>.delayed(const Duration(milliseconds: 450));

    expect(cubit.state.status, SearchStatus.loaded);
    expect(cubit.state.results, testResults);
    expect(fakeUseCase.lastQuery, 'sphere');
  });

  test('search emits error when use case fails', () async {
    fakeUseCase.response = const Error(
      ServerFailure(message: 'Search failed'),
    );

    cubit.search('sphere');
    await Future<void>.delayed(const Duration(milliseconds: 450));

    expect(cubit.state.status, SearchStatus.error);
    expect(cubit.state.errorMessage, 'Search failed');
  });

  test('clearSearch resets state', () {
    cubit.clearSearch();
    expect(cubit.state.status, SearchStatus.initial);
    expect(cubit.state.results, isEmpty);
  });
}
