import 'package:flash_clouds_app/infra/views/elements/flash_card.dart';
import 'package:flutter/material.dart';

class Learn extends StatefulWidget {
  const Learn({Key? key}) : super(key: key);

  @override
  _LearnState createState() => _LearnState();
}

class _LearnState extends State<Learn> {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Row(
        children: const [
          Expanded(
            child: Text('Dummy'),
          )
        ],
      ),
    );
  }
}
