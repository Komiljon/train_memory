import '../entities/deck_kind.dart';
import '../entities/memory_card.dart';

/// Контракт data-слоя: колода без UI и без Random в domain.
abstract interface class GameRepository {
  /// Собирает и перемешивает колоду из [pairCount] пар выбранного [deckKind].
  List<MemoryCard> createShuffledDeck({
    required int pairCount,
    required DeckKind deckKind,
  });
}
