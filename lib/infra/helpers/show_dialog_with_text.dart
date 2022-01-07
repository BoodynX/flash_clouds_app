import 'package:flutter/material.dart';

Future showDialogWithText(BuildContext context, String text) {
  return showDialog(
    context: context,
    builder: (context) {
      return AlertDialog(
        // Retrieve the text that the user has entered by using the
        // TextEditingController.
        content: Text(text),
      );
    },
  );
}
