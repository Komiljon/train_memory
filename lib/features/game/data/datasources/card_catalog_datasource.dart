/// Описание лица пары в каталоге (без Flutter).
class CardFaceDefinition {
  const CardFaceDefinition({
    required this.pairId,
    required this.label,
    this.assetPath,
  });

  final String pairId;
  final String label;

  /// Опциональный asset; если null — UI рисует иконку/цвет.
  final String? assetPath;
}

/// Статический каталог лиц: расширяется без смены domain.
class CardCatalogDataSource {
  const CardCatalogDataSource();

  /// Доступные пары; pairId уникален.
  static const List<CardFaceDefinition> faces = [
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

  List<CardFaceDefinition> getAvailableFaces() => faces;

  CardFaceDefinition? findByPairId(String pairId) {
    for (final face in faces) {
      if (face.pairId == pairId) {
        return face;
      }
    }
    return null;
  }
}
