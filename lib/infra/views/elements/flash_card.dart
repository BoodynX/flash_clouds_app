import 'package:flash_clouds_app/domain/entities/card_entity.dart';
import 'package:flash_clouds_app/infra/data_structures/cards_list.dart';
import 'package:flash_clouds_app/infra/local_db/cards_repository.dart';
import 'package:flip_card/flip_card.dart';
import 'package:flip_card/flip_card_controller.dart';
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
  late FlipCardController _controller;
  Color _cardColor = Colors.white;
  double _opacity = 1.0;
  Duration _opacityAnimationDuration = const Duration(seconds: 1);
  bool _enableControls = true;

  @override
  void initState() {
    super.initState();
    _controller = FlipCardController();
  }

  @override
  Widget build(BuildContext context) {
    String front = widget.cardEntity.front;
    String back = widget.cardEntity.back;

    if (widget.flipped) {
      front = widget.cardEntity.back;
      back = widget.cardEntity.front;
    }

    return AnimatedOpacity(
      opacity: _opacity,
      duration: _opacityAnimationDuration,
      child: FlipCard(
        // Fill the back side of the card to make in the same size as the front.
        fill: front.length > back.length ? Fill.fillBack : Fill.fillFront,
        direction: FlipDirection.HORIZONTAL, // default
        front: _cardSide(context, front),
        back: _cardSide(context, back),
        controller: _controller,
        flipOnTouch: _enableControls,
      ),
    );
  }

  Container _cardSide(BuildContext context, String sideText) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 1.0),
      decoration: _cardDecoration(),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          _topRowEditing(context),
          _middleRowContent(sideText),
          _bottomRow(),
        ],
      ),
    );
  }

  Row _topRowEditing(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        IconButton(
            onPressed: () async {
              if (!_enableControls) {
                return;
              }
              setState(() {
                _enableControls = false;
              });

              // without this, after deleting a flipped card, next card in list gets flipped instantly
              await _animateDeletion();

              widget.cardEntity.delete();
              List<CardEntity?> cards =
                  await CardsRepository().getAllSortByDate();
              Provider.of<CardsList>(context, listen: false).updateList(cards);

              setState(() {
                _enableControls = true;
              });
            },
            icon: const Icon(
              Icons.delete_outlined,
              size: 20.0,
              color: Colors.grey,
            ))
      ],
    );
  }

  Padding _middleRowContent(String sideText) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 15.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Flexible(child: Text(sideText)),
        ],
      ),
    );
  }

  Row _bottomRow() {
    return Row(
      children: const [
        SizedBox(height: 40.0),
      ],
    );
  }

  BoxDecoration _cardDecoration() {
    return BoxDecoration(
        color: _cardColor,
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
        ]);
  }

  Future<void> _animateDeletion() async {
    // without this, after deleting a flipped card, next card in list gets flipped instantly
    setState(() {
      _cardColor = Colors.redAccent;
      _opacity = 0.0;
      _opacityAnimationDuration = const Duration(seconds: 1);
    });
    if (!_controller.state!.isFront) {
      _controller.toggleCard();
    }
    await Future.delayed(const Duration(seconds: 1));
    setState(() {
      _cardColor = Colors.white;
      _opacity = 1.0;
      _opacityAnimationDuration = Duration.zero;
    });
  }
}
