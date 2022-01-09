import 'package:flash_clouds_app/domain/entities/card_entity.dart';
import 'package:flash_clouds_app/domain/repositories/cards_repository.dart'
    as repositories;
import 'package:localstore/localstore.dart';

class CardsRepository implements repositories.CardsRepository {
  Localstore ls = Localstore.instance;
  String collection = 'cards';

  @override
  Future<List<CardEntity?>> getAll() async {
    return await ls.collection(collection).get().then((data) {
      // TODO maybe some more data validation
      // in case of data corruption this will crash
      if (data == null) {
        return [];
      }

      List<CardEntity> cards = [];

      for (MapEntry item in data.entries) {
        Map values = item.value;

        cards.add(CardEntity(
          item.key,
          values['front'],
          values['back'],
          DateTime.parse(values['created']),
          values['lastKnown'] == 'null' || values['lastKnown'] == null
              ? null
              : DateTime.parse(values['lastKnown']),
        ));
      }
      return cards;
    });
  }

  @override
  Future<void> save(CardEntity card) async {
    await ls.collection(collection).doc(card.id).set({
      'front': card.front,
      'back': card.back,
      'created': card.created.toString(),
      'lastKnown': card.lastKnown.toString(),
    });
  }

  @override
  Future<CardEntity?> getLatest() async {
    List<CardEntity?> cards = await getAll();
    cards.sort((a, b) {
      if (a == null || b == null) {
        return 0;
      }
      return a.created.compareTo(b.created);
    });

    return cards.last;
  }
}
