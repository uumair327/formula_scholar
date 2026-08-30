import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:formula_scholar/features/profile/domain/domain.dart';
import 'package:formula_scholar/features/profile/presentation/widgets/profile_hero_widget.dart';
import 'package:formula_scholar/l10n/app_localizations.dart';
import 'package:formula_scholar/shared/widgets/app_avatar.dart';
import 'package:formula_scholar/shared/widgets/app_mascot.dart';

void main() {
  group('ProfileHeroWidget Widget Tests', () {
    testWidgets('renders AppAvatar with mascot when avatarUrl is mascot string',
        (tester) async {
      final profile = UserProfile(
        name: 'Mohd Umair Ansari',
        email: 'uumair327@gmail.com',
        grade: 'Class 10',
        board: 'MSBSHSE',
        avatarUrl: 'mascot:happy',
        isPro: true,
        joinedAt: DateTime(2026, 4, 1),
      );

      await tester.pumpWidget(
        MaterialApp(
          localizationsDelegates: AppLocalizations.localizationsDelegates,
          supportedLocales: AppLocalizations.supportedLocales,
          home: Scaffold(
            body: ProfileHeroWidget(profile: profile),
          ),
        ),
      );

      expect(find.byType(ProfileHeroWidget), findsOneWidget);
      expect(find.byType(AppAvatar), findsOneWidget);
      expect(find.byType(AppMascot), findsOneWidget);
      expect(find.text('Mohd Umair Ansari'), findsOneWidget);
      expect(find.text('PRO'), findsOneWidget);
    });
  });
}
