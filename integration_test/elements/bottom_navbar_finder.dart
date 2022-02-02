import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void findBottomNavBar() {
  expect(find.text('Learn'), findsOneWidget);
  expect(find.text('All Cards'), findsOneWidget);
  expect(find.text('Add New'), findsOneWidget);
}

Future<void> goToAddCardsView(WidgetTester tester) async {
  final addButton = find.byIcon(Icons.post_add_outlined);
  await tester.tap(addButton);
  await tester.pumpAndSettle();
}
