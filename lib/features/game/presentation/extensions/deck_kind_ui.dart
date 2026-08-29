import 'package:flutter/material.dart';

import '../../domain/entities/deck_kind.dart';

/// UI-метаданные колод: названия, иконки и описания для drawer.
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

  String get deckSubtitle => switch (this) {
        DeckKind.nature => '8 пар · иконки природы',
        DeckKind.playingCards => '8 пар · классические карты',
        DeckKind.animals => '8 пар · эмодзи животных',
        DeckKind.fruits => '8 пар · фрукты и ягоды',
        DeckKind.numbers => '8 пар · цифры 1–8',
        DeckKind.transport => '8 пар · виды транспорта',
        DeckKind.shapes => '8 пар · геометрические фигуры',
      };

  /// Asset-иконка колоды; fallback — Material Icon.
  String get deckIconAsset => 'assets/images/decks/$name.png';

  IconData get deckFallbackIcon => switch (this) {
        DeckKind.nature => Icons.nature_people_rounded,
        DeckKind.playingCards => Icons.style_rounded,
        DeckKind.animals => Icons.pets_rounded,
        DeckKind.fruits => Icons.local_florist_rounded,
        DeckKind.numbers => Icons.pin_rounded,
        DeckKind.transport => Icons.directions_car_rounded,
        DeckKind.shapes => Icons.category_rounded,
      };

  /// Акцент drawer-карточки: hash от enum, не хардкод в виджете.
  Color deckAccentColor(ColorScheme scheme) {
    final palette = <Color>[
      scheme.tertiary,
      scheme.primary,
      scheme.secondary,
      scheme.error,
      scheme.primaryContainer,
      scheme.secondaryContainer,
      scheme.tertiaryContainer,
    ];
    return palette[index % palette.length];
  }
}
