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

  group('Test ALL CARDS', () {
    testWidgets('First Load', (WidgetTester tester) async {
      app.main();
      await tester.pumpAndSettle();
      final allCardsButton = find.byIcon(Icons.receipt_long);
      await tester.tap(allCardsButton);
      await tester.pumpAndSettle();

      // No blanc card in View
      expect(find.byIcon(Icons.delete_outlined), findsNothing);
      expect(find.text(''), findsNothing);

      findBottomNavBar();
    });

    testWidgets(
        'Add Two Cards, check if they are visible and flip '
        'in All Cards View.', (WidgetTester tester) async {
      app.main();
      await tester.pumpAndSettle();
      await addTestCard(tester, 'Sample Question', 'Sample Answer');
      await goToAllCardsView(tester);
      await addTestCard(tester, 'Sample Question 2', 'Sample Answer 2');
      await goToAllCardsView(tester);

      // Find first card
      findCard('Sample Question', 'Sample Answer');
      await tapCard(tester, 'Sample Question', 'Sample Answer');

      // Find second card
      findCard('Sample Question 2', 'Sample Answer 2');
      await tapCard(tester, 'Sample Question 2', 'Sample Answer 2');

      // Clean up
      await clearCards(tester);
    });

    testWidgets(
        'Add Two Cards, remove them in Add Cards View and then in Learn View '
        'and check if All Cards View refreshes after each delete',
        (WidgetTester tester) async {
      app.main();
      await tester.pumpAndSettle();
      await addTestCard(tester, 'Sample Question', 'Sample Answer');
      await goToAllCardsView(tester);
      await addTestCard(tester, 'Sample Question 2', 'Sample Answer 2');

      // Confirm cards in All Cards View
      await goToAllCardsView(tester);
      findCard('Sample Question', 'Sample Answer');
      findCard('Sample Question 2', 'Sample Answer 2');

      // Delete card from Add Cards View
      await goToAddCardsView(tester);
      await tester.tap(find.byIcon(Icons.delete_outlined).first);
      await tester.pumpAndSettle();

      // Check if All Cards View refreshed
      await goToAllCardsView(tester);
      findCard('Sample Question', 'Sample Answer');
      notFindCard('Sample Question 2', 'Sample Answer 2');

      // Delete card from Learn View
      await goToLearnView(tester);
      await tester.tap(find.byIcon(Icons.delete_outlined).first);
      await tester.pumpAndSettle();

      // Check if All Cards View refreshed
      await goToAllCardsView(tester);
      notFindCard('Sample Question', 'Sample Answer');
    });
  });
}
