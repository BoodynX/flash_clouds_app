import 'package:flash_clouds_app/domain/entities/card_entity.dart';
import 'package:flutter/material.dart';

class CardsList extends ChangeNotifier {
  List<CardEntity?> cardsList = [];

  void updateList(List<CardEntity?> newList) {
    cardsList = newList;
    notifyListeners();
  }
}
