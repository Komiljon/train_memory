import 'package:flip_card/flip_card.dart';
import 'package:flip_card/flip_card_controller.dart';
import 'package:flutter/material.dart';

import '../../domain/entities/deck_kind.dart';
import '../../domain/entities/memory_card.dart';
import 'pair_face_mapper.dart';
import 'playing_card_back.dart';
import 'playing_card_face.dart';

/// Одна карта на поле: FlipCard изолирован, flipOnTouch=false — логика в Notifier.
class MemoryFlipCard extends StatefulWidget {
  const MemoryFlipCard({
    super.key,
    required this.card,
    required this.mapper,
    required this.deckKind,
    required this.onTap,
    required this.enabled,
  });

  final MemoryCard card;
  final PairFaceMapper mapper;
  final DeckKind deckKind;
  final VoidCallback onTap;
  final bool enabled;

  @override
  State<MemoryFlipCard> createState() => _MemoryFlipCardState();
}

class _MemoryFlipCardState extends State<MemoryFlipCard> {
  final FlipCardController _controller = FlipCardController();

  static const double _borderRadius = 12;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (widget.card.isFaceUp) {
        _controller.toggleCardWithoutAnimation();
      }
    });
  }

  @override
  void didUpdateWidget(MemoryFlipCard oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.card.isFaceUp != widget.card.isFaceUp) {
      _controller.toggleCard();
    }
  }

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final label = widget.mapper.labelFor(widget.card.pairId);
    final isPlayingCards = widget.deckKind == DeckKind.playingCards;

    final Widget cardContent = isPlayingCards
        ? _playingCardFlip(label)
        : _natureCardFlip(scheme, label);

    return Semantics(
      button: true,
      enabled: widget.enabled,
      label: widget.card.isFaceUp || widget.card.isMatched
          ? 'Карта $label'
          : 'Закрытая карта',
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: widget.enabled ? widget.onTap : null,
          borderRadius: BorderRadius.circular(_borderRadius),
          child: cardContent,
        ),
      ),
    );
  }

  /// Игральная карта: пропорция 5:7 внутри клетки, чтобы не растягивать в блин.
  Widget _playingCardFlip(String label) {
    final rank = widget.mapper.rankFor(widget.card.pairId);
    final suit = widget.mapper.suitFor(widget.card.pairId);

    return LayoutBuilder(
      builder: (context, constraints) {
        final maxW = constraints.maxWidth;
        final maxH = constraints.maxHeight;
        const aspect = 5 / 7;

        double cardW = maxW;
        double cardH = cardW / aspect;
        if (cardH > maxH) {
          cardH = maxH;
          cardW = cardH * aspect;
        }

        return Align(
          child: SizedBox(
            width: cardW,
            height: cardH,
            child: FlipCard(
              key: ValueKey('flip_${widget.card.id}'),
              controller: _controller,
              flipOnTouch: false,
              direction: FlipDirection.HORIZONTAL,
              front: const PlayingCardBack(),
              back: rank != null && suit != null
                  ? PlayingCardFace(rank: rank, suit: suit)
                  : _fallbackFace(label),
            ),
          ),
        );
      },
    );
  }

  Widget _natureCardFlip(ColorScheme scheme, String label) {
    final faceColor = widget.mapper.colorFor(widget.card.pairId, scheme);

    return FlipCard(
      key: ValueKey('flip_${widget.card.id}'),
      controller: _controller,
      flipOnTouch: false,
      direction: FlipDirection.HORIZONTAL,
      front: _CardSide(
        background: scheme.primaryContainer,
        child: FittedBox(
          fit: BoxFit.scaleDown,
          child: Icon(
            Icons.question_mark_rounded,
            size: 36,
            color: scheme.onPrimaryContainer,
          ),
        ),
      ),
      back: _CardSide(
        background: faceColor.withValues(alpha: 0.25),
        child: _NatureFaceContent(
          pairId: widget.card.pairId,
          mapper: widget.mapper,
          label: label,
          iconColor: faceColor,
        ),
      ),
    );
  }

  Widget _fallbackFace(String label) {
    return _CardSide(
      background: Theme.of(context).colorScheme.surface,
      child: Text(label),
    );
  }
}

class _CardSide extends StatelessWidget {
  const _CardSide({
    required this.background,
    required this.child,
  });

  final Color background;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: double.infinity,
      decoration: BoxDecoration(
        color: background,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: Theme.of(context).colorScheme.outlineVariant,
        ),
      ),
      alignment: Alignment.center,
      child: child,
    );
  }
}

class _NatureFaceContent extends StatelessWidget {
  const _NatureFaceContent({
    required this.pairId,
    required this.mapper,
    required this.label,
    required this.iconColor,
  });

  final String pairId;
  final PairFaceMapper mapper;
  final String label;
  final Color iconColor;

  @override
  Widget build(BuildContext context) {
    final assetPath = mapper.assetPathFor(pairId);
    if (assetPath != null) {
      return Padding(
        padding: const EdgeInsets.all(4),
        child: Image.asset(
          assetPath,
          fit: BoxFit.contain,
          errorBuilder: (_, __, ___) => Icon(
            mapper.iconFor(pairId),
            size: 32,
            color: iconColor,
          ),
        ),
      );
    }

    // FittedBox: в клетке 4×4 иконка+подпись сжимаются, а не вылезают за край.
    return FittedBox(
      fit: BoxFit.scaleDown,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 4),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(mapper.iconFor(pairId), size: 32, color: iconColor),
            const SizedBox(height: 2),
            Text(
              label,
              style: Theme.of(context).textTheme.labelSmall,
              textAlign: TextAlign.center,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ],
        ),
      ),
    );
  }
}
