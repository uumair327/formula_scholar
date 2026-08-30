import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:formula_scholar/features/saved/domain/domain.dart';
import 'package:formula_scholar/features/saved/presentation/cubit/saved_cubit.dart';
import 'package:formula_scholar/features/saved/presentation/cubit/saved_state.dart';
import 'package:formula_scholar/features/saved/presentation/widgets/saved_sort_controls.dart';
import 'package:formula_scholar/l10n/app_localizations.dart';

class FakeSavedCubit extends Cubit<SavedState> implements SavedCubit {
  FakeSavedCubit([super.initialState = const SavedState()]);

  String? lastSortedField;
  SortDirection? lastSortedDirection;

  @override
  void updateSort({required String sortByField, SortDirection? sortDirection}) {
    lastSortedField = sortByField;
    lastSortedDirection = sortDirection;
    emit(state.copyWith(sortByField: sortByField, sortDirection: sortDirection));
  }

  @override
  dynamic noSuchMethod(Invocation invocation) => super.noSuchMethod(invocation);
}

void main() {
  final testBookmarks = [
    BookmarkedFormula(
      id: 'f1',
      title: 'Roots of Quadratic Equation',
      formula: 'x = (-b ± sqrt(b^2-4ac))/2a',
      subject: 'Algebra',
      savedAt: DateTime(2026, 1, 1),
      curriculumKey: 'cbse_9',
    ),
  ];

  group('SavedSortControls Widget Tests', () {
    testWidgets('renders sort category badge and all 4 sort options',
        (tester) async {
      final state = SavedState(
        status: SavedStatus.loaded,
        bookmarks: testBookmarks,
        sortByField: 'savedAt',
        sortDirection: SortDirection.desc,
      );

      final fakeCubit = FakeSavedCubit(state);

      await tester.pumpWidget(
        MaterialApp(
          localizationsDelegates: AppLocalizations.localizationsDelegates,
          supportedLocales: AppLocalizations.supportedLocales,
          home: Scaffold(
            body: BlocProvider<SavedCubit>.value(
              value: fakeCubit,
              child: SavedSortControls(state: state),
            ),
          ),
        ),
      );

      expect(find.text('Sort'), findsOneWidget);
      expect(find.text('Newest'), findsOneWidget);
      expect(find.text('Oldest'), findsOneWidget);
      expect(find.text('Title A-Z'), findsOneWidget);
      expect(find.text('Title Z-A'), findsOneWidget);
    });

    testWidgets('calls updateSort when a sort pill is tapped', (tester) async {
      final state = SavedState(
        status: SavedStatus.loaded,
        bookmarks: testBookmarks,
        sortByField: 'savedAt',
        sortDirection: SortDirection.desc,
      );

      final fakeCubit = FakeSavedCubit(state);

      await tester.pumpWidget(
        MaterialApp(
          localizationsDelegates: AppLocalizations.localizationsDelegates,
          supportedLocales: AppLocalizations.supportedLocales,
          home: Scaffold(
            body: BlocProvider<SavedCubit>.value(
              value: fakeCubit,
              child: SavedSortControls(state: state),
            ),
          ),
        ),
      );

      await tester.tap(find.text('Title A-Z'));
      await tester.pumpAndSettle();

      expect(fakeCubit.lastSortedField, 'title');
      expect(fakeCubit.lastSortedDirection, SortDirection.asc);
    });
  });
}
