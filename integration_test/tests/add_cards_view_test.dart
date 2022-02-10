import 'package:flash_clouds_app/main.dart' as app;
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';

import '../elements/add_test_card.dart';
import '../elements/bottom_navbar_finder.dart';
import '../elements/clear_cards.dart';
import '../elements/find_card.dart';
import '../elements/tap_card.dart';

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  group('Test ADD CARDS View', () {
    testWidgets('First Load.', (WidgetTester tester) async {
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

    testWidgets('Add two cards, tap one from both sides and delete them.',
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

    testWidgets('Check removal of last added card, from All Cards View',
        (WidgetTester tester) async {
      app.main();
      await tester.pumpAndSettle();
      await addTestCard(tester, 'Sample Question', 'Sample Answer');
      await addTestCard(tester, 'Sample Question 2', 'Sample Answer 2');

      // Delete the last added card in the All Cards View
      // We have to tap the one before last Trash Icon because the last one
      // is on the back side of the card, and the tester can't tap what is not
      // visible in the view port
      await goToAllCardsView(tester);
      await tester.tap(find.byIcon(Icons.delete_outlined).hitTestable().last);
      await tester.pumpAndSettle();

      // Check if the first card replaced the second in Lear View
      await goToAddCardsView(tester);
      findCard('Sample Question', 'Sample Answer');

      // Clean up
      await clearCards(tester);
    });

    testWidgets('Check removal of last added card, from Learn View',
        (WidgetTester tester) async {
      app.main();
      await tester.pumpAndSettle();
      await addTestCard(tester, 'Sample Question', 'Sample Answer');

      // Make sure the first card will be drawn in the Learn view
      await goToLearnView(tester);
      findCard('Sample Question', 'Sample Answer');

      await addTestCard(tester, 'Sample Question 2', 'Sample Answer 2');
      await goToLearnView(tester);

      // Press any Familiarity button to draw the second
      await tester.tap(find.widgetWithText(ElevatedButton, 'Perfect').first);
      await tester.pumpAndSettle();
      findCard('Sample Question 2', 'Sample Answer 2');

      // Delete the second card from the Learn View
      await tester.tap(find.byIcon(Icons.delete_outlined).first);
      await tester.pumpAndSettle();

      // Check if the first card replaced the second in Add Cards View
      await goToAddCardsView(tester);
      findCard('Sample Question', 'Sample Answer');

      // Clean up
      await clearCards(tester);
    });
  });
}
