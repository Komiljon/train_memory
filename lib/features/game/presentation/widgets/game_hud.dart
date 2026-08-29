import 'package:flutter/material.dart';

import '../../domain/entities/game_session.dart';

/// Компактная панель: одна строка, чтобы сетка 4×4 получила больше высоты.
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
      padding: const EdgeInsets.fromLTRB(8, 2, 8, 4),
      child: Row(
        children: [
          Expanded(
            child: _StatChip(
              label: 'Ходы',
              value: '${session.moves}',
            ),
          ),
          const SizedBox(width: 6),
          Expanded(
            child: _StatChip(
              label: 'Пары',
              value: '$_matchedPairs / ${session.pairCount}',
            ),
          ),
          const SizedBox(width: 6),
          FilledButton.tonalIcon(
            onPressed: onRestart,
            style: FilledButton.styleFrom(
              visualDensity: VisualDensity.compact,
              tapTargetSize: MaterialTapTargetSize.shrinkWrap,
              minimumSize: Size.zero,
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
            ),
            icon: const Icon(Icons.refresh_rounded, size: 18),
            label: const Text('Заново'),
          ),
        ],
      ),
    );
  }
}

/// Подпись и значение в одну линию — без пустой высоты двухстрочного чипа.
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
    final textTheme = Theme.of(context).textTheme;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
      decoration: BoxDecoration(
        color: scheme.surfaceContainerHighest,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        children: [
          Flexible(
            child: Text(
              label,
              style: textTheme.labelSmall?.copyWith(
                color: scheme.onSurfaceVariant,
              ),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ),
          const SizedBox(width: 6),
          Text(
            value,
            style: textTheme.titleSmall?.copyWith(
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }
}
