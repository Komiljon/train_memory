import 'dart:math';

import '../../../../core/error/failure.dart';
import '../../domain/entities/memory_card.dart';
import '../../domain/repositories/game_repository.dart';
import '../datasources/card_catalog_datasource.dart';

/// Реализация колоды: каталог + Random для перемешивания (в тестах — seed).
class GameRepositoryImpl implements GameRepository {
  GameRepositoryImpl({
    required CardCatalogDataSource catalog,
    Random? random,
  })  : _catalog = catalog,
        _random = random ?? Random();

  final CardCatalogDataSource _catalog;
  final Random _random;

  @override
  List<MemoryCard> createShuffledDeck({required int pairCount}) {
    final faces = _catalog.getAvailableFaces();
    if (faces.length < pairCount) {
      throw InsufficientCatalogFailure(
        pairCount: pairCount,
        availablePairs: faces.length,
      );
    }

    final selected = faces.take(pairCount).toList(growable: false);
    final cards = <MemoryCard>[];

    for (var pairIndex = 0; pairIndex < selected.length; pairIndex++) {
      final face = selected[pairIndex];
      final pairId = face.pairId;
      cards.add(
        MemoryCard(
          id: '${pairId}_a',
          pairId: pairId,
        ),
      );
      cards.add(
        MemoryCard(
          id: '${pairId}_b',
          pairId: pairId,
        ),
      );
    }

    cards.shuffle(_random);
    _validateDeck(cards, pairCount);
    return cards;
  }

  void _validateDeck(List<MemoryCard> cards, int pairCount) {
    if (cards.length.isOdd) {
      throw const InvalidDeckFailure(
          'Колода должна содержать чётное число карт');
    }

    final pairCounts = <String, int>{};
    for (final card in cards) {
      pairCounts[card.pairId] = (pairCounts[card.pairId] ?? 0) + 1;
    }

    if (pairCounts.length != pairCount) {
      throw InvalidDeckFailure(
        'Ожидалось $pairCount уникальных pairId, получено ${pairCounts.length}',
      );
    }

    for (final entry in pairCounts.entries) {
      if (entry.value != 2) {
        throw InvalidDeckFailure(
          'pairId ${entry.key} встречается ${entry.value} раз, нужно 2',
        );
      }
    }
  }
}
