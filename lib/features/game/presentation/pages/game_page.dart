import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../domain/entities/game_phase.dart';
import '../providers/game_notifier.dart';
import '../providers/game_providers.dart';
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
    final mapper = PairFaceMapper(catalog);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Train Memory'),
      ),
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
              if (session.phase == GamePhase.won)
                GameWinBanner(
                  moves: session.moves,
                  onPlayAgain: () =>
                      ref.read(gameNotifierProvider.notifier).restart(),
                ),
              Expanded(
                child: GameBoard(
                  session: session,
                  mapper: mapper,
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
