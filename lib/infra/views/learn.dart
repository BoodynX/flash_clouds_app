import 'package:flash_clouds_app/domain/entities/card_entity.dart';
import 'package:flash_clouds_app/domain/enums/familiarity.dart';
import 'package:flash_clouds_app/infra/controllers/learn_controller.dart';
import 'package:flash_clouds_app/infra/data_structures/cards_list.dart';
import 'package:flash_clouds_app/infra/data_structures/random_card.dart';
import 'package:flash_clouds_app/infra/factories/cards_factory.dart';
import 'package:flash_clouds_app/infra/local_db/cards_repository.dart';
import 'package:flash_clouds_app/infra/views/mixins/refresh_cards_list.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'elements/flash_card.dart';

class Learn extends StatefulWidget {
  const Learn({Key? key}) : super(key: key);

  @override
  _LearnState createState() => _LearnState();
}

class _LearnState extends State<Learn> with RefreshCardsList {
  CardEntity _lastCard = CardsFactory().createBlank();
  List<CardEntity?> _cardsList = [];

  @override
  Widget build(BuildContext context) {
    refreshGlobalCardsList(context);
    _cardsList = Provider.of<CardsList>(context).cardsList;
    _setRandomCard();
    _setRandomCardOnFirstLoad();

    return _buildView();
  }

  Padding _buildView() {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child:
          Column(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
        _randomCard(),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: const [Text('Familiarity')],
        ),
        const SizedBox(
          height: 20.0,
        ),
        _learnButtonsRow(),
        const SizedBox(
          height: 20.0,
        ),
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

  Row _learnButtonsRow() {
    const sizedBox = SizedBox(width: 20.0);

    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        // _learnButton('Draw'),
        // sizedBox,
        _learnButton('Perfect', func: _buttonPerfect),
        sizedBox,
        _learnButton('Medium', func: _buttonMedium),
        sizedBox,
        _learnButton('None', func: _buttonNone),
        sizedBox,
      ],
    );
  }

  ElevatedButton _learnButton(String buttonText, {Function? func}) {
    return ElevatedButton(
      style: ButtonStyle(
          backgroundColor: MaterialStateProperty.all<Color>(Colors.teal)),
      onPressed: () async {
        if (func != null) func();
        await LearnController().run(context, _lastCard);
        _setRandomCard();
      },
      child: Text(buttonText),
    );
  }

  void _buttonPerfect() {
    _lastCard.familiarity = Familiarity.perfect;
    CardsRepository().save(_lastCard);
    refreshGlobalCardsList(context);
  }

  void _buttonMedium() {
    _lastCard.familiarity = Familiarity.medium;
    CardsRepository().save(_lastCard);
    refreshGlobalCardsList(context);
  }

  void _buttonNone() {
    _lastCard.familiarity = Familiarity.none;
    CardsRepository().save(_lastCard);
    refreshGlobalCardsList(context);
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
