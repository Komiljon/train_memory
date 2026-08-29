import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../extensions/deck_kind_ui.dart';
import '../providers/game_notifier.dart';
import '../providers/game_providers.dart';
import '../widgets/branded_loader.dart';
import '../widgets/deck_picker_drawer.dart';
import '../widgets/game_background.dart';
import '../widgets/game_board.dart';
import '../widgets/game_error_card.dart';
import '../widgets/game_hud.dart';
import '../widgets/pair_face_mapper.dart';
import '../widgets/win_overlay.dart';

/// Главный экран memory-игры.
class GamePage extends ConsumerWidget {
  const GamePage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final session = ref.watch(gameNotifierProvider);
    final error = ref.watch(gameErrorProvider);
    final catalog = ref.watch(cardCatalogProvider);
    final deckKind = ref.watch(selectedDeckProvider);
    final mapper = PairFaceMapper(catalog);
    final scheme = Theme.of(context).colorScheme;

    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('Train Memory'),
            Text(
              deckKind.drawerTitle,
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: scheme.onSurfaceVariant,
                  ),
            ),
          ],
        ),
        leading: Builder(
          builder: (context) => IconButton(
            key: const Key('open_deck_drawer'),
            icon: const Icon(Icons.grid_view_rounded),
            tooltip: 'Меню колоды',
            onPressed: () => Scaffold.of(context).openDrawer(),
          ),
        ),
      ),
      drawer: const DeckPickerDrawer(),
      // Builder: context GamePage выше Scaffold, openDrawer из него не найдёт ящик.
      body: Builder(
        builder: (scaffoldContext) {
          return GameBackground(
            child: SafeArea(
              child: Stack(
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      if (error != null)
                        GameErrorCard(
                          message: error.message,
                          onRetry: () =>
                              ref.read(gameNotifierProvider.notifier).restart(),
                        ),
                      if (session.cards.isNotEmpty) ...[
                        GameHud(
                          session: session,
                          onRestart: () =>
                              ref.read(gameNotifierProvider.notifier).restart(),
                        ),
                        Expanded(
                          child: GameBoard(
                            session: session,
                            mapper: mapper,
                            deckKind: deckKind,
                            onCardTap: (index) => ref
                                .read(gameNotifierProvider.notifier)
                                .onCardTapped(index),
                          ),
                        ),
                      ] else if (error == null)
                        const Expanded(child: Center(child: BrandedLoader())),
                    ],
                  ),
                  if (session.isWon)
                    WinOverlay(
                      session: session,
                      deckKind: deckKind,
                      onPlayAgain: () =>
                          ref.read(gameNotifierProvider.notifier).restart(),
                      onChangeDeck: () {
                        Scaffold.of(scaffoldContext).openDrawer();
                      },
                    ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
