import 'package:flash_clouds_app/infra/helpers/show_dialog_with_text.dart';
import 'package:flash_clouds_app/infra/local_db/cards_repository.dart';
import 'package:flash_clouds_app/domain/validators/card_validator.dart';
import 'package:flash_clouds_app/domain/entities/card_entity.dart';
import 'package:flutter/material.dart';

class Add extends StatefulWidget {
  const Add({Key? key}) : super(key: key);

  @override
  _AddState createState() => _AddState();
}

class _AddState extends State<Add> {
  final _formKey = GlobalKey<FormState>();
  final _frontTxtCtrl = TextEditingController();
  final _backTxtCtrl = TextEditingController();
  List _latestCards = [];
  CardsRepository _cardsRepo = CardsRepository();

  @override
  void dispose() {
    _frontTxtCtrl.dispose();
    _backTxtCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    const sizedBox = SizedBox(
      height: 20.0,
    );

    _refreshCardsList();

    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          _buildLatestCardsList(),
          sizedBox,
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
      return Column();
    }

    CardEntity first = _latestCards.last;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(first.id),
        Text(first.created.toString().substring(0, 19)),
        Text(first.front),
        Text(first.back),
      ],
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
                CardEntity card =
                    CardEntity.create(_frontTxtCtrl.text, _backTxtCtrl.text);
                await _cardsRepo.save(card);
                _refreshCardsList();
              }
            },
            child: const Text('Add'),
          ),
          const SizedBox(
            width: 10.0,
          ),
          ElevatedButton(
            onPressed: () async {
              List<CardEntity?> value = await _cardsRepo.getAll();
              showDialogWithText(context, value.toString());
            },
            child: const Text('List'),
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

  _refreshCardsList() {
    _cardsRepo.getLatest().then((CardEntity? card) {
      if (card == null) {
        return;
      }

      if (_latestCards.isNotEmpty && card.id == _latestCards.last.id) {
        return;
      }

      _latestCards = [card];
      setState(() {});
    });
  }
}
