/// Масть игральной карты (domain, без Flutter).
enum CardSuit {
  hearts,
  diamonds,
  clubs,
  spades;

  /// Червы и бубны — красные; трефы и пики — чёрные.
  bool get isRed => this == hearts || this == diamonds;

  /// Символ масти для отрисовки на лице карты.
  String get glyph => switch (this) {
        hearts => '♥',
        diamonds => '♦',
        clubs => '♣',
        spades => '♠',
      };
}
