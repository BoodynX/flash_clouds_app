import 'package:flash_clouds_app/domain/entities/card_entity.dart';
import 'package:flash_clouds_app/domain/enums/familiarity.dart';
import 'package:flash_clouds_app/domain/repositories/i_cards_repository.dart';
import 'package:flash_clouds_app/infra/factories/cards_factory.dart';
import 'package:localstore/localstore.dart';

class CardsRepository implements ICardsRepository {
  Localstore ls = Localstore.instance;
  CardsFactory factory = CardsFactory();
  String collection = 'cards';

  @override
  Future<List<CardEntity>> getAll() async {
    return await ls.collection(collection).get().then((data) {
      List<CardEntity> cards = [];

      // TODO maybe some more data validation
      // in case of data corruption this will crash
      if (data == null) {
        cards.add(CardsFactory().createBlank());
        return cards;
      }

      for (MapEntry item in data.entries) {
        Map values = item.value;

        cards.add(factory.create(
            stripDbKeyToId(item.key),
            values['front'],
            values['back'],
            DateTime.parse(values['created']),
            values['lastKnown'] == 'null' || values['lastKnown'] == null
                ? null
                : DateTime.parse(values['lastKnown']),
            familiarityByVal(values['familiarity'])));
      }

      if (cards.isEmpty) {
        cards.add(CardsFactory().createBlank());
      }

      return cards;
    });
  }

  @override
  Future<List<CardEntity>> getAllSortByDate() async {
    List<CardEntity> cards = await getAll();
    cards.sort(_sortByCreate);

    return cards;
  }

  @override
  Future<CardEntity> getLatest() async {
    List<CardEntity> cards = await getAll();
    cards.sort(_sortByCreate);

    return cards.last;
  }

  @override
  Future<void> save(CardEntity card) async {
    if (card.isEmpty) {
      return;
    }

    // This is needed for editing, because ls doesn't update records
    await ls.collection(collection).doc(card.id).delete();

    await ls.collection(collection).doc(card.id).set({
      'front': card.front,
      'back': card.back,
      'created': card.created.toString(),
      'lastKnown': card.lastKnown.toString(),
      'familiarity': card.familiarity.toString(),
    });
  }

  @override
  Future<void> delete(List<String> ids) async {
    for (String id in ids) {
      await ls.collection(collection).doc(id).delete();
    }
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

  String stripDbKeyToId(String dbId) {
    // Strip id from the prefix added by the local storage package
    // 2 for slashes before after
    int trimAmount = collection.length + 2;

    return dbId.substring(trimAmount);
  }
}
