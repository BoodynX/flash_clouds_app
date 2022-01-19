import 'package:flash_clouds_app/domain/entities/card_entity.dart';
import 'package:flash_clouds_app/infra/data_structures/cards_list.dart';
import 'package:flash_clouds_app/infra/local_db/cards_repository.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'elements/flash_card.dart';

class CardsManager extends StatefulWidget {
  const CardsManager({Key? key}) : super(key: key);

  @override
  _CardsManagerState createState() => _CardsManagerState();
}

class _CardsManagerState extends State<CardsManager> {
  @override
  Widget build(BuildContext context) {
    _refreshCardsList();

    return ListView(
      children: _buildCardsWidgetsList(context),
    );
  }

  Future<List?> _refreshCardsList() async {
    List<CardEntity?> cards = await CardsRepository().getAllSortByDate();
    List<CardEntity?> cardsList =
        Provider.of<CardsList>(context, listen: false).cardsList;

    if (cards == []) {
      return [];
    }

    if (cardsList.isNotEmpty && cards.last?.id == cardsList.last?.id) {
      return [];
    }

    Provider.of<CardsList>(context, listen: false).updateList(cards);
  }

  _buildCardsWidgetsList(context) {
    List<Widget> cardWidgets = [];
    List<CardEntity?> cardsList = Provider.of<CardsList>(context).cardsList;
    cardWidgets.add(const SizedBox(height: 10.0));

    for (CardEntity? card in cardsList) {
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

    return cardWidgets;
  }
}
