import '../../domain/entities/card_suit.dart';
import '../../domain/entities/deck_kind.dart';

/// Описание лица пары в каталоге (без Flutter).
class CardFaceDefinition {
  const CardFaceDefinition({
    required this.pairId,
    required this.label,
    this.assetPath,
    this.rank,
    this.suit,
  });

  final String pairId;
  final String label;

  /// Опциональный asset; если null — UI рисует иконку/цвет (колода «природа»).
  final String? assetPath;

  /// Ранг игральной карты (Т, К, Д, В, 10…); только для [DeckKind.playingCards].
  final String? rank;

  /// Масть; только для [DeckKind.playingCards].
  final CardSuit? suit;
}

/// Статический каталог лиц: два набора — природа и игральные карты.
class CardCatalogDataSource {
  const CardCatalogDataSource();

  /// Колода «природа»: как было до игральных карт.
  static const List<CardFaceDefinition> natureFaces = [
    CardFaceDefinition(
      pairId: 'star',
      label: 'Звезда',
    ),
    CardFaceDefinition(
      pairId: 'heart',
      label: 'Сердце',
    ),
    CardFaceDefinition(
      pairId: 'moon',
      label: 'Луна',
    ),
    CardFaceDefinition(
      pairId: 'sun',
      label: 'Солнце',
    ),
    CardFaceDefinition(
      pairId: 'cloud',
      label: 'Облако',
    ),
    CardFaceDefinition(
      pairId: 'bolt',
      label: 'Молния',
    ),
    CardFaceDefinition(
      pairId: 'leaf',
      label: 'Лист',
    ),
    CardFaceDefinition(
      pairId: 'fish',
      label: 'Рыба',
    ),
    CardFaceDefinition(
      pairId: 'vish',
      label: 'Vish',
      assetPath: 'assets/images/vish.png',
    ),
  ];

  /// 8 фиксированных игральных лиц для поля 4×4.
  static const List<CardFaceDefinition> playingCardFaces = [
    CardFaceDefinition(
      pairId: 'ace_hearts',
      label: 'Туз червей',
      rank: 'Т',
      suit: CardSuit.hearts,
    ),
    CardFaceDefinition(
      pairId: 'king_spades',
      label: 'Король пик',
      rank: 'К',
      suit: CardSuit.spades,
    ),
    CardFaceDefinition(
      pairId: 'queen_diamonds',
      label: 'Дама бубен',
      rank: 'Д',
      suit: CardSuit.diamonds,
    ),
    CardFaceDefinition(
      pairId: 'jack_clubs',
      label: 'Валет треф',
      rank: 'В',
      suit: CardSuit.clubs,
    ),
    CardFaceDefinition(
      pairId: 'ten_hearts',
      label: 'Десятка червей',
      rank: '10',
      suit: CardSuit.hearts,
    ),
    CardFaceDefinition(
      pairId: 'nine_spades',
      label: 'Девятка пик',
      rank: '9',
      suit: CardSuit.spades,
    ),
    CardFaceDefinition(
      pairId: 'eight_diamonds',
      label: 'Восьмёрка бубен',
      rank: '8',
      suit: CardSuit.diamonds,
    ),
    CardFaceDefinition(
      pairId: 'seven_clubs',
      label: 'Семёрка треф',
      rank: '7',
      suit: CardSuit.clubs,
    ),
  ];

  List<CardFaceDefinition> getAvailableFaces(DeckKind kind) {
    return switch (kind) {
      DeckKind.nature => natureFaces,
      DeckKind.playingCards => playingCardFaces,
    };
  }

  CardFaceDefinition? findByPairId(String pairId) {
    for (final face in natureFaces) {
      if (face.pairId == pairId) {
        return face;
      }
    }
    for (final face in playingCardFaces) {
      if (face.pairId == pairId) {
        return face;
      }
    }
    return null;
  }
}
