import 'package:flash_clouds_app/domain/entities/card_entity.dart';

abstract class CardsRepository {
  Future<List<CardEntity?>> getAll();

  Future<List<CardEntity?>> getAllSortByDate();

  Future<CardEntity?> getLatest();

  // CardEntity getById(String id);

  void save(CardEntity card);
}
