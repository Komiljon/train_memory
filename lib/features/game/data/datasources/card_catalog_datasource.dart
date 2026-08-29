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
    this.glyph,
  });

  final String pairId;
  final String label;

  /// Опциональный asset; если null — UI рисует иконку/цвет (колода «природа»).
  final String? assetPath;

  /// Ранг игральной карты (Т, К, Д, В, 10…); только для [DeckKind.playingCards].
  final String? rank;

  /// Масть; только для [DeckKind.playingCards].
  final CardSuit? suit;

  /// Эмодзи, цифра или Unicode-символ; для тематических колод без asset/иконки.
  final String? glyph;
}

/// Статический каталог лиц: наборы по [DeckKind].
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

  /// Животные: pairId с префиксом animal_, чтобы не пересекаться с природой.
  static const List<CardFaceDefinition> animalFaces = [
    CardFaceDefinition(pairId: 'animal_cat', label: 'Кошка', glyph: '🐱'),
    CardFaceDefinition(pairId: 'animal_dog', label: 'Собака', glyph: '🐶'),
    CardFaceDefinition(pairId: 'animal_rabbit', label: 'Кролик', glyph: '🐰'),
    CardFaceDefinition(pairId: 'animal_fox', label: 'Лиса', glyph: '🦊'),
    CardFaceDefinition(pairId: 'animal_bear', label: 'Медведь', glyph: '🐻'),
    CardFaceDefinition(pairId: 'animal_panda', label: 'Панда', glyph: '🐼'),
    CardFaceDefinition(pairId: 'animal_frog', label: 'Лягушка', glyph: '🐸'),
    CardFaceDefinition(pairId: 'animal_owl', label: 'Сова', glyph: '🦉'),
  ];

  /// Фрукты и ягоды.
  static const List<CardFaceDefinition> fruitFaces = [
    CardFaceDefinition(pairId: 'fruit_apple', label: 'Яблоко', glyph: '🍎'),
    CardFaceDefinition(pairId: 'fruit_pear', label: 'Груша', glyph: '🍐'),
    CardFaceDefinition(pairId: 'fruit_orange', label: 'Апельсин', glyph: '🍊'),
    CardFaceDefinition(pairId: 'fruit_grape', label: 'Виноград', glyph: '🍇'),
    CardFaceDefinition(
        pairId: 'fruit_strawberry', label: 'Клубника', glyph: '🍓'),
    CardFaceDefinition(pairId: 'fruit_cherry', label: 'Вишня', glyph: '🍒'),
    CardFaceDefinition(pairId: 'fruit_watermelon', label: 'Арбуз', glyph: '🍉'),
    CardFaceDefinition(pairId: 'fruit_lemon', label: 'Лимон', glyph: '🍋'),
  ];

  /// Цифры 1–8: glyph читается лучше Material-иконок (нет 7 и 8 в looks_*).
  static const List<CardFaceDefinition> numberFaces = [
    CardFaceDefinition(pairId: 'num_1', label: 'Один', glyph: '1'),
    CardFaceDefinition(pairId: 'num_2', label: 'Два', glyph: '2'),
    CardFaceDefinition(pairId: 'num_3', label: 'Три', glyph: '3'),
    CardFaceDefinition(pairId: 'num_4', label: 'Четыре', glyph: '4'),
    CardFaceDefinition(pairId: 'num_5', label: 'Пять', glyph: '5'),
    CardFaceDefinition(pairId: 'num_6', label: 'Шесть', glyph: '6'),
    CardFaceDefinition(pairId: 'num_7', label: 'Семь', glyph: '7'),
    CardFaceDefinition(pairId: 'num_8', label: 'Восемь', glyph: '8'),
  ];

  /// Транспорт.
  static const List<CardFaceDefinition> transportFaces = [
    CardFaceDefinition(pairId: 'transport_car', label: 'Машина', glyph: '🚗'),
    CardFaceDefinition(pairId: 'transport_bus', label: 'Автобус', glyph: '🚌'),
    CardFaceDefinition(pairId: 'transport_train', label: 'Поезд', glyph: '🚂'),
    CardFaceDefinition(
        pairId: 'transport_plane', label: 'Самолёт', glyph: '✈️'),
    CardFaceDefinition(
        pairId: 'transport_bike', label: 'Велосипед', glyph: '🚲'),
    CardFaceDefinition(pairId: 'transport_ship', label: 'Корабль', glyph: '🚢'),
    CardFaceDefinition(
        pairId: 'transport_motorcycle', label: 'Мотоцикл', glyph: '🏍️'),
    CardFaceDefinition(
        pairId: 'transport_rocket', label: 'Ракета', glyph: '🚀'),
  ];

  /// Геометрические фигуры: Unicode, не пересекаются с pairId природы (star и т.д.).
  static const List<CardFaceDefinition> shapeFaces = [
    CardFaceDefinition(pairId: 'shape_circle', label: 'Круг', glyph: '●'),
    CardFaceDefinition(pairId: 'shape_square', label: 'Квадрат', glyph: '■'),
    CardFaceDefinition(
        pairId: 'shape_triangle', label: 'Треугольник', glyph: '▲'),
    CardFaceDefinition(pairId: 'shape_diamond', label: 'Ромб', glyph: '◆'),
    CardFaceDefinition(pairId: 'shape_star', label: 'Звезда', glyph: '★'),
    CardFaceDefinition(
        pairId: 'shape_hexagon', label: 'Шестиугольник', glyph: '⬡'),
    CardFaceDefinition(pairId: 'shape_plus', label: 'Плюс', glyph: '＋'),
    CardFaceDefinition(pairId: 'shape_ring', label: 'Кольцо', glyph: '○'),
  ];

  /// Все списки лиц — для findByPairId и проверки уникальности pairId.
  static const List<List<CardFaceDefinition>> _allFaceLists = [
    natureFaces,
    playingCardFaces,
    animalFaces,
    fruitFaces,
    numberFaces,
    transportFaces,
    shapeFaces,
  ];

  List<CardFaceDefinition> getAvailableFaces(DeckKind kind) {
    return switch (kind) {
      DeckKind.nature => natureFaces,
      DeckKind.playingCards => playingCardFaces,
      DeckKind.animals => animalFaces,
      DeckKind.fruits => fruitFaces,
      DeckKind.numbers => numberFaces,
      DeckKind.transport => transportFaces,
      DeckKind.shapes => shapeFaces,
    };
  }

  CardFaceDefinition? findByPairId(String pairId) {
    for (final faces in _allFaceLists) {
      for (final face in faces) {
        if (face.pairId == pairId) {
          return face;
        }
      }
    }
    return null;
  }
}
