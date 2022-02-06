import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'bottom_navbar_finder.dart';

Future<void> addTestCard(WidgetTester tester, String front, String back) async {
  await goToAddCardsView(tester);

  // Enter Text in Form Field
  final formField = find.byType(TextFormField);
  await tester.enterText(formField.first, front);
  await tester.enterText(formField.last, back);
  await tester.tap(find.widgetWithText(ElevatedButton, 'Add'));
  await tester.pumpAndSettle();
}
