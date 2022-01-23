import 'dart:math';

import 'package:flash_clouds_app/domain/entities/card_entity.dart';
import 'package:flash_clouds_app/domain/repositories/i_cards_repository.dart';

class LotteryMachine {
  ICardsRepository repo;

  LotteryMachine(this.repo);

  Future<CardEntity?> drawCard() async {
    List<CardEntity?> cards = await repo.getAll();
    final _random = Random();

    return cards[_random.nextInt(cards.length)];
  }
}
