import 'package:flutter/material.dart';

import '../../../../core/constants/game_constants.dart';
import '../../../../core/theme/app_tokens.dart';
import '../../domain/entities/deck_kind.dart';
import '../../domain/entities/game_phase.dart';
import '../../domain/entities/game_session.dart';
import '../../domain/entities/memory_card.dart';
import 'memory_flip_card.dart';
import 'pair_face_mapper.dart';

/// Сетка 4×4: адаптивные отступы и maxWidth на широких экранах.
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

  /// Индексы карт, участвующих в текущем mismatch (для shake).
  Set<int> _mismatchIndices(GameSession session) {
    if (session.phase != GamePhase.resolving) {
      return const {};
    }
    final first = session.firstFlippedIndex;
    if (first == null) {
      return const {};
    }
    final result = <int>{first};
    for (var i = 0; i < session.cards.length; i++) {
      if (i != first &&
          session.cards[i].isFaceUp &&
          !session.cards[i].isMatched) {
        result.add(i);
      }
    }
    return result;
  }

  double _boardPadding(double maxWidth) {
    if (maxWidth >= 600) {
      return kBoardPadding + 4;
    }
    if (maxWidth < 360) {
      return kBoardPadding - 2;
    }
    return kBoardPadding;
  }

  double _boardSpacing(double maxWidth) {
    if (maxWidth >= 600) {
      return kBoardSpacing + 2;
    }
    return kBoardSpacing;
  }

  double _cellExtent(double maxHeight, double padding, double spacing) {
    const gaps = kGridSize - 1;
    final insets = padding * 2;
    final inner = maxHeight - insets - spacing * gaps;
    if (inner <= 1) {
      return 1;
    }
    return (inner / kGridSize) - 0.5;
  }

  @override
  Widget build(BuildContext context) {
    final tokens = context.appTokens;
    final mismatchSet = _mismatchIndices(session);

    return LayoutBuilder(
      builder: (context, constraints) {
        final padding = _boardPadding(constraints.maxWidth);
        final spacing = _boardSpacing(constraints.maxWidth);
        final cellExtent = _cellExtent(
          constraints.maxHeight,
          padding,
          spacing,
        );

        final grid = GridView.builder(
          physics: const NeverScrollableScrollPhysics(),
          primary: false,
          padding: EdgeInsets.all(padding),
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: kGridSize,
            crossAxisSpacing: spacing,
            mainAxisSpacing: spacing,
            mainAxisExtent: cellExtent,
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
              isResolvingMismatch: mismatchSet.contains(index),
              onTap: () => onCardTap(index),
            );
          },
        );

        return Align(
          child: ConstrainedBox(
            constraints: BoxConstraints(maxWidth: tokens.boardMaxWidth),
            child: grid,
          ),
        );
      },
    );
  }
}
