import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:train_memory/core/constants/game_constants.dart';
import 'package:train_memory/core/theme/app_theme.dart';
import 'package:train_memory/features/game/domain/entities/deck_kind.dart';
import 'package:train_memory/features/game/domain/entities/game_phase.dart';
import 'package:train_memory/features/game/domain/entities/game_session.dart';
import 'package:train_memory/features/game/domain/entities/memory_card.dart';
import 'package:train_memory/features/game/domain/repositories/game_repository.dart';
import 'package:train_memory/features/game/presentation/pages/game_page.dart';
import 'package:train_memory/features/game/presentation/providers/game_notifier.dart';
import 'package:train_memory/features/game/presentation/providers/game_providers.dart';

/// Фиксированная колода для предсказуемого widget-теста.
class _FixedDeckRepository implements GameRepository {
  @override
  List<MemoryCard> createShuffledDeck({
    required int pairCount,
    required DeckKind deckKind,
  }) {
    return const [
      MemoryCard(id: 'a', pairId: 'star'),
      MemoryCard(id: 'b', pairId: 'moon'),
      MemoryCard(id: 'c', pairId: 'star'),
      MemoryCard(id: 'd', pairId: 'moon'),
    ];
  }
}

void main() {
  testWidgets('GamePage показывает сетку и HUD с фиксированной колодой',
      (tester) async {
    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          gameRepositoryProvider.overrideWithValue(_FixedDeckRepository()),
          gameNotifierProvider.overrideWith(
            () => _TestGameNotifier(
              const GameSession(
                cards: [
                  MemoryCard(id: 'a', pairId: 'star'),
                  MemoryCard(id: 'b', pairId: 'moon'),
                  MemoryCard(id: 'c', pairId: 'star'),
                  MemoryCard(id: 'd', pairId: 'moon'),
                ],
                phase: GamePhase.idle,
                moves: 0,
              ),
            ),
          ),
        ],
        child: MaterialApp(theme: buildAppTheme(), home: const GamePage()),
      ),
    );

    await tester.pump();

    expect(find.text('Train Memory'), findsOneWidget);
    expect(find.text('Ходы'), findsOneWidget);
    expect(find.text('Пары'), findsOneWidget);
    expect(find.byKey(const Key('a')), findsOneWidget);
    expect(find.byKey(const Key('b')), findsOneWidget);
    expect(find.byKey(const Key('c')), findsOneWidget);
    expect(find.byKey(const Key('d')), findsOneWidget);

    final grid = tester.widget<GridView>(find.byType(GridView));
    final delegate =
        grid.gridDelegate as SliverGridDelegateWithFixedCrossAxisCount;
    expect(delegate.crossAxisCount, kGridSize);
    expect(grid.physics, isA<NeverScrollableScrollPhysics>());
  });

  testWidgets('тап по карте обновляет счётчик ходов', (tester) async {
    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          gameRepositoryProvider.overrideWithValue(_FixedDeckRepository()),
        ],
        child: MaterialApp(theme: buildAppTheme(), home: const GamePage()),
      ),
    );

    await tester.pump();

    await tester.tap(find.byKey(const Key('a')));
    await tester.pump(const Duration(milliseconds: 400));

    await tester.tap(find.byKey(const Key('c')));
    await tester.pump(const Duration(milliseconds: 400));

    expect(find.text('1'), findsOneWidget);
  });

  testWidgets('drawer показывает все колоды и позволяет выбрать животных',
      (tester) async {
    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          gameRepositoryProvider.overrideWithValue(_FixedDeckRepository()),
        ],
        child: MaterialApp(theme: buildAppTheme(), home: const GamePage()),
      ),
    );

    await tester.pump();

    await tester.tap(find.byKey(const Key('open_deck_drawer')));
    await tester.pumpAndSettle();

    expect(find.text('Колода'), findsOneWidget);
    for (final title in [
      'Символы природы',
      'Колода карт',
      'Животные',
      'Фрукты и ягоды',
      'Цифры',
      'Транспорт',
      'Фигуры',
    ]) {
      expect(find.text(title), findsOneWidget);
    }

    await tester.tap(find.byKey(const Key('deck_option_animals')));
    await tester.pumpAndSettle();

    expect(find.byType(Drawer), findsNothing);
  });
}

/// Notifier с заранее заданным состоянием для первого теста.
class _TestGameNotifier extends GameNotifier {
  _TestGameNotifier(this._initial);

  final GameSession _initial;

  @override
  GameSession build() => _initial;
}
