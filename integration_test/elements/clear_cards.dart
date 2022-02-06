import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'bottom_navbar_finder.dart';

Future<void> clearCards(WidgetTester tester) async {
  await goToAllCardsView(tester);
  while (find.byIcon(Icons.delete_outlined).evaluate().isNotEmpty) {
    await tester.tap(find.byIcon(Icons.delete_outlined).first);
    await tester.pumpAndSettle();
  }
}
