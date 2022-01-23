import 'package:flash_clouds_app/domain/entities/card_entity.dart';
import 'package:flash_clouds_app/infra/data_structures/cards_list.dart';
import 'package:flash_clouds_app/infra/views/mixins/refresh_cards_list.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'elements/flash_card.dart';

class CardsManager extends StatefulWidget {
  const CardsManager({Key? key}) : super(key: key);

  @override
  _CardsManagerState createState() => _CardsManagerState();
}

class _CardsManagerState extends State<CardsManager> with RefreshCardsList {
  @override
  Widget build(BuildContext context) {
    refreshCardsList(context);

    return ListView(
      children: _buildCardsWidgetsList(context),
    );
  }

  _buildCardsWidgetsList(context) {
    List<Widget> cardWidgets = [];
    List<CardEntity?> cardsList = Provider.of<CardsList>(context).cardsList;
    cardWidgets.add(const SizedBox(height: 10.0));

    for (CardEntity? card in cardsList) {
      if (card == null) {
        continue;
      }

      Padding paddedFlashCard = Padding(
        padding: const EdgeInsets.symmetric(horizontal: 8.0),
        child: FlashCard(cardEntity: card),
      );
      cardWidgets.add(const SizedBox(height: 10.0));
      cardWidgets.add(paddedFlashCard);
    }

    cardWidgets.add(const SizedBox(height: 10.0));

    return cardWidgets;
  }
}
