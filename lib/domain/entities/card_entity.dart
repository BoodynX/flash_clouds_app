import 'package:flash_clouds_app/domain/enums/familiarity.dart';
import 'package:flash_clouds_app/domain/repositories/i_cards_repository.dart';

class CardEntity {
  String id = '';
  String front = '';
  String back = '';
  final DateTime created;
  DateTime? lastKnown;
  bool isEmpty;
  Familiarity familiarity = Familiarity.none;

  ICardsRepository repo;

  CardEntity(this.repo, this.id, this.front, this.back, this.created,
      this.lastKnown, this.familiarity,
      {this.isEmpty = false});

  void delete() {
    repo.delete([id]);
  }
}
