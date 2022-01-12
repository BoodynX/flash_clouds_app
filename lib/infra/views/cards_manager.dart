import 'package:flash_clouds_app/domain/entities/card_entity.dart';
import 'package:flash_clouds_app/infra/local_db/cards_repository.dart';
import 'package:flutter/material.dart';

import 'elements/flash_card.dart';

class CardsManager extends StatefulWidget {
  const CardsManager({Key? key}) : super(key: key);

  @override
  _CardsManagerState createState() => _CardsManagerState();
}

class _CardsManagerState extends State<CardsManager> {
  List<Widget> _cardsWidgetsList = [];
  List<CardEntity?> _cardsList = [];

  @override
  Widget build(BuildContext context) {
    _refreshCardsList();
    _buildCardsWidgetsList();
    return ListView(
      children: _cardsWidgetsList,
    );
  }

  Future<void> _refreshCardsList() async {
    List<CardEntity?> cards = await CardsRepository().getAllSortByDate();

    if (cards == []) {
      return;
    }

    if (_cardsList.isNotEmpty && cards.last?.id == _cardsList.last?.id) {
      return;
    }

    setState(() {
      _cardsList = cards;
    });
  }

  _buildCardsWidgetsList() {
    List<Widget> cardWidgets = [];

    cardWidgets.add(const SizedBox(height: 10.0));

    for (CardEntity? card in _cardsList) {
      if (card == null) {
        continue;
      }

      FlashCard fc = FlashCard(
        cardEntity: card,
      );
      cardWidgets.add(const SizedBox(height: 10.0));
      cardWidgets.add(fc);
    }

    cardWidgets.add(const SizedBox(height: 10.0));

    setState(() {
      _cardsWidgetsList = cardWidgets;
    });
  }
}
