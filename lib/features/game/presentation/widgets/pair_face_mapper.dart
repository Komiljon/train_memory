import 'package:flutter/material.dart';

import '../../data/datasources/card_catalog_datasource.dart';
import '../../domain/entities/card_suit.dart';

/// Маппинг pairId → иконка, подпись или ранг/масть (presentation-only).
class PairFaceMapper {
  const PairFaceMapper(this._catalog);

  final CardCatalogDataSource _catalog;

  static const Map<String, IconData> _icons = {
    'star': Icons.star_rounded,
    'heart': Icons.favorite_rounded,
    'moon': Icons.nightlight_rounded,
    'sun': Icons.wb_sunny_rounded,
    'cloud': Icons.cloud_rounded,
    'bolt': Icons.bolt_rounded,
    'leaf': Icons.eco_rounded,
    'fish': Icons.set_meal_rounded,
    'vish': Icons.image_rounded,
  };

  IconData iconFor(String pairId) {
    return _icons[pairId] ?? Icons.help_outline_rounded;
  }

  String labelFor(String pairId) {
    return _catalog.findByPairId(pairId)?.label ?? pairId;
  }

  String? assetPathFor(String pairId) {
    return _catalog.findByPairId(pairId)?.assetPath;
  }

  /// Эмодзи, цифра или Unicode-символ для тематических колод.
  String? glyphFor(String pairId) {
    return _catalog.findByPairId(pairId)?.glyph;
  }

  String? rankFor(String pairId) {
    return _catalog.findByPairId(pairId)?.rank;
  }

  CardSuit? suitFor(String pairId) {
    return _catalog.findByPairId(pairId)?.suit;
  }

  /// Цвет лица из pairId — стабильный hue без хардкода в виджете (колода «природа»).
  Color colorFor(String pairId, ColorScheme scheme) {
    final hash = pairId.hashCode.abs();
    final hues = [
      scheme.primary,
      scheme.secondary,
      scheme.tertiary,
      scheme.error,
      scheme.primaryContainer,
      scheme.secondaryContainer,
      scheme.tertiaryContainer,
      scheme.inversePrimary,
    ];
    return hues[hash % hues.length];
  }
}
