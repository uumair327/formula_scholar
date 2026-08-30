import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:formula_scholar/features/saved/domain/domain.dart';
import 'package:formula_scholar/features/saved/presentation/cubit/saved_cubit.dart';
import 'package:formula_scholar/features/saved/presentation/cubit/saved_state.dart';
import 'package:formula_scholar/features/saved/presentation/widgets/vault_subject_filter.dart';
import 'package:formula_scholar/l10n/app_localizations.dart';

class FakeSavedCubit extends Cubit<SavedState> implements SavedCubit {
  FakeSavedCubit([super.initialState = const SavedState()]);

  String? lastSubjectFilter;

  @override
  void setSubjectFilter(String? subject) {
    lastSubjectFilter = subject;
    emit(state.copyWith(selectedSubjectFilter: subject));
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
    BookmarkedFormula(
      id: 'f2',
      title: 'Newton Second Law',
      formula: 'F = ma',
      subject: 'Physics',
      savedAt: DateTime(2026, 1, 2),
      curriculumKey: 'cbse_9',
    ),
  ];

  group('VaultSubjectFilter Widget Tests', () {
    testWidgets('renders Subject indicator, All pill, and individual subjects with counts',
        (tester) async {
      final state = SavedState(
        status: SavedStatus.loaded,
        bookmarks: testBookmarks,
      );

      final fakeCubit = FakeSavedCubit(state);

      await tester.pumpWidget(
        MaterialApp(
          localizationsDelegates: AppLocalizations.localizationsDelegates,
          supportedLocales: AppLocalizations.supportedLocales,
          home: Scaffold(
            body: BlocProvider<SavedCubit>.value(
              value: fakeCubit,
              child: const VaultSubjectFilter(),
            ),
          ),
        ),
      );

      expect(find.text('Subject'), findsOneWidget);
      expect(find.text('All'), findsOneWidget);
      expect(find.text('Algebra'), findsOneWidget);
      expect(find.text('Physics'), findsOneWidget);
    });

    testWidgets('calls setSubjectFilter when a subject pill is tapped',
        (tester) async {
      final state = SavedState(
        status: SavedStatus.loaded,
        bookmarks: testBookmarks,
      );

      final fakeCubit = FakeSavedCubit(state);

      await tester.pumpWidget(
        MaterialApp(
          localizationsDelegates: AppLocalizations.localizationsDelegates,
          supportedLocales: AppLocalizations.supportedLocales,
          home: Scaffold(
            body: BlocProvider<SavedCubit>.value(
              value: fakeCubit,
              child: const VaultSubjectFilter(),
            ),
          ),
        ),
      );

      await tester.tap(find.text('Algebra'));
      await tester.pumpAndSettle();

      expect(fakeCubit.lastSubjectFilter, 'Algebra');
    });
  });
}
