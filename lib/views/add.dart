import 'package:flash_clouds_app/validators/addValidator.dart';
import 'package:flutter/material.dart';

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
                TextFormField(
                  decoration: const InputDecoration(
                    hintText: 'What do you want to memorise',
                    labelText: 'Card text',
                  ),
                  controller: addFormController,
                  validator: addValidator,
                  onSaved: (val) {
                    print('saved! $val');
                  },
                ),
                sizedBox,
                Center(
                  child: ElevatedButton(
                    onPressed: () {
                      if (_formKey.currentState!.validate()) {
                        _formKey.currentState?.save();
                      }
                    },
                    child: const Text('Add'),
                  ),
                ),
              ],
            ),
          ),
          sizedBox
        ],
      ),
    );
  }

  String getCardsList() {
    return '''
2021-01-07 13:00
This will be a list''';
  }
}
