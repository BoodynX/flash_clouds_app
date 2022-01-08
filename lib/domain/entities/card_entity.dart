import 'package:flutter/material.dart';

class CardEntity {
  String id;
  String front;
  String back;
  final DateTime created;
  DateTime? lastKnown;

  CardEntity(this.id, this.front, this.back, this.created, this.lastKnown);

  static CardEntity create(String front, String back) {
    return CardEntity(
        UniqueKey().toString(), front, back, DateTime.now(), null);
  }
}
