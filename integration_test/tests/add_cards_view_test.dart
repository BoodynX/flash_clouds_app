import 'package:flash_clouds_app/main.dart' as app;
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';

import '../elements/add_test_card.dart';
import '../elements/bottom_navbar_finder.dart';
import '../elements/find_card.dart';
import '../elements/tap_card.dart';

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  group('Test ADD CARDS View', () {
    testWidgets('Test ADD CARDS View. First Load.',
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
      expect(find.byType(TextFormField), findsNWidgets(2));

      findBottomNavBar();
    });

    testWidgets(
        'Test ADD CARDS View. Add two cards, '
        'tap one from both sides and delete them.',
        (WidgetTester tester) async {
      app.main();
      await tester.pumpAndSettle();
      // Enter Text in Form Field
      await addTestCard(tester, 'Sample Question', 'Sample Answer');

      // Check last added card, with tap
      findCard('Sample Question', 'Sample Answer');
      await tapCard(tester, 'Sample Question', 'Sample Answer');

      // Enter Text in Form Field
      await addTestCard(tester, 'Sample Question 2', 'Sample Answer 2');

      // Check last added card
      findCard('Sample Question 2', 'Sample Answer 2');

      // Delete last added card
      await tester.tap(find.byIcon(Icons.delete_outlined).first);
      await tester.pumpAndSettle();

      // Check last added card
      findCard('Sample Question', 'Sample Answer');

      // Delete last added card
      await tester.tap(find.byIcon(Icons.delete_outlined).first);
      await tester.pumpAndSettle();

      // Check last added card
      expect(find.text(''), findsNWidgets(4));
    });
  });
}
