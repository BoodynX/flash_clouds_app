import 'package:flash_clouds_app/domain/entities/card_entity.dart';
import 'package:flash_clouds_app/domain/services/lottery_machine.dart';
import 'package:flash_clouds_app/infra/data_structures/random_card.dart';
import 'package:flash_clouds_app/infra/local_db/cards_repository.dart';
import 'package:provider/provider.dart';

class LearnController {
  Future<CardEntity?>? run(context) async {
    LotteryMachine machine = LotteryMachine(CardsRepository());

    CardEntity? card = await machine.drawCard();

    Provider.of<RandomCard>(context, listen: false).updateCard(card);
    return card;
  }
}
