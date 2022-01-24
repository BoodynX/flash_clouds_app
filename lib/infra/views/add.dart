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
  final SizedBox _sizedBox = const SizedBox(height: 20.0);

  @override
  void dispose() {
    _frontTxtCtrl.dispose();
    _backTxtCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    refreshCardsList(context);
    _setLastCard(Provider.of<CardsList>(context).cardsList);

    return _buildView();
  }

  Padding _buildView() {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          _latestCardsList(),
          _addCardForm(),
          _sizedBox,
          _formButtons(),
          _sizedBox,
        ],
      ),
    );
  }

  Expanded _latestCardsList() {
    return Expanded(
      child: ListView(
        children: [
          // sizedBox,
          _buildLatestCardsList(),
          _sizedBox,
          const Center(child: Text('Last added card')),
        ],
      ),
    );
  }

  Column _buildLatestCardsList() {
    if (_latestCards.isEmpty) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [FlashCard(cardEntity: CardsFactory().createBlank())],
      );
    }

    CardEntity lastCard = _latestCards.last;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [FlashCard(cardEntity: lastCard)],
    );
  }

  void _setLastCard(List<CardEntity?> cardsList) {
    if (cardsList.isEmpty) {
      setState(() {
        _latestCards = [];
      });
      return;
    }

    CardEntity? card = cardsList.last;

    if (card == null) {
      return;
    }

    if (_latestCards.isNotEmpty && card.id == _latestCards.last.id) {
      return;
    }

    setState(() {
      _latestCards = [card];
    });
  }

  void _refreshLastCard() async {
    List<CardEntity?> cardsList = [];
    await refreshCardsList(context);
    cardsList = Provider.of<CardsList>(context, listen: false).cardsList;
    _setLastCard(cardsList);
  }

  Form _addCardForm() {
    return Form(
      key: _formKey,
      child: Column(
        children: [
          _textField(_frontTxtCtrl, 'Question', 'Card front'),
          _sizedBox,
          _textField(_backTxtCtrl, 'Answer', 'Card back'),
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

  Center _formButtons() {
    return Center(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          ElevatedButton(
            style: ButtonStyle(
                backgroundColor: MaterialStateProperty.all<Color>(Colors.teal)),
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
        ],
      ),
    );
  }
}
