import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../domain/entities/deck_kind.dart';
import '../providers/game_providers.dart';

/// Боковое меню выбора колоды: смена kind перезапускает партию через watch в Notifier.
class DeckPickerDrawer extends ConsumerWidget {
  const DeckPickerDrawer({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final selected = ref.watch(selectedDeckProvider);

    return Drawer(
      child: SafeArea(
        child: Semantics(
          label: 'Выбор колоды',
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Padding(
                padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
                child: Text(
                  'Колода',
                  style: Theme.of(context).textTheme.titleLarge,
                ),
              ),
              _DeckOptionTile(
                key: const Key('deck_option_nature'),
                title: 'Символы природы',
                selected: selected == DeckKind.nature,
                onTap: () => _selectDeck(context, ref, DeckKind.nature),
              ),
              _DeckOptionTile(
                key: const Key('deck_option_playing_cards'),
                title: 'Колода карт',
                selected: selected == DeckKind.playingCards,
                onTap: () => _selectDeck(context, ref, DeckKind.playingCards),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _selectDeck(BuildContext context, WidgetRef ref, DeckKind kind) {
    ref.read(selectedDeckProvider.notifier).state = kind;
    Navigator.of(context).pop();
  }
}

class _DeckOptionTile extends StatelessWidget {
  const _DeckOptionTile({
    super.key,
    required this.title,
    required this.selected,
    required this.onTap,
  });

  final String title;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Text(title),
      selected: selected,
      trailing: selected ? const Icon(Icons.check_rounded) : null,
      onTap: onTap,
    );
  }
}
