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
  CardEntity _randomCardEntity = CardsFactory().createBlank();

  @override
  Widget build(BuildContext context) {
    LearnController().run(context);

    // Listen for change in case a card gets deleted
    Provider.of<CardsList>(context).cardsList;

    _setRandomCard();

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

  _randomCard() {
    return Expanded(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          FlashCard(
            cardEntity: _randomCardEntity,
          ),
        ],
      ),
    );
  }

  _learnButtons() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        ElevatedButton(
          style: ButtonStyle(
              backgroundColor: MaterialStateProperty.all<Color>(Colors.teal)),
          onPressed: () async {
            LearnController().run(context);
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
      _randomCardEntity =
          Provider.of<RandomCard>(context, listen: false).randomCard ??
              _randomCardEntity;
    });
  }
}
