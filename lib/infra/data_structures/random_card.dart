import 'package:flash_clouds_app/domain/entities/card_entity.dart';
import 'package:flutter/material.dart';

class RandomCard extends ChangeNotifier {
  CardEntity? randomCard;

  void updateCard(CardEntity? newRandomCard) {
    randomCard = newRandomCard;
    notifyListeners();
  }
}
