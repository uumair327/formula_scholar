import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:formula_scholar/features/saved/presentation/widgets/vault_tab_bar.dart';
import 'package:formula_scholar/l10n/app_localizations.dart';

void main() {
  group('VaultTabBar Widget Tests', () {
    testWidgets('renders all 3 tabs with correct labels and count badges',
        (tester) async {
      VaultTab selectedTab = VaultTab.formulas;

      await tester.pumpWidget(
        MaterialApp(
          localizationsDelegates: AppLocalizations.localizationsDelegates,
          supportedLocales: AppLocalizations.supportedLocales,
          home: Scaffold(
            body: VaultTabBar(
              selectedTab: selectedTab,
              onTabChanged: (tab) => selectedTab = tab,
              formulaCount: 12,
              chapterCount: 5,
              noteCount: 2,
            ),
          ),
        ),
      );

      expect(find.text('12'), findsOneWidget);
      expect(find.text('5'), findsOneWidget);
      expect(find.text('2'), findsOneWidget);
      expect(find.byType(VaultTabBar), findsOneWidget);
    });

    testWidgets('calls onTabChanged when a tab is tapped', (tester) async {
      VaultTab selectedTab = VaultTab.formulas;

      await tester.pumpWidget(
        MaterialApp(
          localizationsDelegates: AppLocalizations.localizationsDelegates,
          supportedLocales: AppLocalizations.supportedLocales,
          home: StatefulBuilder(
            builder: (context, setState) {
              return Scaffold(
                body: VaultTabBar(
                  selectedTab: selectedTab,
                  onTabChanged: (tab) => setState(() => selectedTab = tab),
                  formulaCount: 10,
                  chapterCount: 4,
                  noteCount: 1,
                ),
              );
            },
          ),
        ),
      );

      // Tap on Chapters tab (the second tab containing count '4')
      await tester.tap(find.text('4'));
      await tester.pumpAndSettle();

      expect(selectedTab, VaultTab.chapters);
    });
  });
}
