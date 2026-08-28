import '../entities/game_phase.dart';
import '../entities/game_session.dart';
import '../entities/memory_card.dart';

/// Закрывает две несовпавшие открытые карты после паузы resolving.
class HideUnmatched {
  const HideUnmatched();

  GameSession call(GameSession session) {
    if (session.phase != GamePhase.resolving) {
      return session;
    }

    final firstIndex = session.firstFlippedIndex;
    if (firstIndex == null) {
      return session.copyWith(
        phase: GamePhase.idle,
        firstFlippedIndex: () => null,
      );
    }

    final secondIndex = _findSecondOpenIndex(session, firstIndex);
    if (secondIndex == null) {
      return session.copyWith(
        phase: GamePhase.idle,
        firstFlippedIndex: () => null,
      );
    }

    final cards = List<MemoryCard>.from(session.cards);
    cards[firstIndex] = cards[firstIndex].copyWith(isFaceUp: false);
    cards[secondIndex] = cards[secondIndex].copyWith(isFaceUp: false);

    return session.copyWith(
      cards: cards,
      phase: GamePhase.idle,
      firstFlippedIndex: () => null,
    );
  }

  int? _findSecondOpenIndex(GameSession session, int firstIndex) {
    for (var i = 0; i < session.cards.length; i++) {
      if (i == firstIndex) {
        continue;
      }
      final card = session.cards[i];
      if (card.isFaceUp && !card.isMatched) {
        return i;
      }
    }
    return null;
  }
}
