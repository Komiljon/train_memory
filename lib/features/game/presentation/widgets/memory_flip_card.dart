import 'package:flip_card/flip_card.dart';
import 'package:flip_card/flip_card_controller.dart';
import 'package:flutter/material.dart';

import '../../../../core/theme/app_tokens.dart';
import '../../../../core/theme/game_card_theme.dart';
import '../../domain/entities/deck_kind.dart';
import '../../domain/entities/memory_card.dart';
import 'game_card_shell.dart';
import 'pair_face_mapper.dart';
import 'playing_card_face.dart';
import 'themed_card_back.dart';

/// Одна карта на поле: единая оболочка, flip и micro-interactions.
class MemoryFlipCard extends StatefulWidget {
  const MemoryFlipCard({
    super.key,
    required this.card,
    required this.mapper,
    required this.deckKind,
    required this.onTap,
    required this.enabled,
    this.isResolvingMismatch = false,
  });

  final MemoryCard card;
  final PairFaceMapper mapper;
  final DeckKind deckKind;
  final VoidCallback onTap;
  final bool enabled;

  /// Карта участвует в несовпадении — лёгкий shake.
  final bool isResolvingMismatch;

  @override
  State<MemoryFlipCard> createState() => _MemoryFlipCardState();
}

class _MemoryFlipCardState extends State<MemoryFlipCard>
    with TickerProviderStateMixin {
  final FlipCardController _controller = FlipCardController();
  late final AnimationController _shakeController;
  late final AnimationController _matchController;
  late final Animation<double> _shakeAnimation;
  late final Animation<double> _matchScale;

  bool _wasMatched = false;
  bool _showMatchGlow = false;

  @override
  void initState() {
    super.initState();
    _wasMatched = widget.card.isMatched;

    _shakeController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 220),
    );
    _shakeAnimation = TweenSequence<double>([
      TweenSequenceItem(tween: Tween(begin: 0, end: -6), weight: 1),
      TweenSequenceItem(tween: Tween(begin: -6, end: 6), weight: 2),
      TweenSequenceItem(tween: Tween(begin: 6, end: -4), weight: 2),
      TweenSequenceItem(tween: Tween(begin: -4, end: 0), weight: 1),
    ]).animate(CurvedAnimation(
      parent: _shakeController,
      curve: Curves.easeInOut,
    ));

    _matchController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 280),
    );
    _matchScale = TweenSequence<double>([
      TweenSequenceItem(tween: Tween(begin: 1, end: 1.05), weight: 50),
      TweenSequenceItem(tween: Tween(begin: 1.05, end: 1), weight: 50),
    ]).animate(CurvedAnimation(
      parent: _matchController,
      curve: Curves.easeOut,
    ));

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

    if (!oldWidget.isResolvingMismatch && widget.isResolvingMismatch) {
      _shakeController.forward(from: 0);
    }

    if (!_wasMatched && widget.card.isMatched) {
      _wasMatched = true;
      _showMatchGlow = true;
      _matchController.forward(from: 0).then((_) {
        if (mounted) {
          setState(() => _showMatchGlow = false);
        }
      });
    }
  }

  @override
  void dispose() {
    _shakeController.dispose();
    _matchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final cardTheme = context.gameCardTheme;
    final tokens = context.appTokens;
    final label = widget.mapper.labelFor(widget.card.pairId);
    final isPlayingCards = widget.deckKind == DeckKind.playingCards;

    final borderColor = widget.card.isMatched ? cardTheme.matchedBorder : null;
    final opacity = widget.card.isMatched ? cardTheme.matchedOpacity : 1.0;

    final cardContent =
        isPlayingCards ? _playingCardFlip(label) : _themedCardFlip(label);

    return Semantics(
      button: true,
      enabled: widget.enabled,
      label: widget.card.isFaceUp || widget.card.isMatched
          ? 'Карта $label'
          : 'Закрытая карта',
      child: AnimatedBuilder(
        animation: Listenable.merge([_shakeController, _matchController]),
        builder: (context, child) {
          return Transform.translate(
            offset: Offset(_shakeAnimation.value, 0),
            child: Transform.scale(
              scale: _matchScale.value,
              child: child,
            ),
          );
        },
        child: Material(
          color: Colors.transparent,
          child: InkWell(
            onTap: widget.enabled ? widget.onTap : null,
            borderRadius: BorderRadius.circular(tokens.radiusCard),
            child: GameCardShell(
              borderColor: borderColor,
              opacity: opacity,
              glow: _showMatchGlow,
              child: cardContent,
            ),
          ),
        ),
      ),
    );
  }

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
              front: const ThemedCardBack(),
              back: rank != null && suit != null
                  ? PlayingCardFace(rank: rank, suit: suit)
                  : _fallbackFace(label),
            ),
          ),
        );
      },
    );
  }

  Widget _themedCardFlip(String label) {
    final scheme = Theme.of(context).colorScheme;
    final cardTheme = context.gameCardTheme;
    final faceColor = widget.mapper.colorFor(widget.card.pairId, scheme);

    return FlipCard(
      key: ValueKey('flip_${widget.card.id}'),
      controller: _controller,
      flipOnTouch: false,
      direction: FlipDirection.HORIZONTAL,
      front: const ThemedCardBack(),
      back: _ThemedFaceSide(
        background: cardTheme.faceBackground,
        child: _ThemedFaceContent(
          pairId: widget.card.pairId,
          mapper: widget.mapper,
          label: label,
          accentColor: faceColor,
        ),
      ),
    );
  }

  Widget _fallbackFace(String label) {
    return _ThemedFaceSide(
      background: context.gameCardTheme.faceBackground,
      child: Text(label),
    );
  }
}

class _ThemedFaceSide extends StatelessWidget {
  const _ThemedFaceSide({
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
      color: background,
      alignment: Alignment.center,
      child: child,
    );
  }
}

class _ThemedFaceContent extends StatelessWidget {
  const _ThemedFaceContent({
    required this.pairId,
    required this.mapper,
    required this.label,
    required this.accentColor,
  });

  final String pairId;
  final PairFaceMapper mapper;
  final String label;
  final Color accentColor;

  @override
  Widget build(BuildContext context) {
    final tokens = context.appTokens;

    return Padding(
      padding: EdgeInsets.all(tokens.spacingXs),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          _FaceBadge(
            accentColor: accentColor,
            child: _FaceGlyph(
              pairId: pairId,
              mapper: mapper,
              accentColor: accentColor,
            ),
          ),
          SizedBox(height: tokens.spacingXs),
          Text(
            label,
            style: Theme.of(context).textTheme.labelSmall,
            textAlign: TextAlign.center,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
        ],
      ),
    );
  }
}

/// Круглый badge — единый контейнер для emoji, цифр и иконок.
class _FaceBadge extends StatelessWidget {
  const _FaceBadge({
    required this.accentColor,
    required this.child,
  });

  final Color accentColor;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 52,
      height: 52,
      decoration: BoxDecoration(
        color: accentColor.withValues(alpha: 0.18),
        shape: BoxShape.circle,
        border: Border.all(
          color: accentColor.withValues(alpha: 0.35),
        ),
      ),
      alignment: Alignment.center,
      child: child,
    );
  }
}

class _FaceGlyph extends StatelessWidget {
  const _FaceGlyph({
    required this.pairId,
    required this.mapper,
    required this.accentColor,
  });

  final String pairId;
  final PairFaceMapper mapper;
  final Color accentColor;

  @override
  Widget build(BuildContext context) {
    final assetPath = mapper.assetPathFor(pairId);
    if (assetPath != null) {
      return ClipOval(
        child: Image.asset(
          assetPath,
          width: 40,
          height: 40,
          fit: BoxFit.cover,
          errorBuilder: (_, __, ___) => Icon(
            mapper.iconFor(pairId),
            size: 28,
            color: accentColor,
          ),
        ),
      );
    }

    final glyph = mapper.glyphFor(pairId);
    if (glyph != null) {
      final isDigit = glyph.length == 1 && int.tryParse(glyph) != null;
      return FittedBox(
        fit: BoxFit.scaleDown,
        child: Text(
          glyph,
          style: TextStyle(
            fontSize: isDigit ? 28 : 26,
            fontWeight: isDigit ? FontWeight.w700 : FontWeight.normal,
            height: 1,
            color: isDigit ? accentColor : null,
          ),
        ),
      );
    }

    return Icon(mapper.iconFor(pairId), size: 28, color: accentColor);
  }
}
