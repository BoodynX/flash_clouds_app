import 'package:flash_clouds_app/domain/entities/card_entity.dart';
import 'package:flash_clouds_app/infra/data_structures/cards_list.dart';
import 'package:flash_clouds_app/infra/local_db/cards_repository.dart';
import 'package:provider/provider.dart';

abstract class RefreshCardsList {
  Future<void> refreshCardsList(context) async {
    List<CardEntity?> cards = await CardsRepository().getAllSortByDate();
    List<CardEntity?> cardsList =
        Provider.of<CardsList>(context, listen: false).cardsList;

    if (cards == []) {
      return;
    }

    if (cardsList.isNotEmpty &&
        cards.last?.id == cardsList.last?.id &&
        cards.length == cardsList.length) {
      return;
    }

    Provider.of<CardsList>(context, listen: false).updateList(cards);
  }
}
