import 'package:flutter_test/flutter_test.dart';

Future<void> tapCard(WidgetTester tester, String front, String back) async {
  await tester.tap(find.text(front));
  await tester.pumpAndSettle();
  await tester.tap(find.text(back));
  await tester.pumpAndSettle();
}
