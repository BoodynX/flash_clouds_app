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

  group('Test LEARN View', () {
    testWidgets('First Load', (WidgetTester tester) async {
      app.main();
      await tester.pumpAndSettle();

      // Blanc Card
      expect(find.byIcon(Icons.delete_outlined), findsNWidgets(2));
      expect(find.text(''), findsNWidgets(2));

      // Learn View Navigation
      expect(find.text('Familiarity'), findsOneWidget);
      expect(find.widgetWithText(ElevatedButton, 'Perfect'), findsOneWidget);
      expect(find.widgetWithText(ElevatedButton, 'Medium'), findsOneWidget);
      expect(find.widgetWithText(ElevatedButton, 'None'), findsOneWidget);

      findBottomNavBar();
    });

    testWidgets('Add One Card, tap it in Learn View, Delete Card.',
        (WidgetTester tester) async {
      app.main();
      await tester.pumpAndSettle();
      await addTestCard(tester, 'Sample Question', 'Sample Answer');
      await goToLearnView(tester);

      // Find the only added card, with tap
      findCard('Sample Question', 'Sample Answer');
      await tapCard(tester, 'Sample Question', 'Sample Answer');

      // Delete the only added card
      await tester.tap(find.byIcon(Icons.delete_outlined).first);
      await tester.pumpAndSettle();

      // Check if blanc card is left
      expect(find.text(''), findsNWidgets(2));
    });

    testWidgets(
        'Check removal of current Learn View card, '
        'from Add Cards View', (WidgetTester tester) async {
      app.main();
      await tester.pumpAndSettle();
      await addTestCard(tester, 'Sample Question', 'Sample Answer');
      await goToLearnView(tester);

      // Find the only added card
      findCard('Sample Question', 'Sample Answer');

      // Add another Card.
      await addTestCard(tester, 'Sample Question 2', 'Sample Answer 2');

      // Check if the card didn't change and change it
      await goToLearnView(tester);
      findCard('Sample Question', 'Sample Answer');
      await tester.tap(find.widgetWithText(ElevatedButton, 'Perfect').first);
      await tester.pumpAndSettle();
      findCard('Sample Question 2', 'Sample Answer 2');

      // Delete the last added card in the Add Cards View
      await goToAddCardsView(tester);
      await tester.tap(find.byIcon(Icons.delete_outlined).first);
      await tester.pumpAndSettle();

      // Check if the first card replaced the second in Lear View
      await goToLearnView(tester);
      findCard('Sample Question', 'Sample Answer');
    });
  });
}
