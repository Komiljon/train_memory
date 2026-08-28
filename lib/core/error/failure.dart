/// Доменные/прикладные сбои без привязки к Flutter.
/// Инвариант: Failure — значение, не исключение; UI решает, как показать.
sealed class Failure {
  const Failure(this.message);

  final String message;
}

/// Недостаточно лиц в каталоге для запрошенного числа пар.
final class InsufficientCatalogFailure extends Failure {
  const InsufficientCatalogFailure({
    required int pairCount,
    required int availablePairs,
  }) : super(
          'Нужно $pairCount пар, в каталоге только $availablePairs',
        );
}

/// Колода не прошла проверку инвариантов (чётность, дубликаты pairId).
final class InvalidDeckFailure extends Failure {
  const InvalidDeckFailure(super.message);
}
