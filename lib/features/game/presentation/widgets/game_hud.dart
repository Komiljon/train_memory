import 'package:flutter/material.dart';

import '../../domain/entities/game_session.dart';

/// Панель статистики и управления партией.
class GameHud extends StatelessWidget {
  const GameHud({
    super.key,
    required this.session,
    required this.onRestart,
  });

  final GameSession session;
  final VoidCallback onRestart;

  int get _matchedPairs {
    return session.cards.where((c) => c.isMatched).length ~/ 2;
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Row(
        children: [
          Expanded(
            child: _StatChip(
              label: 'Ходы',
              value: '${session.moves}',
            ),
          ),
          const SizedBox(width: 8),
          Expanded(
            child: _StatChip(
              label: 'Пары',
              value: '$_matchedPairs / ${session.pairCount}',
            ),
          ),
          const SizedBox(width: 8),
          FilledButton.tonalIcon(
            onPressed: onRestart,
            icon: const Icon(Icons.refresh_rounded),
            label: const Text('Заново'),
          ),
        ],
      ),
    );
  }
}

class _StatChip extends StatelessWidget {
  const _StatChip({
    required this.label,
    required this.value,
  });

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
      decoration: BoxDecoration(
        color: scheme.surfaceContainerHighest,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: Theme.of(context).textTheme.labelSmall?.copyWith(
                  color: scheme.onSurfaceVariant,
                ),
          ),
          Text(
            value,
            style: Theme.of(context).textTheme.titleMedium,
          ),
        ],
      ),
    );
  }
}

/// Баннер победы — без отдельного роута.
class GameWinBanner extends StatelessWidget {
  const GameWinBanner({
    super.key,
    required this.moves,
    required this.onPlayAgain,
  });

  final int moves;
  final VoidCallback onPlayAgain;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;

    return MaterialBanner(
      backgroundColor: scheme.primaryContainer,
      content: Text(
        'Победа! Ходов: $moves',
        style: TextStyle(color: scheme.onPrimaryContainer),
      ),
      actions: [
        TextButton(
          onPressed: onPlayAgain,
          child: const Text('Играть снова'),
        ),
      ],
    );
  }
}
