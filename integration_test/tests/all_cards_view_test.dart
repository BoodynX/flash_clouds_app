import 'package:flash_clouds_app/main.dart' as app;
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';

import '../elements/bottom_navbar_finder.dart';

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  group('Test ALL CARDS View', () {
    testWidgets('Test ALL CARDS View - First Load',
        (WidgetTester tester) async {
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
  });
}
