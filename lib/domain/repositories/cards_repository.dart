import 'package:flash_clouds_app/domain/entities/card_entity.dart';

abstract class CardsRepository {
  Future<List<CardEntity?>> getAll();

  Future<List<CardEntity?>> getAllSortByDate();

  Future<CardEntity?> getLatest();

  void save(CardEntity card);

  void delete(List<String> id);
}
