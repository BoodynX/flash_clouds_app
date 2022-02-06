import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void findBottomNavBar() {
  expect(find.text('Learn'), findsOneWidget);
  expect(find.text('All Cards'), findsOneWidget);
  expect(find.text('Add New'), findsOneWidget);
}

Future<void> goToAddCardsView(WidgetTester tester) async {
  await _tapAndPump(tester, find.byIcon(Icons.post_add_outlined));
}

Future<void> goToLearnView(WidgetTester tester) async {
  await _tapAndPump(tester, find.byIcon(Icons.school));
}

Future<void> goToAllCardsView(WidgetTester tester) async {
  await _tapAndPump(tester, find.byIcon(Icons.receipt_long));
}

Future<void> _tapAndPump(WidgetTester tester, Finder addButton) async {
  await tester.tap(addButton);
  await tester.pumpAndSettle();
}
