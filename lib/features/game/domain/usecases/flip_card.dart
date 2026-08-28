import '../entities/game_phase.dart';
import '../entities/game_session.dart';
import '../entities/memory_card.dart';

/// Результат попытки перевернуть карту: новая сессия или без изменений.
sealed class FlipCardResult {
  const FlipCardResult();
}

final class FlipCardApplied extends FlipCardResult {
  const FlipCardApplied(this.session);

  final GameSession session;
}

final class FlipCardIgnored extends FlipCardResult {
  const FlipCardIgnored();
}

/// Переворот одной карты по индексу с правилами memory.
class FlipCardUseCase {
  const FlipCardUseCase();

  FlipCardResult call(GameSession session, int index) {
    if (!_canFlip(session, index)) {
      return const FlipCardIgnored();
    }

    final cards = List<MemoryCard>.from(session.cards);
    cards[index] = cards[index].copyWith(isFaceUp: true);

    switch (session.phase) {
      case GamePhase.idle:
        return FlipCardApplied(
          session.copyWith(
            cards: cards,
            phase: GamePhase.awaitingSecond,
            firstFlippedIndex: () => index,
          ),
        );

      case GamePhase.awaitingSecond:
        final firstIndex = session.firstFlippedIndex!;
        final first = cards[firstIndex];
        final second = cards[index];
        final isMatch = first.pairId == second.pairId;

        if (isMatch) {
          cards[firstIndex] = first.copyWith(isMatched: true);
          cards[index] = second.copyWith(isMatched: true);
          final allMatched = cards.every((c) => c.isMatched);
          return FlipCardApplied(
            session.copyWith(
              cards: cards,
              phase: allMatched ? GamePhase.won : GamePhase.idle,
              moves: session.moves + 1,
              firstFlippedIndex: () => null,
            ),
          );
        }

        return FlipCardApplied(
          session.copyWith(
            cards: cards,
            phase: GamePhase.resolving,
            moves: session.moves + 1,
            firstFlippedIndex: () => firstIndex,
          ),
        );

      case GamePhase.resolving:
      case GamePhase.won:
        return const FlipCardIgnored();
    }
  }

  bool _canFlip(GameSession session, int index) {
    if (index < 0 || index >= session.cards.length) {
      return false;
    }
    if (session.phase == GamePhase.resolving ||
        session.phase == GamePhase.won) {
      return false;
    }

    final card = session.cards[index];
    if (card.isFaceUp || card.isMatched) {
      return false;
    }

    if (session.phase == GamePhase.awaitingSecond &&
        session.firstFlippedIndex == index) {
      return false;
    }

    return true;
  }
}
