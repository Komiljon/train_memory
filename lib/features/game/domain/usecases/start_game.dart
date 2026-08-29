import '../../../../core/constants/game_constants.dart';
import '../entities/deck_kind.dart';
import '../entities/game_phase.dart';
import '../entities/game_session.dart';
import '../repositories/game_repository.dart';

/// Старт партии: колода из репозитория, фаза idle, ноль ходов.
class StartGame {
  const StartGame(this._repository);

  final GameRepository _repository;

  GameSession call({
    int pairCount = kPairCount,
    required DeckKind deckKind,
  }) {
    final cards = _repository.createShuffledDeck(
      pairCount: pairCount,
      deckKind: deckKind,
    );
    return GameSession(
      cards: cards,
      phase: GamePhase.idle,
      moves: 0,
    );
  }
}
