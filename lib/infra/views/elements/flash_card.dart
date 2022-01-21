import 'package:flash_clouds_app/domain/entities/card_entity.dart';
import 'package:flash_clouds_app/infra/data_structures/cards_list.dart';
import 'package:flash_clouds_app/infra/local_db/cards_repository.dart';
import 'package:flip_card/flip_card.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class FlashCard extends StatefulWidget {
  final CardEntity cardEntity;
  final bool flipped;

  const FlashCard({Key? key, required this.cardEntity, this.flipped = false})
      : super(key: key);

  @override
  State<FlashCard> createState() => _FlashCardState();
}

class _FlashCardState extends State<FlashCard> {
  @override
  Widget build(BuildContext context) {
    String front = widget.cardEntity.front;
    String back = widget.cardEntity.back;

    if (widget.flipped) {
      front = widget.cardEntity.back;
      back = widget.cardEntity.front;
    }

    return FlipCard(
      fill: Fill
          .fillBack, // Fill the back side of the card to make in the same size as the front.
      direction: FlipDirection.HORIZONTAL, // default
      front: _cardSide(context, front),
      back: _cardSide(context, back),
    );
  }

  Container _cardSide(BuildContext context, String sideText) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 1.0),
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
                  onPressed: () async {
                    widget.cardEntity.delete();
                    List<CardEntity?> cards =
                        await CardsRepository().getAllSortByDate();

                    Provider.of<CardsList>(context, listen: false)
                        .updateList(cards);
                  },
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
                Flexible(child: Text(sideText)),
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
}
