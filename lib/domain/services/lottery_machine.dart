import 'dart:math';

import 'package:flash_clouds_app/domain/entities/card_entity.dart';
import 'package:flash_clouds_app/domain/enums/familiarity.dart';
import 'package:flash_clouds_app/domain/repositories/i_cards_repository.dart';
import 'package:flash_clouds_app/infra/factories/cards_factory.dart';

class LotteryMachine {
  ICardsRepository repo;

  LotteryMachine(this.repo);

  Future<CardEntity> drawCard(CardEntity? previousCard) async {
    List<CardEntity> cards = await repo.getAll();

    if (cards[0].isEmpty || cards.length == 1) {
      return cards[0];
    }

    if (previousCard == null || previousCard.isEmpty) {
      return _drawRandomCardFromAll(cards);
    }

    return _drawNewRandomCard(cards, previousCard);
  }

  CardEntity _drawNewRandomCard(
      List<CardEntity> cards, CardEntity previousCard) {
    // Remove the current card from the lottery
    for (CardEntity card in cards) {
      bool cardsMatch = card.id == previousCard.id;
      if (cardsMatch) {
        cards.remove(card);
        break;
      }
    }

    return _drawRandomCardFromAll(cards);
  }

  CardEntity _drawRandomCardFromAll(List<CardEntity> cards) {
    final random = Random();

    int group = random.nextInt(20);

    Familiarity fami = Familiarity.none;
    if (group > 14) fami = Familiarity.medium;
    if (group > 18) fami = Familiarity.perfect;

    // Blanc card needed or else Dart will complain
    List<CardEntity> cardsCopy = [CardsFactory().createBlank()];

    for (CardEntity card in cards) {
      bool cardsMatch = card.familiarity == fami;
      if (cardsMatch) {
        cardsCopy.add(card);
      }
    }

    // Copy full list if nothing was added or Remove blanc card
    if (cardsCopy.length == 1) {
      cardsCopy = cards;
    } else {
      cardsCopy.removeAt(0);
    }

    return cardsCopy[random.nextInt(cardsCopy.length)];
  }
}
