import 'package:flash_clouds_app/domain/entities/card_entity.dart';
import 'package:flash_clouds_app/domain/enums/familiarity.dart';
import 'package:flash_clouds_app/domain/repositories/i_cards_repository.dart';
import 'package:flash_clouds_app/domain/services/lottery_machine.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import 'lottery_machine_test.mocks.dart';

CardEntity makeBlackCard() {
  return CardEntity(MockICardsRepository(), '', '', '', DateTime.now(), null,
      Familiarity.none,
      isEmpty: true);
}

CardEntity makeNewCard(String front, String back,
    [Familiarity familiarity = Familiarity.none]) {
  return CardEntity(MockICardsRepository(), UniqueKey().toString(), front, back,
      DateTime.now(), null, familiarity,
      isEmpty: false);
}

CardEntity copyCard(CardEntity card) {
  return CardEntity(MockICardsRepository(), card.id, card.front, card.back,
      card.created, card.lastKnown, Familiarity.none,
      isEmpty: card.isEmpty);
}

@GenerateMocks([ICardsRepository])
void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  group('Lottery Machine', () {
    test('Try to draw from empty set', () async {
      var repo = MockICardsRepository();
      when(repo.getAll()).thenAnswer((_) => Future(() => [makeBlackCard()]));

      var lm = LotteryMachine(repo);
      CardEntity card = await lm.drawCard(null);

      expect(card.isEmpty, true);
    });

    test('Draw first card', () async {
      var repo = MockICardsRepository();
      when(repo.getAll())
          .thenAnswer((_) => Future(() => [makeNewCard('front', 'back')]));

      var lm = LotteryMachine(repo);
      CardEntity card = await lm.drawCard(null);

      expect(card.front, 'front');
    });

    test('Draw one card twice', () async {
      CardEntity theOnlyCard = makeNewCard('front', 'back');
      var repo = MockICardsRepository();
      when(repo.getAll()).thenAnswer((_) => Future(() => [theOnlyCard]));

      var lm = LotteryMachine(repo);
      CardEntity card1 = await lm.drawCard(null);
      CardEntity card2 = await lm.drawCard(card1);

      expect(card1.id, card2.id);
    });

    test('Draw 3 times from 2 cards and do not repeat the same card in a row',
        () async {
      CardEntity newCard1 = makeNewCard('front1', 'back1');
      CardEntity newCard2 = makeNewCard('front2', 'back2');
      var repo = MockICardsRepository();
      when(repo.getAll()).thenAnswer((_) => Future(() => [newCard1, newCard2]));

      var lm = LotteryMachine(repo);
      CardEntity card1 = await lm.drawCard(null);
      CardEntity card2 = await lm.drawCard(copyCard(card1));
      CardEntity card3 = await lm.drawCard(copyCard(card2));

      expect(card1.id != card2.id, true);
      expect(card2.id != card3.id, true);
      expect(card1.id == card3.id, true);
    });

    test('Draw 3 times from 2 cards and do not repeat the same card in a row',
        () async {
      CardEntity newCard1 = makeNewCard('front1', 'back1');
      CardEntity newCard2 = makeNewCard('front2', 'back2');
      var repo = MockICardsRepository();
      when(repo.getAll()).thenAnswer((_) => Future(() => [newCard1, newCard2]));

      var lm = LotteryMachine(repo);
      CardEntity card1 = await lm.drawCard(null);
      CardEntity card2 = await lm.drawCard(copyCard(card1));
      CardEntity card3 = await lm.drawCard(copyCard(card2));

      expect(card1.id != card2.id, true);
      expect(card2.id != card3.id, true);
      expect(card1.id == card3.id, true);
    });
  });
}
