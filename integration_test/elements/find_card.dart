import 'package:flutter_test/flutter_test.dart';

void findCard(String front, String back) {
  expect(find.text(front), findsOneWidget);
  expect(find.text(back), findsOneWidget);
}

void notFindCard(String front, String back) {
  expect(find.text(front), findsNothing);
  expect(find.text(back), findsNothing);
}
