import 'package:flutter_test/flutter_test.dart';

import 'tests/all_cards_view_test.dart' as all_cards_view;
import 'tests/elements/add_test_card.dart/add_cards_view_test.dart'
    as add_cards_view;
import 'tests/learn_view_test.dart' as learn_view;

void main() {
  group('learn_view', () {
    learn_view.main();
  });

  group('add_cards_view', () {
    add_cards_view.main();
  });

  group('all_cards_view', () {
    all_cards_view.main();
  });
}
