import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../providers/game_notifier.dart';
import '../providers/game_providers.dart';
import '../widgets/deck_picker_drawer.dart';
import '../widgets/game_board.dart';
import '../widgets/game_hud.dart';
import '../widgets/pair_face_mapper.dart';

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

    return Scaffold(
      appBar: AppBar(
        title: const Text('Train Memory'),
        leading: Builder(
          builder: (context) => IconButton(
            key: const Key('open_deck_drawer'),
            icon: const Icon(Icons.menu),
            tooltip: 'Меню колоды',
            onPressed: () => Scaffold.of(context).openDrawer(),
          ),
        ),
      ),
      drawer: const DeckPickerDrawer(),
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            if (error != null)
              MaterialBanner(
                backgroundColor: Theme.of(context).colorScheme.errorContainer,
                content: Text(error.message),
                actions: [
                  TextButton(
                    onPressed: () =>
                        ref.read(gameNotifierProvider.notifier).restart(),
                    child: const Text('Повторить'),
                  ),
                ],
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
              const Expanded(
                child: Center(child: CircularProgressIndicator()),
              ),
          ],
        ),
      ),
    );
  }
}
