/// Карта на поле: id уникален, pairId связывает пару.
class MemoryCard {
  const MemoryCard({
    required this.id,
    required this.pairId,
    this.isFaceUp = false,
    this.isMatched = false,
  });

  final String id;
  final String pairId;
  final bool isFaceUp;
  final bool isMatched;

  MemoryCard copyWith({
    bool? isFaceUp,
    bool? isMatched,
  }) {
    return MemoryCard(
      id: id,
      pairId: pairId,
      isFaceUp: isFaceUp ?? this.isFaceUp,
      isMatched: isMatched ?? this.isMatched,
    );
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is MemoryCard &&
          id == other.id &&
          pairId == other.pairId &&
          isFaceUp == other.isFaceUp &&
          isMatched == other.isMatched;

  @override
  int get hashCode => Object.hash(id, pairId, isFaceUp, isMatched);
}
