import '../../domain/entities/deck_kind.dart';

/// Русские названия колод для Drawer (presentation-only, domain без Flutter).
extension DeckKindUiX on DeckKind {
  String get drawerTitle => switch (this) {
        DeckKind.nature => 'Символы природы',
        DeckKind.playingCards => 'Колода карт',
        DeckKind.animals => 'Животные',
        DeckKind.fruits => 'Фрукты и ягоды',
        DeckKind.numbers => 'Цифры',
        DeckKind.transport => 'Транспорт',
        DeckKind.shapes => 'Фигуры',
      };
}
