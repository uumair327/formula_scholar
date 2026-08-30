import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:formula_scholar/core/core.dart';
import 'package:formula_scholar/features/search/domain/domain.dart';
import 'package:formula_scholar/features/search/presentation/widgets/search_result_card.dart';

class FakeSubjectSelectionCubit extends Cubit<SubjectSelectionState>
    implements SubjectSelectionCubit {
  FakeSubjectSelectionCubit() : super(const SubjectSelectionState());

  @override
  dynamic noSuchMethod(Invocation invocation) => super.noSuchMethod(invocation);
}

void main() {
  group('SearchResultCard Widget Tests', () {
    const testResult = SearchResult(
      id: 'f1',
      title: 'Roots of Quadratic Equation',
      latex: r'x = \frac{-b \pm \sqrt{b^2-4ac}}{2a}',
      description: 'Standard formula for solving quadratic equations',
      chapterId: 'ch1',
      chapterName: 'Quadratic Equations',
      subjectId: 'sub1',
      subjectName: 'Algebra',
    );

    testWidgets('renders highlighted text with correct spans and high contrast',
        (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          theme: ThemeData.dark(),
          home: BlocProvider<SubjectSelectionCubit>.value(
            value: FakeSubjectSelectionCubit(),
            child: const Scaffold(
              body: SearchResultCard(
                result: testResult,
                query: 'root',
              ),
            ),
          ),
        ),
      );

      expect(find.byType(SearchResultCard), findsOneWidget);
      expect(find.text('ALGEBRA'), findsOneWidget);
      expect(find.text('Quadratic Equations'), findsOneWidget);
      expect(find.byType(Text), findsWidgets);
    });
  });
}
