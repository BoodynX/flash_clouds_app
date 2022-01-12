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
  Future<List<CardEntity?>> getAllSortByDate() async {
    List<CardEntity?> cards = await getAll();
    cards.sort(_sortByCreate);

    return cards;
  }

  @override
  Future<CardEntity?> getLatest() async {
    List<CardEntity?> cards = await getAll();
    cards.sort(_sortByCreate);

    return cards.last;
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

  int _sortByCreate(a, b) {
    return _paramsNotNull(a, b) ? a.created.compareTo(b.created) : 0;
  }

  bool _paramsNotNull(a, b) {
    if (a == null || b == null) {
      return false;
    }
    return true;
  }

  @override
  void delete(List<String> ids) async {
    for (String id in ids) {
      // TODO get rid of that "6"
      await ls.collection(collection).doc(id.substring(6)).delete();
    }
  }
}
