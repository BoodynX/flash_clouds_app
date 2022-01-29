import 'package:flash_clouds_app/domain/repositories/i_cards_repository.dart';

class CardEntity {
  String id = '';
  String front = '';
  String back = '';
  final DateTime _created;
  DateTime? lastKnown;
  bool isEmpty;

  ICardsRepository repo;

  CardEntity(
      this.repo, this.id, this.front, this.back, this._created, this.lastKnown,
      {this.isEmpty = false});

  DateTime get created {
    return _created;
  }

  void delete() {
    repo.delete([id]);
  }
}
