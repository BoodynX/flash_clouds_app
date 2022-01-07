import 'package:localstore/localstore.dart';

class CardsRepository {
  Localstore ls = Localstore.instance;
  String collection = 'cards';

  getAll() async {
    return ls.collection(collection).get();
  }

  add(content) async {
    final id = ls.collection(collection).doc().id;
    ls.collection(collection).doc(id).set({
      'content': content,
      'created': DateTime.now().toString(),
      'lastTimeKnown': 'new',
    });
  }
}
