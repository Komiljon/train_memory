import 'package:flutter/material.dart';

import '../../../../core/constants/game_constants.dart';
import '../../domain/entities/deck_kind.dart';
import '../../domain/entities/game_phase.dart';
import '../../domain/entities/game_session.dart';
import '../../domain/entities/memory_card.dart';
import 'memory_flip_card.dart';
import 'pair_face_mapper.dart';

/// Сетка 4×4: высота ячейки считается из доступного места, прокрутки нет.
class GameBoard extends StatelessWidget {
  const GameBoard({
    super.key,
    required this.session,
    required this.mapper,
    required this.deckKind,
    required this.onCardTap,
  });

  final GameSession session;
  final PairFaceMapper mapper;
  final DeckKind deckKind;
  final ValueChanged<int> onCardTap;

  bool _isCardEnabled(MemoryCard card, GamePhase phase) {
    if (phase == GamePhase.resolving || phase == GamePhase.won) {
      return false;
    }
    if (card.isMatched || card.isFaceUp) {
      return false;
    }
    return true;
  }

  /// Высота одной клетки: 4 ряда + отступы + зазоры = [maxHeight].
  /// Вычитаем 0.5 px, чтобы погрешность layout не дала overflow на 1 пиксель.
  double _cellExtent(double maxHeight) {
    const gaps = kBoardSpacing * (kGridSize - 1);
    const insets = kBoardPadding * 2;
    final inner = maxHeight - insets - gaps;
    if (inner <= 1) {
      return 1;
    }
    return (inner / kGridSize) - 0.5;
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        return GridView.builder(
          physics: const NeverScrollableScrollPhysics(),
          primary: false,
          padding: const EdgeInsets.all(kBoardPadding),
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: kGridSize,
            crossAxisSpacing: kBoardSpacing,
            mainAxisSpacing: kBoardSpacing,
            mainAxisExtent: _cellExtent(constraints.maxHeight),
          ),
          itemCount: session.cards.length,
          itemBuilder: (context, index) {
            final card = session.cards[index];
            return MemoryFlipCard(
              key: Key(card.id),
              card: card,
              mapper: mapper,
              deckKind: deckKind,
              enabled: _isCardEnabled(card, session.phase),
              onTap: () => onCardTap(index),
            );
          },
        );
      },
    );
  }
}
