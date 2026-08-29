import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/theme/app_tokens.dart';
import '../../domain/entities/deck_kind.dart';
import '../extensions/deck_kind_ui.dart';
import '../providers/game_providers.dart';
import 'themed_card_back.dart';

/// Боковое меню выбора колоды с иконками и описаниями.
class DeckPickerDrawer extends ConsumerWidget {
  const DeckPickerDrawer({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final selected = ref.watch(selectedDeckProvider);
    final tokens = context.appTokens;
    final scheme = Theme.of(context).colorScheme;

    return Drawer(
      child: SafeArea(
        child: Semantics(
          label: 'Выбор колоды',
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Padding(
                padding: EdgeInsets.all(tokens.spacingLg),
                child: Row(
                  children: [
                    Image.asset(
                      'assets/images/brand/logo_mark.png',
                      width: 40,
                      height: 40,
                      errorBuilder: (_, __, ___) => Icon(
                        Icons.style_rounded,
                        size: 36,
                        color: scheme.primary,
                      ),
                    ),
                    SizedBox(width: tokens.spacingMd),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Выберите колоду',
                            style: Theme.of(context).textTheme.titleLarge,
                          ),
                          Text(
                            '8 пар на поле 4×4',
                            style: Theme.of(context).textTheme.bodySmall,
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              Expanded(
                child: ListView(
                  padding: EdgeInsets.symmetric(horizontal: tokens.spacingMd),
                  children: [
                    for (final kind in DeckKind.values)
                      _DeckOptionCard(
                        key: Key('deck_option_${kind.name}'),
                        kind: kind,
                        selected: selected == kind,
                        onTap: () => _selectDeck(context, ref, kind),
                      ),
                  ],
                ),
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

class _DeckOptionCard extends StatelessWidget {
  const _DeckOptionCard({
    super.key,
    required this.kind,
    required this.selected,
    required this.onTap,
  });

  final DeckKind kind;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final tokens = context.appTokens;
    final accent = kind.deckAccentColor(scheme);

    return Padding(
      padding: EdgeInsets.only(bottom: tokens.spacingSm),
      child: Material(
        color: selected
            ? scheme.primaryContainer.withValues(alpha: 0.35)
            : scheme.surfaceContainerHighest,
        borderRadius: BorderRadius.circular(tokens.radiusChip),
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(tokens.radiusChip),
          child: Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(tokens.radiusChip),
              border: Border.all(
                color: selected ? scheme.primary : scheme.outlineVariant,
                width: selected ? 1.5 : 1,
              ),
            ),
            padding: EdgeInsets.all(tokens.spacingMd),
            child: Row(
              children: [
                Container(
                  width: 44,
                  height: 44,
                  decoration: BoxDecoration(
                    color: accent.withValues(alpha: 0.2),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Image.asset(
                    kind.deckIconAsset,
                    fit: BoxFit.contain,
                    errorBuilder: (_, __, ___) => Icon(
                      kind.deckFallbackIcon,
                      color: accent,
                    ),
                  ),
                ),
                SizedBox(width: tokens.spacingMd),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        kind.drawerTitle,
                        style: Theme.of(context).textTheme.titleSmall,
                      ),
                      Text(
                        kind.deckSubtitle,
                        style: Theme.of(context).textTheme.bodySmall,
                      ),
                    ],
                  ),
                ),
                SizedBox(
                  width: 28,
                  height: 28,
                  child: selected
                      ? Icon(Icons.check_circle_rounded, color: scheme.primary)
                      : _MiniCardPreview(),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

/// Мини-превью рубашки: 2×2 сетка из 4 клеток.
class _MiniCardPreview extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return GridView.count(
      crossAxisCount: 2,
      mainAxisSpacing: 2,
      crossAxisSpacing: 2,
      physics: const NeverScrollableScrollPhysics(),
      children: List.generate(
        4,
        (_) => const ClipRRect(
          borderRadius: BorderRadius.all(Radius.circular(2)),
          child: ThemedCardBack(compact: true),
        ),
      ),
    );
  }
}
