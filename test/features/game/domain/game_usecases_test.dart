import 'dart:math';

import 'package:flutter_test/flutter_test.dart';
import 'package:train_memory/core/constants/game_constants.dart';
import 'package:train_memory/features/game/data/datasources/card_catalog_datasource.dart';
import 'package:train_memory/features/game/data/repositories/game_repository_impl.dart';
import 'package:train_memory/features/game/domain/entities/game_phase.dart';
import 'package:train_memory/features/game/domain/entities/game_session.dart';
import 'package:train_memory/features/game/domain/entities/memory_card.dart';
import 'package:train_memory/features/game/domain/usecases/flip_card.dart';
import 'package:train_memory/features/game/domain/usecases/hide_unmatched.dart';
import 'package:train_memory/features/game/domain/usecases/start_game.dart';

void main() {
  group('StartGame', () {
    test('создаёт колоду из 16 карт и фазу idle', () {
      final repository = GameRepositoryImpl(
        catalog: const CardCatalogDataSource(),
        random: Random(42),
      );
      final startGame = StartGame(repository);

      final session = startGame(pairCount: kPairCount);

      expect(session.cards.length, 16);
      expect(session.phase, GamePhase.idle);
      expect(session.moves, 0);
      expect(session.firstFlippedIndex, isNull);
    });
  });

  group('FlipCardUseCase', () {
    const flip = FlipCardUseCase();

    test('первая карта переводит в awaitingSecond', () {
      final session = _sessionWithCards([
        ('a', 'p1'),
        ('b', 'p1'),
      ]);

      final result = flip(session, 0);

      expect(result, isA<FlipCardApplied>());
      final applied = result as FlipCardApplied;
      expect(applied.session.phase, GamePhase.awaitingSecond);
      expect(applied.session.cards[0].isFaceUp, isTrue);
      expect(applied.session.firstFlippedIndex, 0);
      expect(applied.session.moves, 0);
    });

    test(
        'вторая совпавшая карта увеличивает ходы и сбрасывает firstFlippedIndex',
        () {
      var session = _sessionWithCards([
        ('a', 'p1'),
        ('b', 'p1'),
      ]);
      session = (flip(session, 0) as FlipCardApplied).session;

      final result = flip(session, 1);

      expect(result, isA<FlipCardApplied>());
      final applied = result as FlipCardApplied;
      expect(applied.session.moves, 1);
      expect(applied.session.cards.every((c) => c.isMatched), isTrue);
      expect(applied.session.phase, GamePhase.won);
      expect(applied.session.firstFlippedIndex, isNull);
    });

    test('несовпадение переводит в resolving', () {
      var session = _sessionWithCards([
        ('a', 'p1'),
        ('b', 'p2'),
      ]);
      session = (flip(session, 0) as FlipCardApplied).session;

      final result = flip(session, 1);

      expect(result, isA<FlipCardApplied>());
      final applied = result as FlipCardApplied;
      expect(applied.session.phase, GamePhase.resolving);
      expect(applied.session.moves, 1);
      expect(applied.session.cards[0].isFaceUp, isTrue);
      expect(applied.session.cards[1].isFaceUp, isTrue);
    });

    test('игнорирует тап в resolving', () {
      var session = _sessionWithCards([
        ('a', 'p1'),
        ('b', 'p2'),
        ('c', 'p3'),
      ]);
      session = (flip(session, 0) as FlipCardApplied).session;
      session = (flip(session, 1) as FlipCardApplied).session;

      final result = flip(session, 2);

      expect(result, isA<FlipCardIgnored>());
    });
  });

  group('HideUnmatched', () {
    const hide = HideUnmatched();
    const flip = FlipCardUseCase();

    test('закрывает две несовпавшие карты', () {
      var session = _sessionWithCards([
        ('a', 'p1'),
        ('b', 'p2'),
      ]);
      session = (flip(session, 0) as FlipCardApplied).session;
      session = (flip(session, 1) as FlipCardApplied).session;

      final hidden = hide(session);

      expect(hidden.phase, GamePhase.idle);
      expect(hidden.cards[0].isFaceUp, isFalse);
      expect(hidden.cards[1].isFaceUp, isFalse);
      expect(hidden.firstFlippedIndex, isNull);
    });
  });
}

GameSession _sessionWithCards(List<(String id, String pairId)> specs) {
  return GameSession(
    cards: [
      for (final (id, pairId) in specs) MemoryCard(id: id, pairId: pairId),
    ],
    phase: GamePhase.idle,
    moves: 0,
  );
}
