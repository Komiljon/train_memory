import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/constants/game_constants.dart';
import '../../../../core/error/failure.dart';
import '../../domain/entities/game_phase.dart';
import '../../domain/entities/game_session.dart';
import '../../domain/usecases/flip_card.dart';
import 'game_providers.dart';

/// Состояние партии и оркестрация use case (не из build виджета).
class GameNotifier extends Notifier<GameSession> {
  /// Счётчик resolve-операций: после await проверяем, что партия не перезапущена.
  int _resolveGeneration = 0;

  @override
  GameSession build() {
    return _startNewSession();
  }

  /// Тап по карте: flip → при mismatch пауза → hide.
  Future<void> onCardTapped(int index) async {
    final flipUseCase = ref.read(flipCardUseCaseProvider);
    final result = flipUseCase(state, index);

    if (result is FlipCardIgnored) {
      return;
    }

    if (result is! FlipCardApplied) {
      return;
    }

    state = result.session;

    if (result.session.phase != GamePhase.resolving) {
      return;
    }

    final generation = ++_resolveGeneration;
    await Future<void>.delayed(kMismatchDelay);

    // Riverpod 2.x не даёт ref.mounted — generation отсекает устаревший await.
    if (generation != _resolveGeneration) {
      return;
    }

    final hideUseCase = ref.read(hideUnmatchedProvider);
    state = hideUseCase(state);
  }

  /// Новая партия с тем же числом пар.
  void restart() {
    _resolveGeneration++;
    state = _startNewSession();
  }

  GameSession _startNewSession() {
    try {
      ref.read(gameErrorProvider.notifier).state = null;
      final startGame = ref.read(startGameProvider);
      return startGame(pairCount: kPairCount);
    } on Failure catch (failure) {
      ref.read(gameErrorProvider.notifier).state = failure;
      return const GameSession(
        cards: [],
        phase: GamePhase.idle,
        moves: 0,
      );
    }
  }
}

/// Провайдер Notifier партии.
final gameNotifierProvider =
    NotifierProvider<GameNotifier, GameSession>(GameNotifier.new);
