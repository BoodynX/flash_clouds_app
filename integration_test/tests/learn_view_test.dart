import 'package:flash_clouds_app/main.dart' as app;
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';

import '../elements/bottom_navbar_finder.dart';

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  group('Test LEARN View', () {
    testWidgets('Test LEARN View - First Load', (WidgetTester tester) async {
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

    testWidgets('Test LEARN View - Add One Card and Check the View',
        (WidgetTester tester) async {
      app.main();
      await tester.pumpAndSettle();
      await goToAddCardsView(tester);

      findBottomNavBar();
    });
  });
}
