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
import 'package:train_memory/features/game/presentation/widgets/win_overlay.dart';

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

Widget _testApp({required Widget child, List<Override> overrides = const []}) {
  return ProviderScope(
    overrides: overrides,
    child: MaterialApp(theme: buildLightTheme(), home: child),
  );
}

void main() {
  testWidgets('GamePage показывает сетку и HUD с фиксированной колодой',
      (tester) async {
    await tester.pumpWidget(
      _testApp(
        child: const GamePage(),
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
      ),
    );

    await tester.pump();

    expect(find.text('Train Memory'), findsOneWidget);
    expect(find.text('Символы природы'), findsWidgets);
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
      _testApp(
        child: const GamePage(),
        overrides: [
          gameRepositoryProvider.overrideWithValue(_FixedDeckRepository()),
        ],
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
      _testApp(
        child: const GamePage(),
        overrides: [
          gameRepositoryProvider.overrideWithValue(_FixedDeckRepository()),
        ],
      ),
    );

    await tester.pump();

    await tester.tap(find.byKey(const Key('open_deck_drawer')));
    await tester.pumpAndSettle();

    expect(find.text('Выберите колоду'), findsOneWidget);
    for (final kind in DeckKind.values) {
      final option = find.byKey(Key('deck_option_${kind.name}'));
      await tester.scrollUntilVisible(
        option,
        120,
        scrollable: find.byType(Scrollable).first,
      );
      expect(option, findsOneWidget);
    }

    await tester.tap(find.byKey(const Key('deck_option_animals')));
    await tester.pumpAndSettle();

    expect(find.byType(Drawer), findsNothing);
  });

  testWidgets('WinOverlay появляется при GamePhase.won', (tester) async {
    await tester.pumpWidget(
      _testApp(
        child: const GamePage(),
        overrides: [
          gameRepositoryProvider.overrideWithValue(_FixedDeckRepository()),
          gameNotifierProvider.overrideWith(
            () => _TestGameNotifier(
              const GameSession(
                cards: [
                  MemoryCard(id: 'a', pairId: 'star', isMatched: true),
                  MemoryCard(id: 'b', pairId: 'moon', isMatched: true),
                ],
                phase: GamePhase.won,
                moves: 5,
              ),
            ),
          ),
        ],
      ),
    );

    await tester.pump();

    expect(find.byType(WinOverlay), findsOneWidget);
    expect(find.text('Все пары найдены!'), findsOneWidget);
    expect(
      find.descendant(
        of: find.byType(WinOverlay),
        matching: find.text('5'),
      ),
      findsOneWidget,
    );
    expect(find.text('Играть снова'), findsOneWidget);
  });

  testWidgets('кнопка «Сменить колоду» на победе открывает drawer',
      (tester) async {
    await tester.pumpWidget(
      _testApp(
        child: const GamePage(),
        overrides: [
          gameRepositoryProvider.overrideWithValue(_FixedDeckRepository()),
          gameNotifierProvider.overrideWith(
            () => _TestGameNotifier(
              const GameSession(
                cards: [
                  MemoryCard(id: 'a', pairId: 'star', isMatched: true),
                  MemoryCard(id: 'b', pairId: 'moon', isMatched: true),
                ],
                phase: GamePhase.won,
                moves: 5,
              ),
            ),
          ),
        ],
      ),
    );

    await tester.pump();
    await tester.tap(find.byKey(const Key('win_change_deck')));
    await tester.pumpAndSettle();

    expect(find.byType(Drawer), findsOneWidget);
    expect(find.text('Выберите колоду'), findsOneWidget);
  });
}

/// Notifier с заранее заданным состоянием для тестов.
class _TestGameNotifier extends GameNotifier {
  _TestGameNotifier(this._initial);

  final GameSession _initial;

  @override
  GameSession build() => _initial;
}
