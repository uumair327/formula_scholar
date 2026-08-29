import 'package:flutter_test/flutter_test.dart';
import 'package:formula_scholar/core/core.dart';
import 'package:formula_scholar/features/search/domain/domain.dart';

class _FakeSearchRepository implements SearchRepositoryPort {
  Result<List<SearchResult>> response = const Success([]);
  String? queried;
  String? curriculum;

  @override
  Future<Result<List<SearchResult>>> searchFormulas(
    String query, {
    String? curriculumKey,
  }) async {
    queried = query;
    curriculum = curriculumKey;
    return response;
  }
}

void main() {
  late _FakeSearchRepository fakeRepo;
  late SearchFormulasUseCase useCase;

  setUp(() {
    fakeRepo = _FakeSearchRepository();
    useCase = SearchFormulasUseCase(repository: fakeRepo);
  });

  test('calls repository with correct arguments and returns result', () async {
    const results = [
      SearchResult(
        id: 'f1',
        title: 'Sphere Volume',
        latex: r'\frac{4}{3}\pi r^3',
        description: 'Volume of sphere',
        subjectId: 'math',
        subjectName: 'Mathematics',
        chapterId: 'geometry',
        chapterName: 'Geometry',
      ),
    ];
    fakeRepo.response = const Success(results);

    final result = await useCase('sphere', curriculumKey: 'cbse_10');

    expect(fakeRepo.queried, 'sphere');
    expect(fakeRepo.curriculum, 'cbse_10');
    expect(result, const Success(results));
  });
}
