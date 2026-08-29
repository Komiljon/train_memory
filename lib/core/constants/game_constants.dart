/// Размер поля: N колонок × N рядов. Все карты должны быть видны без прокрутки.
const int kGridSize = 4;

/// Число пар = половина клеток поля (4×4 → 8 пар / 16 карт).
const int kPairCount = (kGridSize * kGridSize) ~/ 2;

/// Задержка перед закрытием двух несовпавших карт (мс).
const Duration kMismatchDelay = Duration(milliseconds: 900);

/// Внутренний отступ сетки; держим небольшим, чтобы клетки оставались крупными.
const double kBoardPadding = 8;

/// Зазор между картами в сетке 4×4.
const double kBoardSpacing = 8;
