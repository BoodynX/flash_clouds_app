import 'package:flash_clouds_app/domain/entities/card_entity.dart';
import 'package:flash_clouds_app/domain/enums/familiarity.dart';

abstract class ICardsFactory {
  CardEntity create(String id, String front, String back, DateTime _created,
      DateTime? lastKnown, Familiarity familiarity);

  CardEntity createNew(String front, String back);

  CardEntity createBlank();
}
