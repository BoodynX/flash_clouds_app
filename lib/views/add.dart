import 'package:flash_clouds_app/helpers/show_dialog_with_text.dart';
import 'package:flash_clouds_app/validators/addValidator.dart';
import 'package:flutter/material.dart';
import 'package:localstore/localstore.dart';

class Add extends StatefulWidget {
  const Add({Key? key}) : super(key: key);

  @override
  _AddState createState() => _AddState();
}

class _AddState extends State<Add> {
  // Create a text controller and use it to retrieve the current value
  // of the TextField.
  final _formKey = GlobalKey<FormState>();
  final addFormController = TextEditingController();
  final List latestCards = [];

  @override
  void dispose() {
    // Clean up the controller when the widget is disposed.
    addFormController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    const sizedBox = SizedBox(
      height: 20.0,
    );

    final db = Localstore.instance;

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
                _textField(db),
                sizedBox,
                _formButtons(db, context),
              ],
            ),
          ),
          sizedBox
        ],
      ),
    );
  }

  Center _formButtons(Localstore db, BuildContext context) {
    return Center(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          ElevatedButton(
            onPressed: () {
              if (_formKey.currentState!.validate()) {
                _formKey.currentState?.save();
              }
            },
            child: const Text('Add'),
          ),
          const SizedBox(
            width: 10.0,
          ),
          ElevatedButton(
            onPressed: () {
              db.collection('cards').get().then((value) {
                showDialogWithText(context, value.toString());
              });
            },
            child: const Text('List'),
          ),
        ],
      ),
    );
  }

  TextFormField _textField(Localstore db) {
    return TextFormField(
      decoration: const InputDecoration(
        hintText: 'What do you want to memorise',
        labelText: 'Card text',
      ),
      controller: addFormController,
      validator: addValidator,
      onSaved: (cardContent) {
        print('saved! $cardContent');
        final id = db.collection('cards').doc().id;
        db.collection('cards').doc(id).set({
          'content': cardContent,
          'created': DateTime.now().toString(),
          'lastTimeKnown': 'new',
        });
      },
    );
  }

  String getCardsList() {
    return '''
2021-01-07 13:00
This will be a list''';
  }
}
