import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:formula_scholar/core/core.dart';
import 'package:formula_scholar/shared/widgets/app_mascot.dart';
import 'package:formula_scholar/shared/widgets/mascot_painter.dart';
import 'package:formula_scholar/shared/widgets/mascot_speech_bubble.dart';

void main() {
  group('AppMascot Widget Tests', () {
    testWidgets('renders AppMascot with default happy mood', (tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: AppMascot(
              mood: MascotMood.happy,
              size: AppDimensions.mascotMD,
              animate: false,
            ),
          ),
        ),
      );

      expect(find.byType(AppMascot), findsOneWidget);
      expect(find.byType(CustomPaint), findsWidgets);
    });

    testWidgets('renders all MascotMood expressions without error',
        (tester) async {
      for (final mood in MascotMood.values) {
        await tester.pumpWidget(
          MaterialApp(
            home: Scaffold(
              body: AppMascot(
                mood: mood,
                size: AppDimensions.mascotMD,
                animate: false,
              ),
            ),
          ),
        );

        expect(find.byType(AppMascot), findsOneWidget);
      }
    });

    testWidgets('MascotSpeechBubble displays text message', (tester) async {
      const testMessage = 'Hello Scholar! 🦉';

      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: MascotSpeechBubble(message: testMessage),
          ),
        ),
      );

      expect(find.text(testMessage), findsOneWidget);
      expect(find.byType(MascotSpeechBubble), findsOneWidget);
    });
  });
}
