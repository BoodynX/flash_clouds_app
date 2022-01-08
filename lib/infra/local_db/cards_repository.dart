import 'package:localstore/localstore.dart';

class CardsRepository {
  Localstore ls = Localstore.instance;
  String collection = 'cards';

  getAll() async {
    return ls.collection(collection).get();
  }

  add(front, back) async {
    final id = ls.collection(collection).doc().id;
    ls.collection(collection).doc(id).set({
      'front': front,
      'back': back,
      'created': DateTime.now().toString(),
      'lastTimeKnown': 'new',
    });
  }
}
