import 'game_phase.dart';
import 'memory_card.dart';

/// Снимок партии: иммутабельное состояние для use case и Notifier.
class GameSession {
  const GameSession({
    required this.cards,
    required this.phase,
    required this.moves,
    this.firstFlippedIndex,
  });

  final List<MemoryCard> cards;
  final GamePhase phase;
  final int moves;

  /// Индекс первой открытой карты в фазе awaitingSecond/resolving.
  final int? firstFlippedIndex;

  /// Число пар на поле (pairId уникален).
  int get pairCount {
    return cards.map((c) => c.pairId).toSet().length;
  }

  bool get isWon => phase == GamePhase.won;

  GameSession copyWith({
    List<MemoryCard>? cards,
    GamePhase? phase,
    int? moves,
    int? Function()? firstFlippedIndex,
  }) {
    return GameSession(
      cards: cards ?? this.cards,
      phase: phase ?? this.phase,
      moves: moves ?? this.moves,
      firstFlippedIndex: firstFlippedIndex != null
          ? firstFlippedIndex()
          : this.firstFlippedIndex,
    );
  }
}
