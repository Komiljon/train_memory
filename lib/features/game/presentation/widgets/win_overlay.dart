import 'package:flutter/material.dart';

import '../../../../core/theme/app_tokens.dart';
import '../../domain/entities/game_session.dart';
import '../extensions/deck_kind_ui.dart';
import '../../domain/entities/deck_kind.dart';

/// Overlay победы: статистика партии и CTA.
class WinOverlay extends StatelessWidget {
  const WinOverlay({
    super.key,
    required this.session,
    required this.deckKind,
    required this.onPlayAgain,
    required this.onChangeDeck,
  });

  final GameSession session;
  final DeckKind deckKind;
  final VoidCallback onPlayAgain;
  final VoidCallback onChangeDeck;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final tokens = context.appTokens;
    final textTheme = Theme.of(context).textTheme;

    return Semantics(
      liveRegion: true,
      label: 'Все пары найдены. Ходов: ${session.moves}',
      child: ColoredBox(
        color: scheme.scrim.withValues(alpha: 0.55),
        child: Center(
          child: TweenAnimationBuilder<double>(
            tween: Tween(begin: 0.85, end: 1),
            duration: const Duration(milliseconds: 320),
            curve: Curves.easeOutBack,
            builder: (context, scale, child) {
              return Transform.scale(scale: scale, child: child);
            },
            child: Material(
              color: scheme.surfaceContainerLow,
              elevation: 8,
              borderRadius: BorderRadius.circular(tokens.radiusDialog),
              child: ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 340),
                child: Padding(
                  padding: EdgeInsets.all(tokens.spacingLg),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        Icons.emoji_events_rounded,
                        size: 48,
                        color: scheme.primary,
                      ),
                      SizedBox(height: tokens.spacingSm),
                      Text(
                        'Все пары найдены!',
                        style: textTheme.headlineMedium,
                        textAlign: TextAlign.center,
                      ),
                      SizedBox(height: tokens.spacingMd),
                      _StatRow(
                        label: 'Ходов',
                        value: '${session.moves}',
                      ),
                      _StatRow(
                        label: 'Колода',
                        value: deckKind.drawerTitle,
                      ),
                      SizedBox(height: tokens.spacingLg),
                      SizedBox(
                        width: double.infinity,
                        child: FilledButton(
                          onPressed: onPlayAgain,
                          child: const Text('Играть снова'),
                        ),
                      ),
                      SizedBox(height: tokens.spacingSm),
                      SizedBox(
                        width: double.infinity,
                        child: OutlinedButton(
                          key: const Key('win_change_deck'),
                          onPressed: onChangeDeck,
                          child: const Text('Сменить колоду'),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _StatRow extends StatelessWidget {
  const _StatRow({required this.label, required this.value});

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        children: [
          Expanded(
            child: Text(
              label,
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: scheme.onSurfaceVariant,
                  ),
            ),
          ),
          Text(
            value,
            style: Theme.of(context).textTheme.titleSmall,
          ),
        ],
      ),
    );
  }
}
