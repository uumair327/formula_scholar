import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:formula_scholar/core/core.dart';
import 'package:formula_scholar/features/search/domain/domain.dart';
import 'package:formula_scholar/features/search/presentation/cubit/search_cubit.dart';
import 'package:formula_scholar/features/search/presentation/cubit/search_state.dart';
import 'package:formula_scholar/features/search/presentation/pages/search_page.dart';
import 'package:formula_scholar/features/search/presentation/widgets/search_result_card.dart';
import 'package:formula_scholar/l10n/app_localizations.dart';
import 'package:formula_scholar/shared/widgets/app_mascot.dart';

class FakeSearchCubit extends Cubit<SearchState> implements SearchCubit {
  FakeSearchCubit([super.initialState = const SearchState()]);

  String? lastSearchedQuery;

  @override
  void search(String query, {String? curriculumKey}) {
    lastSearchedQuery = query;
    emit(state.copyWith(query: query, status: SearchStatus.loading));
  }

  @override
  void clearSearch() {
    lastSearchedQuery = '';
    emit(const SearchState());
  }

  @override
  dynamic noSuchMethod(Invocation invocation) => super.noSuchMethod(invocation);
}

class FakeCurriculumCubit extends Cubit<CurriculumState>
    implements CurriculumCubit {
  FakeCurriculumCubit() : super(const CurriculumState());

  @override
  dynamic noSuchMethod(Invocation invocation) => super.noSuchMethod(invocation);
}

void main() {
  group('SearchPage Widget Tests', () {
    testWidgets(
        'renders Search input, Sigma mascot, speech bubble, and quick topics',
        (tester) async {
      final fakeSearchCubit = FakeSearchCubit();
      final fakeCurriculumCubit = FakeCurriculumCubit();

      await tester.pumpWidget(
        MultiBlocProvider(
          providers: [
            BlocProvider<SearchCubit>.value(value: fakeSearchCubit),
            BlocProvider<CurriculumCubit>.value(value: fakeCurriculumCubit),
          ],
          child: const MaterialApp(
            localizationsDelegates: AppLocalizations.localizationsDelegates,
            supportedLocales: AppLocalizations.supportedLocales,
            home: SearchPage(),
          ),
        ),
      );

      expect(find.byType(TextField), findsOneWidget);
      expect(find.byType(AppMascot), findsOneWidget);
      expect(find.text('What formula are we solving today? 🦉'), findsOneWidget);
      expect(find.text('Explore Formulas & Concepts'), findsOneWidget);
      expect(find.text('Quick Search Topics'), findsOneWidget);
      expect(find.text('Quadratic Formula'), findsOneWidget);
      expect(find.text('Trigonometry'), findsOneWidget);
    });

    testWidgets('tapping a suggested topic triggers search with term',
        (tester) async {
      final fakeSearchCubit = FakeSearchCubit();
      final fakeCurriculumCubit = FakeCurriculumCubit();

      await tester.pumpWidget(
        MultiBlocProvider(
          providers: [
            BlocProvider<SearchCubit>.value(value: fakeSearchCubit),
            BlocProvider<CurriculumCubit>.value(value: fakeCurriculumCubit),
          ],
          child: const MaterialApp(
            localizationsDelegates: AppLocalizations.localizationsDelegates,
            supportedLocales: AppLocalizations.supportedLocales,
            home: SearchPage(),
          ),
        ),
      );

      await tester.tap(find.text('Quadratic Formula'));
      await tester.pump(const Duration(milliseconds: 100));

      expect(fakeSearchCubit.lastSearchedQuery, 'Quadratic');
    });

    testWidgets('renders search results when state is loaded', (tester) async {
      const testResults = [
        SearchResult(
          id: 'f1',
          title: 'Roots of Quadratic Equation',
          latex: r'x = \frac{-b \pm \sqrt{b^2-4ac}}{2a}',
          description: 'Standard formula for solving quadratic equations',
          chapterId: 'ch1',
          chapterName: 'Quadratic Equations',
          subjectId: 'sub1',
          subjectName: 'Algebra',
        ),
      ];

      final fakeSearchCubit = FakeSearchCubit(
        const SearchState(
          status: SearchStatus.loaded,
          query: 'quadratic',
          results: testResults,
        ),
      );
      final fakeCurriculumCubit = FakeCurriculumCubit();

      await tester.pumpWidget(
        MultiBlocProvider(
          providers: [
            BlocProvider<SearchCubit>.value(value: fakeSearchCubit),
            BlocProvider<CurriculumCubit>.value(value: fakeCurriculumCubit),
          ],
          child: const MaterialApp(
            localizationsDelegates: AppLocalizations.localizationsDelegates,
            supportedLocales: AppLocalizations.supportedLocales,
            home: SearchPage(),
          ),
        ),
      );

      await tester.pump(const Duration(milliseconds: 100));

      expect(find.byType(SearchResultCard), findsOneWidget);
      expect(find.text('Found 1 formula'), findsOneWidget);
    });
  });
}
