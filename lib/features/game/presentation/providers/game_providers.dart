import 'dart:math';

import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/error/failure.dart';
import '../../data/datasources/card_catalog_datasource.dart';
import '../../data/repositories/game_repository_impl.dart';
import '../../domain/entities/deck_kind.dart';
import '../../domain/repositories/game_repository.dart';
import '../../domain/usecases/flip_card.dart';
import '../../domain/usecases/hide_unmatched.dart';
import '../../domain/usecases/start_game.dart';

/// Выбранная колода; по умолчанию — природа (поведение как до игральных карт).
final selectedDeckProvider = StateProvider<DeckKind>((ref) => DeckKind.nature);

/// Каталог лиц — singleton на сессию приложения.
final cardCatalogProvider = Provider<CardCatalogDataSource>(
  (ref) => const CardCatalogDataSource(),
);

/// Random для перемешивания; в тестах переопределяется через seed.
final randomProvider = Provider<Random>((ref) => Random());

final gameRepositoryProvider = Provider<GameRepository>(
  (ref) => GameRepositoryImpl(
    catalog: ref.watch(cardCatalogProvider),
    random: ref.watch(randomProvider),
  ),
);

final startGameProvider = Provider<StartGame>(
  (ref) => StartGame(ref.watch(gameRepositoryProvider)),
);

final flipCardUseCaseProvider = Provider<FlipCardUseCase>(
  (ref) => const FlipCardUseCase(),
);

final hideUnmatchedProvider = Provider<HideUnmatched>(
  (ref) => const HideUnmatched(),
);

/// Ошибка старта партии (каталог, колода) — показывается в UI.
final gameErrorProvider = StateProvider<Failure?>((ref) => null);
