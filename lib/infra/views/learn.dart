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
  CardEntity? _randomCard;

  @override
  Widget build(BuildContext context) {
    LearnController().run(context);

    // Listen for change in case a card gets deleted
    Provider.of<CardsList>(context).cardsList;

    _setRandomCard();

    return _buildFlashCard();
  }

  Widget _buildFlashCard() {
    _randomCard ??= CardsFactory().createNew('', '');

    return Padding(
      padding: const EdgeInsets.all(8.0),
      child:
          Column(mainAxisAlignment: MainAxisAlignment.spaceAround, children: [
        Row(
          children: [
            Expanded(
              child: FlashCard(
                cardEntity: _randomCard!,
              ),
            ),
          ],
        ),
        Center(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              ElevatedButton(
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
          ),
        )
      ]),
    );
  }

  void _setRandomCard() {
    setState(() {
      _randomCard = Provider.of<RandomCard>(context, listen: false).randomCard;
    });
  }
}
