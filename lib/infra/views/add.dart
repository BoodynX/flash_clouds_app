import 'package:flash_clouds_app/infra/helpers/show_dialog_with_text.dart';
import 'package:flash_clouds_app/infra/local_db/cards_repository.dart';
import 'package:flash_clouds_app/domain/validators/card_validator.dart';
import 'package:flutter/material.dart';

class Add extends StatefulWidget {
  const Add({Key? key}) : super(key: key);

  @override
  _AddState createState() => _AddState();
}

class _AddState extends State<Add> {
  final _formKey = GlobalKey<FormState>();
  final frontTextController = TextEditingController();
  final backTextController = TextEditingController();
  List latestCards = [];
  CardsRepository cards = CardsRepository();

  @override
  void dispose() {
    frontTextController.dispose();
    backTextController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    const sizedBox = SizedBox(
      height: 20.0,
    );

    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          Text(getCardsList()),
          sizedBox,
          Form(
            key: _formKey,
            child: Column(
              children: [
                _textField(frontTextController, 'Question', 'Card front'),
                sizedBox,
                _textField(backTextController, 'Answer', 'Card back'),
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

  Center _formButtons(BuildContext context) {
    return Center(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          ElevatedButton(
            onPressed: () {
              if (_formKey.currentState!.validate()) {
                cards.add(frontTextController.text, backTextController.text);
              }
            },
            child: const Text('Add'),
          ),
          const SizedBox(
            width: 10.0,
          ),
          ElevatedButton(
            onPressed: () {
              cards.getAll().then((value) {
                showDialogWithText(context, value.toString());
              });
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

  String getCardsList() {
    return '''
2021-01-07 13:00
This will be a list''';
  }
}
