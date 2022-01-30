import 'package:flash_clouds_app/domain/entities/card_entity.dart';
import 'package:flash_clouds_app/domain/enums/familiarity.dart';
import 'package:flash_clouds_app/domain/factories/i_cards_factory.dart';
import 'package:flash_clouds_app/infra/local_db/cards_repository.dart';
import 'package:uuid/uuid.dart';

class CardsFactory implements ICardsFactory {
  @override
  CardEntity create(String id, String front, String back, DateTime _created,
      DateTime? lastKnown, Familiarity familiarity) {
    return CardEntity(
        CardsRepository(), id, front, back, _created, lastKnown, familiarity);
  }

  @override
  CardEntity createNew(String front, String back) {
    return CardEntity(CardsRepository(), const Uuid().v4().toString(), front,
        back, DateTime.now(), null, Familiarity.none);
  }

  @override
  CardEntity createBlank() {
    return CardEntity(
        CardsRepository(), '', '', '', DateTime.now(), null, Familiarity.none,
        isEmpty: true);
  }
}
