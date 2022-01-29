import 'package:flash_clouds_app/domain/entities/card_entity.dart';
import 'package:flash_clouds_app/infra/controllers/learn_controller.dart';
import 'package:flash_clouds_app/infra/data_structures/cards_list.dart';
import 'package:flash_clouds_app/infra/data_structures/random_card.dart';
import 'package:flash_clouds_app/infra/factories/cards_factory.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'elements/flash_card.dart';

class Learn extends StatefulWidget {
  const Learn({Key? key}) : super(key: key);

  @override
  _LearnState createState() => _LearnState();
}

class _LearnState extends State<Learn> {
  CardEntity _lastCard = CardsFactory().createBlank();
  List<CardEntity?> _cardsList = [];

  @override
  Widget build(BuildContext context) {
    print('VIEW Learn');
    _setRandomCard();
    _setRandomCardOnFirstLoad();

    // Listen for change in case a card gets deleted
    _cardsList = Provider.of<CardsList>(context).cardsList;

    return _buildView();
  }

  Padding _buildView() {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child:
          Column(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
        _randomCard(),
        _learnButtons(),
        const SizedBox(
          height: 20.0,
        )
      ]),
    );
  }

  Expanded _randomCard() {
    return Expanded(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          FlashCard(
            cardEntity: _lastCard,
          ),
        ],
      ),
    );
  }

  Column _learnButtons() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        ElevatedButton(
          style: ButtonStyle(
              backgroundColor: MaterialStateProperty.all<Color>(Colors.teal)),
          onPressed: () async {
            await LearnController().run(context, _lastCard);
            _setRandomCard();
          },
          child: const Text('Draw'),
        ),
        const SizedBox(
          width: 10.0,
        ),
      ],
    );
  }

  void _setRandomCard() {
    setState(() {
      _lastCard = Provider.of<RandomCard>(context, listen: false).randomCard ??
          _lastCard;
    });
  }

  void _setRandomCardOnFirstLoad() {
    // TODO remove this someday
    if (_cardsList.isNotEmpty && _cardsList[0] != null) {
      bool some = _cardsList[0]?.isEmpty as bool;
      _cardsList = some ? [] : _cardsList;
    }

    if (_lastCard.isEmpty && _cardsList.isNotEmpty) {
      LearnController().run(context, _lastCard).then((randomCard) {
        setState(() {
          _lastCard = randomCard;
        });
      });
    }
  }
}
