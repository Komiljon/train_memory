import 'package:flutter/material.dart';

import '../../../../core/constants/game_constants.dart';
import '../../domain/entities/game_phase.dart';
import '../../domain/entities/game_session.dart';
import '../../domain/entities/memory_card.dart';
import 'memory_flip_card.dart';
import 'pair_face_mapper.dart';

/// Сетка карт: адаптивные колонки, Key = card.id.
class GameBoard extends StatelessWidget {
  const GameBoard({
    super.key,
    required this.session,
    required this.mapper,
    required this.onCardTap,
  });

  final GameSession session;
  final PairFaceMapper mapper;
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

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final crossAxisCount =
            constraints.maxWidth >= kWideLayoutBreakpoint ? 4 : 2;

        return GridView.builder(
          padding: const EdgeInsets.all(12),
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: crossAxisCount,
            crossAxisSpacing: 12,
            mainAxisSpacing: 12,
            childAspectRatio: 0.85,
          ),
          itemCount: session.cards.length,
          itemBuilder: (context, index) {
            final card = session.cards[index];
            return MemoryFlipCard(
              key: Key(card.id),
              card: card,
              mapper: mapper,
              enabled: _isCardEnabled(card, session.phase),
              onTap: () => onCardTap(index),
            );
          },
        );
      },
    );
  }
}
