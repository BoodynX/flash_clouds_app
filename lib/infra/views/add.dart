import 'package:flash_clouds_app/domain/entities/card_entity.dart';
import 'package:flash_clouds_app/domain/validators/card_validator.dart';
import 'package:flash_clouds_app/infra/data_structures/cards_list.dart';
import 'package:flash_clouds_app/infra/factories/cards_factory.dart';
import 'package:flash_clouds_app/infra/local_db/cards_repository.dart';
import 'package:flash_clouds_app/infra/views/elements/flash_card.dart';
import 'package:flash_clouds_app/infra/views/mixins/refresh_cards_list.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class Add extends StatefulWidget {
  const Add({Key? key}) : super(key: key);

  @override
  _AddState createState() => _AddState();
}

class _AddState extends State<Add> with RefreshCardsList {
  final _formKey = GlobalKey<FormState>();
  final _frontTxtCtrl = TextEditingController();
  final _backTxtCtrl = TextEditingController();
  List _latestCards = [];
  final CardsRepository _cardsRepo = CardsRepository();
  final CardsFactory _cardsFactory = CardsFactory();

  @override
  void dispose() {
    _frontTxtCtrl.dispose();
    _backTxtCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    const sizedBox = SizedBox(
      height: 30.0,
    );

    _setLastCard(Provider.of<CardsList>(context).cardsList);

    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          Expanded(
            child: ListView(
              children: [
                // sizedBox,
                _buildLatestCardsList(),
                sizedBox,
                const Center(child: Text('Last added card')),
              ],
            ),
          ),
          Form(
            key: _formKey,
            child: Column(
              children: [
                _textField(_frontTxtCtrl, 'Question', 'Card front'),
                sizedBox,
                _textField(_backTxtCtrl, 'Answer', 'Card back'),
                sizedBox,
                _formButtons(context),
              ],
            ),
          ),
          sizedBox
        ],
      ),
    );
  }

  Column _buildLatestCardsList() {
    if (_latestCards.isEmpty) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: const [],
      );
    }

    CardEntity lastCard = _latestCards.last;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [FlashCard(cardEntity: lastCard)],
    );
  }

  Center _formButtons(BuildContext context) {
    return Center(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          ElevatedButton(
            onPressed: () async {
              if (_formKey.currentState!.validate()) {
                CardEntity card = _cardsFactory.createNew(
                    _frontTxtCtrl.text, _backTxtCtrl.text);
                await _cardsRepo.save(card);
                _refreshLastCard();
              }
            },
            child: const Text('Add'),
          ),
          const SizedBox(
            width: 10.0,
          ),
        ],
      ),
    );
  }

  TextFormField _textField(
      TextEditingController textController, String hint, String label) {
    return TextFormField(
      decoration: InputDecoration(
        hintText: hint,
        labelText: label,
      ),
      controller: textController,
      validator: cardValidator,
    );
  }

  _refreshLastCard() async {
    List<CardEntity?> cardsList = [];
    await refreshCardsList(context);
    cardsList = Provider.of<CardsList>(context, listen: false).cardsList;
    _setLastCard(cardsList);
  }

  _setLastCard(List<CardEntity?> cardsList) {
    if (cardsList.isEmpty) {
      _latestCards = [];
      setState(() {});
      return;
    }

    CardEntity? card = cardsList.last;

    if (card == null) {
      return;
    }

    if (_latestCards.isNotEmpty && card.id == _latestCards.last.id) {
      return;
    }

    _latestCards = [card];
    setState(() {});
  }
}
