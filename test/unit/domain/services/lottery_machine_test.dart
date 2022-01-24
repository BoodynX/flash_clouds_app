import 'package:flash_clouds_app/domain/entities/card_entity.dart';
import 'package:flash_clouds_app/domain/repositories/i_cards_repository.dart';
import 'package:flash_clouds_app/domain/services/lottery_machine.dart';
import 'package:flash_clouds_app/infra/factories/cards_factory.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import 'lottery_machine_test.mocks.dart';

@GenerateMocks([ICardsRepository])
void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  test('Lottery Machine', () async {
    var repo = MockICardsRepository();
    when(repo.getAll()).thenAnswer((_) => Future(() {
          return [
            CardsFactory().createNew('front', 'back'),
            CardsFactory().createNew('front', 'back')
          ];
        }));

    var lm = LotteryMachine(repo);
    CardEntity? card = await lm.drawCard();

    expect(card?.front, 'front');
  });
}
