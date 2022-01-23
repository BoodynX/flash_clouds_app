import 'package:flash_clouds_app/domain/entities/card_entity.dart';

abstract class ICardsFactory {
  CardEntity create(String id, String front, String back, DateTime _created,
      DateTime? lastKnown);

  CardEntity createNew(String front, String back);

  CardEntity createBlank();
}
