import 'package:flutter/material.dart';

import '../../../../core/theme/app_tokens.dart';
import '../../domain/entities/game_session.dart';

/// Панель статистики: stat cards, прогресс пар и кнопка перезапуска.
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

  double get _pairProgress {
    if (session.pairCount == 0) {
      return 0;
    }
    return _matchedPairs / session.pairCount;
  }

  @override
  Widget build(BuildContext context) {
    final tokens = context.appTokens;
    final scheme = Theme.of(context).colorScheme;

    return Padding(
      padding: EdgeInsets.fromLTRB(
        tokens.spacingSm,
        tokens.spacingXs,
        tokens.spacingSm,
        tokens.spacingSm,
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: _StatCard(
              icon: Icons.touch_app_rounded,
              label: 'Ходы',
              value: '${session.moves}',
            ),
          ),
          SizedBox(width: tokens.spacingSm),
          Expanded(
            flex: 2,
            child: _StatCard(
              icon: Icons.grid_view_rounded,
              label: 'Пары',
              value: '$_matchedPairs / ${session.pairCount}',
              progress: _pairProgress,
            ),
          ),
          SizedBox(width: tokens.spacingSm),
          FilledButton.icon(
            onPressed: onRestart,
            style: FilledButton.styleFrom(
              visualDensity: VisualDensity.compact,
              padding: EdgeInsets.symmetric(
                horizontal: tokens.spacingMd,
                vertical: tokens.spacingSm,
              ),
              backgroundColor: scheme.primary,
              foregroundColor: scheme.onPrimary,
            ),
            icon: const Icon(Icons.refresh_rounded, size: 18),
            label: const Text('Заново'),
          ),
        ],
      ),
    );
  }
}

class _StatCard extends StatelessWidget {
  const _StatCard({
    required this.icon,
    required this.label,
    required this.value,
    this.progress,
  });

  final IconData icon;
  final String label;
  final String value;
  final double? progress;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final tokens = context.appTokens;
    final textTheme = Theme.of(context).textTheme;

    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: tokens.spacingSm,
        vertical: tokens.spacingSm,
      ),
      decoration: BoxDecoration(
        color: scheme.surfaceContainerHighest.withValues(alpha: 0.85),
        borderRadius: BorderRadius.circular(tokens.radiusChip),
        border: Border.all(
          color: scheme.outlineVariant.withValues(alpha: 0.5),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(icon, size: 14, color: scheme.primary),
              SizedBox(width: tokens.spacingXs),
              Expanded(
                child: Text(
                  label,
                  style: textTheme.labelSmall?.copyWith(
                    color: scheme.onSurfaceVariant,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              Text(
                value,
                style: textTheme.titleSmall?.copyWith(
                  fontWeight: FontWeight.w700,
                ),
              ),
            ],
          ),
          if (progress != null) ...[
            SizedBox(height: tokens.spacingXs),
            ClipRRect(
              borderRadius: BorderRadius.circular(2),
              child: LinearProgressIndicator(
                value: progress,
                minHeight: 3,
              ),
            ),
          ],
        ],
      ),
    );
  }
}
