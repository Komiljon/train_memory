import 'package:flutter_test/flutter_test.dart';
import 'package:train_memory/core/constants/game_constants.dart';
import 'package:train_memory/features/game/data/datasources/card_catalog_datasource.dart';
import 'package:train_memory/features/game/domain/entities/deck_kind.dart';

void main() {
  const catalog = CardCatalogDataSource();

  group('CardCatalogDataSource', () {
    for (final kind in DeckKind.values) {
      test('колода $kind содержит не меньше $kPairCount лиц', () {
        final faces = catalog.getAvailableFaces(kind);
        expect(faces.length, greaterThanOrEqualTo(kPairCount));
      });
    }

    test('все pairId уникальны между колодами', () {
      final seen = <String>{};

      for (final kind in DeckKind.values) {
        for (final face in catalog.getAvailableFaces(kind)) {
          expect(
            seen.add(face.pairId),
            isTrue,
            reason: 'Дубликат pairId: ${face.pairId} в колоде $kind',
          );
        }
      }
    });

    test('findByPairId находит лицо из любой колоды', () {
      expect(catalog.findByPairId('star')?.label, 'Звезда');
      expect(catalog.findByPairId('ace_hearts')?.label, 'Туз червей');
      expect(catalog.findByPairId('animal_cat')?.glyph, '🐱');
      expect(catalog.findByPairId('num_5')?.glyph, '5');
      expect(catalog.findByPairId('shape_star')?.glyph, '★');
    });
  });
}
