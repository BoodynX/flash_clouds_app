import 'package:flash_clouds_app/domain/entities/card_entity.dart';
import 'package:flash_clouds_app/domain/factories/i_cards_factory.dart';
import 'package:flash_clouds_app/infra/local_db/cards_repository.dart';
import 'package:flutter/material.dart';

class CardsFactory implements ICardsFactory {
  @override
  CardEntity create(String id, String front, String back, DateTime _created,
      DateTime? lastKnown) {
    return CardEntity(CardsRepository(), id, front, back, _created, lastKnown);
  }

  @override
  CardEntity createNew(String front, String back) {
    return CardEntity(CardsRepository(), UniqueKey().toString(), front, back,
        DateTime.now(), null);
  }

  @override
  CardEntity createBlank() {
    return CardEntity(CardsRepository(), '', '', '', DateTime.now(), null,
        isEmpty: true);
  }
}
