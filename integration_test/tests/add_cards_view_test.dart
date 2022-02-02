import 'package:flash_clouds_app/main.dart' as app;
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';

import '../elements/bottom_navbar_finder.dart';

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  group('Test ADD CARDS View', () {
    testWidgets('Test ADD CARDS View - First Load',
        (WidgetTester tester) async {
      app.main();
      await tester.pumpAndSettle();
      await goToAddCardsView(tester);

      // Blanc Card and Empty Text Form
      expect(find.byIcon(Icons.delete_outlined), findsNWidgets(2));
      expect(find.text(''), findsNWidgets(4));

      // Description below the card
      expect(find.text('Last added card'), findsOneWidget);

      // Find Add Card Form Text
      expect(find.text('Card front'), findsOneWidget);
      expect(find.text('Card back'), findsOneWidget);
      expect(find.text('Question'), findsOneWidget);
      expect(find.text('Answer'), findsOneWidget);
      expect(find.text('Add'), findsOneWidget);
      final formField = find.byType(TextFormField);
      expect(formField, findsNWidgets(2));

      findBottomNavBar();
    });

    testWidgets(
        'Test ADD CARDS View - Add two cards, '
        'tap one from both sides and delete them', (WidgetTester tester) async {
      app.main();
      await tester.pumpAndSettle();
      await goToAddCardsView(tester);

      // Enter Text in Form Field
      final formField = find.byType(TextFormField);
      await tester.enterText(formField.first, 'Sample Question');
      await tester.enterText(formField.last, 'Sample Answer');
      await tester.tap(find.widgetWithText(ElevatedButton, 'Add'));
      await tester.pumpAndSettle();

      // Check last added card
      expect(find.text('Sample Question'), findsOneWidget);
      expect(find.text('Sample Answer'), findsOneWidget);

      // Tap Card from both sides
      await tester.tap(find.text('Sample Question'));
      await tester.pumpAndSettle();
      await tester.tap(find.text('Sample Answer'));
      await tester.pumpAndSettle();

      // Enter Text in Form Field
      await tester.enterText(formField.first, 'Sample Question 2');
      await tester.enterText(formField.last, 'Sample Answer 2');
      await tester.tap(find.widgetWithText(ElevatedButton, 'Add'));
      await tester.pumpAndSettle();

      // Check last added card
      expect(find.text('Sample Question 2'), findsOneWidget);
      expect(find.text('Sample Answer 2'), findsOneWidget);

      // Delete last added card
      await tester.tap(find.byIcon(Icons.delete_outlined).first);
      await tester.pumpAndSettle();

      // Check last added card
      expect(find.text('Sample Question'), findsOneWidget);
      expect(find.text('Sample Answer'), findsOneWidget);

      // Delete last added card
      await tester.tap(find.byIcon(Icons.delete_outlined).first);
      await tester.pumpAndSettle();

      // Check last added card
      expect(find.text(''), findsNWidgets(4));
    });
  });
}
