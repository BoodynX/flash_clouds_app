import 'dart:math';

import 'package:flash_clouds_app/domain/entities/card_entity.dart';
import 'package:flash_clouds_app/domain/repositories/i_cards_repository.dart';

class LotteryMachine {
  ICardsRepository repo;

  LotteryMachine(this.repo);

  Future<CardEntity> drawCard(CardEntity? previousCard) async {
    List<CardEntity> cards = await repo.getAll();

    if (cards[0].isEmpty || cards.length == 1) {
      return cards[0];
    }

    if (previousCard == null) {
      return _drawRandomCardFromAll(cards);
    }

    return _drawNewRandomCard(cards, previousCard);
  }

  CardEntity _drawNewRandomCard(
      List<CardEntity> cards, CardEntity previousCard) {
    cards.remove(previousCard);
    return _drawRandomCardFromAll(cards);
  }

  CardEntity _drawRandomCardFromAll(List<CardEntity> cards) {
    final _random = Random();
    return cards[_random.nextInt(cards.length)];
  }
}
