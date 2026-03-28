import 'package:flutter_test/flutter_test.dart';
import 'package:formula_scholar/main.dart';

void main() {
  testWidgets('App renders successfully', (WidgetTester tester) async {
    await tester.pumpWidget(const FormulaScholarApp());
    // Verify the app structure loads
    expect(find.byType(FormulaScholarApp), findsOneWidget);
  });
}
