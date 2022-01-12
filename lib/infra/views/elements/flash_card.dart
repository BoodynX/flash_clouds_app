import 'package:flash_clouds_app/domain/entities/card_entity.dart';
import 'package:flash_clouds_app/infra/local_db/cards_repository.dart';
import 'package:flutter/material.dart';

class FlashCard extends StatefulWidget {
  final CardEntity cardEntity;

  const FlashCard({Key? key, required this.cardEntity}) : super(key: key);

  @override
  State<FlashCard> createState() => _FlashCardState();
}

class _FlashCardState extends State<FlashCard> {
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 20.0),
      decoration: BoxDecoration(
          color: Colors.white,
          border: Border.all(
            width: 1.0,
            color: Colors.blueGrey.withOpacity(0.3),
          ),
          borderRadius: const BorderRadius.all(Radius.circular(10)),
          boxShadow: [
            BoxShadow(
              color: Colors.blueGrey.withOpacity(0.3),
              spreadRadius: 3,
              blurRadius: 5,
              offset: const Offset(0, 3),
            )
          ]),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              IconButton(
                  onPressed: _deleteCard,
                  icon: const Icon(
                    Icons.delete_outlined,
                    size: 20.0,
                    color: Colors.grey,
                  ))
            ],
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 15.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Flexible(child: Text(widget.cardEntity.front)),
              ],
            ),
          ),
          Row(
            children: const [
              SizedBox(height: 40.0),
            ],
          ),
        ],
      ),
    );
  }

  void _deleteCard() async {
    var repo = CardsRepository();
    repo.delete([widget.cardEntity.id]);
    //  TODO do something to refresh the containing view
  }
}
